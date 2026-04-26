import { useState, useEffect, useRef, useCallback } from "react";

// ─── CONSTANTS ───────────────────────────────────────────────────────────────
const PART_TYPES = ["Cabeça","Tronco","Braço Esq","Braço Dir","Perna Esq","Perna Dir","Cauda","Asa","Chifre","Orbe"];
const COLORS = ["#ff4444","#ff8800","#ffdd00","#44ff44","#00ccff","#8844ff","#ff44cc","#ffffff","#aaaaaa","#00ffcc"];
const POWER_TYPES = ["Teleporte","Dash","Explosão","Escudo","Raio","Gelo","Fogo","Vento","Gravidade","Cura"];
const EFFECTS = ["Partículas","Brilho","Rastro","Onda de choque","Aura","Névoa","Faíscas","Cristais","Chamas","Pulso"];
const MAPS = [
  { id:"escola", name:"🏫 Escola", color:"#e8f4fd", desc:"Aulas, corredores e pátio" },
  { id:"floresta", name:"🌲 Floresta", color:"#d4edda", desc:"Árvores e segredos" },
  { id:"cidade", name:"🌆 Cidade", color:"#f0f0f0", desc:"Prédios e ruas" },
  { id:"vulcao", name:"🌋 Vulcão", color:"#ffe5d0", desc:"Lava e pedras" },
  { id:"espaco", name:"🌌 Espaço", color:"#0a0a1a", desc:"Sem gravidade" },
];
const GENDER_OPTIONS = ["Masculino","Feminino","Neutro","Monstro","Robô","Alienígena"];

// ─── PHYSICS ENGINE (simple) ──────────────────────────────────────────────────
function usePhysics(active, mapId) {
  const [entities, setEntities] = useState([]);
  const [player, setPlayer] = useState({ x:300, y:300, vx:0, vy:0, onGround:false, power:null, effects:[] });
  const keysRef = useRef({});
  const rafRef = useRef(null);
  const gravity = mapId === "espaco" ? 0.05 : 0.5;

  useEffect(() => {
    if (!active) return;
    const onKey = (e) => { keysRef.current[e.code] = e.type === "keydown"; };
    window.addEventListener("keydown", onKey);
    window.addEventListener("keyup", onKey);
    return () => { window.removeEventListener("keydown", onKey); window.removeEventListener("keyup", onKey); };
  }, [active]);

  useEffect(() => {
    if (!active) { cancelAnimationFrame(rafRef.current); return; }
    const FLOOR = 460;
    const tick = () => {
      setPlayer(p => {
        let { x, y, vx, vy, onGround } = p;
        if (keysRef.current["ArrowLeft"] || keysRef.current["KeyA"]) vx -= 0.8;
        if (keysRef.current["ArrowRight"] || keysRef.current["KeyD"]) vx += 0.8;
        if ((keysRef.current["Space"] || keysRef.current["ArrowUp"]) && onGround) vy = -12;
        vy += gravity;
        vx *= 0.85;
        x += vx; y += vy;
        if (y >= FLOOR) { y = FLOOR; vy = 0; onGround = true; } else onGround = false;
        if (x < 10) x = 10;
        if (x > 790) x = 790;
        return { ...p, x, y, vx, vy, onGround };
      });
      rafRef.current = requestAnimationFrame(tick);
    };
    rafRef.current = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(rafRef.current);
  }, [active, gravity]);

  return { player, setPlayer };
}

// ─── CANVAS RENDERER ──────────────────────────────────────────────────────────
function GameCanvas({ player, character, mapId, activePower, testMode }) {
  const canvasRef = useRef(null);
  const tick = useRef(0);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    let raf;
    const map = MAPS.find(m=>m.id===mapId) || MAPS[0];

    const drawMap = () => {
      // Background
      ctx.fillStyle = map.color;
      ctx.fillRect(0,0,800,500);

      if (mapId === "espaco") {
        // Stars
        ctx.fillStyle = "#ffffff";
        for (let i=0;i<80;i++) { const sx=(i*137)%800, sy=(i*97)%500; ctx.fillRect(sx,sy,2,2); }
        ctx.fillStyle = "#111133";
        ctx.fillRect(0,460,800,40);
      } else if (mapId === "escola") {
        // Ground
        ctx.fillStyle = "#c8a97a"; ctx.fillRect(0,460,800,40);
        // Building
        ctx.fillStyle = "#e8d5c0"; ctx.fillRect(50,200,300,260);
        ctx.fillStyle = "#c9b89a"; ctx.fillRect(50,200,300,30);
        // Windows
        for(let i=0;i<3;i++) for(let j=0;j<3;j++){
          ctx.fillStyle="#aaddff"; ctx.fillRect(80+i*90,240+j*60,50,40);
          ctx.strokeStyle="#888"; ctx.lineWidth=2; ctx.strokeRect(80+i*90,240+j*60,50,40);
        }
        // Blackboard
        ctx.fillStyle="#2d5a1b"; ctx.fillRect(500,230,240,120);
        ctx.fillStyle="#ffffff"; ctx.font="14px monospace";
        ctx.fillText("2+2=4  π=3.14",515,265);
        ctx.fillText("E=mc²  a²+b²=c²",515,290);
        ctx.fillText("∫f(x)dx  ΔV=λ/f",515,315);
        ctx.fillStyle="#c8a97a"; ctx.fillRect(0,460,800,40);
      } else if (mapId === "floresta") {
        ctx.fillStyle = "#6b9e2d"; ctx.fillRect(0,460,800,40);
        // Trees
        [[100,380],[250,350],[500,370],[680,360]].forEach(([tx,ty])=>{
          ctx.fillStyle="#5a3010"; ctx.fillRect(tx-10,ty,20,100);
          ctx.fillStyle="#2d7d1a"; ctx.beginPath(); ctx.arc(tx,ty,50,0,Math.PI*2); ctx.fill();
          ctx.fillStyle="#3a9022"; ctx.beginPath(); ctx.arc(tx,ty-20,35,0,Math.PI*2); ctx.fill();
        });
        ctx.fillStyle="#6b9e2d"; ctx.fillRect(0,460,800,40);
      } else if (mapId === "vulcao") {
        ctx.fillStyle="#333"; ctx.fillRect(0,460,800,40);
        // Volcano
        ctx.fillStyle="#555"; ctx.beginPath(); ctx.moveTo(400,100); ctx.lineTo(550,460); ctx.lineTo(250,460); ctx.closePath(); ctx.fill();
        // Lava
        ctx.fillStyle="#ff4400"; for(let i=0;i<5;i++){const lx=380+Math.sin(tick.current*0.05+i)*10; ctx.fillRect(lx,140+i*40,20,40);}
        ctx.fillStyle="#333"; ctx.fillRect(0,460,800,40);
      } else if (mapId === "cidade") {
        ctx.fillStyle="#888"; ctx.fillRect(0,460,800,40);
        // Buildings
        [[50,200,80,260],[160,150,60,310],[250,250,100,210],[400,180,70,280],[500,220,90,240],[620,160,80,300],[720,240,60,220]].forEach(([bx,by,bw,bh])=>{
          ctx.fillStyle=`hsl(${bx},10%,${40+bx%20}%)`; ctx.fillRect(bx,by,bw,bh);
          for(let wi=0;wi<Math.floor(bw/20);wi++) for(let hi=0;hi<Math.floor(bh/25);hi++){
            ctx.fillStyle=Math.random()<0.7?"#ffe88a":"#223"; ctx.fillRect(bx+5+wi*20,by+8+hi*25,12,15);
          }
        });
        ctx.fillStyle="#666"; ctx.fillRect(0,450,800,50);
        ctx.fillStyle="#fff"; for(let i=0;i<8;i++) ctx.fillRect(50+i*90,468,50,5);
      }

      // Floor line
      ctx.strokeStyle="rgba(0,0,0,0.2)"; ctx.lineWidth=2;
      ctx.beginPath(); ctx.moveTo(0,460); ctx.lineTo(800,460); ctx.stroke();
    };

    const drawCharacter = () => {
      const { x, y } = player;
      const parts = character?.parts || [];
      const cx = x, cy = y;

      // Draw shadow
      ctx.fillStyle="rgba(0,0,0,0.15)";
      ctx.beginPath(); ctx.ellipse(cx,470,20,6,0,0,Math.PI*2); ctx.fill();

      // Draw parts
      parts.forEach(part => {
        ctx.save();
        ctx.translate(cx + part.offsetX, cy - 40 + part.offsetY);
        ctx.rotate(part.rotation * Math.PI / 180);
        ctx.scale(part.scale, part.scale);
        ctx.fillStyle = part.color;
        ctx.strokeStyle = "rgba(0,0,0,0.4)"; ctx.lineWidth = 2;

        if (part.shape === "circle" || part.name === "Cabeça" || part.name === "Orbe") {
          ctx.beginPath(); ctx.arc(0,0,part.size/2,0,Math.PI*2);
          ctx.fill(); ctx.stroke();
        } else if (part.name === "Asa") {
          ctx.beginPath(); ctx.moveTo(0,0); ctx.quadraticCurveTo(part.size,-part.size*0.8,part.size*0.5,0);
          ctx.quadraticCurveTo(0,part.size*0.3,0,0); ctx.fill();
        } else {
          const w = part.size * 0.6, h = part.size;
          ctx.beginPath(); ctx.roundRect(-w/2,-h/2,w,h,4);
          ctx.fill(); ctx.stroke();
        }

        // Glow effect
        if (part.effects?.includes("Brilho") || activePower) {
          ctx.shadowColor = part.color; ctx.shadowBlur = 15;
          ctx.strokeStyle = part.color; ctx.lineWidth = 3;
          if (part.name === "Cabeça" || part.name === "Orbe") {
            ctx.beginPath(); ctx.arc(0,0,part.size/2+3,0,Math.PI*2); ctx.stroke();
          }
          ctx.shadowBlur = 0;
        }
        ctx.restore();
      });

      // Active power effect
      if (activePower) {
        tick.current++;
        const t = tick.current;
        ctx.save();
        ctx.globalAlpha = 0.7;
        if (activePower === "Teleporte") {
          ctx.strokeStyle = "#8844ff"; ctx.lineWidth = 3;
          for(let i=0;i<3;i++){
            ctx.beginPath(); ctx.arc(cx,cy-30,(t%30+i*10),0,Math.PI*2);
            ctx.globalAlpha = (1-(t%30+i*10)/40)*0.6; ctx.stroke();
          }
        } else if (activePower === "Fogo" || activePower === "Explosão") {
          for(let i=0;i<8;i++){
            const a=i*Math.PI/4+t*0.1, r=20+Math.sin(t*0.2+i)*5;
            ctx.fillStyle=`hsl(${20+i*5},100%,${50+i*3}%)`;
            ctx.beginPath(); ctx.arc(cx+Math.cos(a)*r,cy-30+Math.sin(a)*r,5,0,Math.PI*2);
            ctx.fill();
          }
        } else if (activePower === "Gelo") {
          ctx.strokeStyle="#aaddff"; ctx.lineWidth=2;
          for(let i=0;i<6;i++){
            const a=i*Math.PI/3+t*0.02;
            ctx.beginPath(); ctx.moveTo(cx,cy-30);
            ctx.lineTo(cx+Math.cos(a)*30,cy-30+Math.sin(a)*30); ctx.stroke();
          }
        } else if (activePower === "Raio") {
          ctx.strokeStyle="#ffff00"; ctx.lineWidth=3; ctx.shadowColor="#ffff00"; ctx.shadowBlur=10;
          ctx.beginPath(); ctx.moveTo(cx,cy-80);
          for(let i=1;i<8;i++) ctx.lineTo(cx+(Math.random()-0.5)*20,cy-80+i*10);
          ctx.stroke(); ctx.shadowBlur=0;
        } else if (activePower === "Escudo") {
          ctx.strokeStyle="#00ccff"; ctx.lineWidth=4; ctx.globalAlpha=0.5;
          ctx.beginPath(); ctx.arc(cx,cy-30,40+Math.sin(t*0.1)*3,0,Math.PI*2); ctx.stroke();
        } else if (activePower === "Dash") {
          ctx.fillStyle="#ffffff";
          for(let i=1;i<=4;i++) { ctx.globalAlpha=0.15*i; ctx.fillRect(cx-i*15-10,cy-50,20,40); }
        }
        ctx.restore();
      }
    };

    const render = () => {
      ctx.clearRect(0,0,800,500);
      tick.current++;
      drawMap();
      drawCharacter();
      raf = requestAnimationFrame(render);
    };
    raf = requestAnimationFrame(render);
    return () => cancelAnimationFrame(raf);
  }, [player, character, mapId, activePower]);

  return (
    <canvas ref={canvasRef} width={800} height={500}
      style={{ width:"100%", borderRadius:"8px", display:"block", background:"#1a1a2e" }} />
  );
}

// ─── PART EDITOR ──────────────────────────────────────────────────────────────
function PartEditor({ part, onChange, onRemove }) {
  return (
    <div style={{background:"rgba(255,255,255,0.07)",borderRadius:10,padding:12,marginBottom:8,border:"1px solid rgba(255,255,255,0.12)"}}>
      <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:8}}>
        <span style={{fontWeight:700,color:"#fff",fontSize:13}}>{part.name}</span>
        <button onClick={onRemove} style={{background:"#ff4444",border:"none",borderRadius:5,color:"#fff",padding:"2px 8px",cursor:"pointer",fontSize:12}}>✕</button>
      </div>
      <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:6}}>
        <label style={{color:"#aaa",fontSize:11}}>
          Cor
          <div style={{display:"flex",gap:4,marginTop:3,flexWrap:"wrap"}}>
            {COLORS.map(c=>(
              <div key={c} onClick={()=>onChange({...part,color:c})}
                style={{width:16,height:16,borderRadius:"50%",background:c,cursor:"pointer",
                  border:part.color===c?"2px solid white":"2px solid transparent"}} />
            ))}
          </div>
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Tamanho: {part.size}
          <input type="range" min={10} max={60} value={part.size} onChange={e=>onChange({...part,size:+e.target.value})}
            style={{display:"block",width:"100%",marginTop:3,accentColor:"#8844ff"}} />
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Rotação: {part.rotation}°
          <input type="range" min={-180} max={180} value={part.rotation} onChange={e=>onChange({...part,rotation:+e.target.value})}
            style={{display:"block",width:"100%",marginTop:3,accentColor:"#8844ff"}} />
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Escala: {part.scale}x
          <input type="range" min={0.5} max={3} step={0.1} value={part.scale} onChange={e=>onChange({...part,scale:+e.target.value})}
            style={{display:"block",width:"100%",marginTop:3,accentColor:"#8844ff"}} />
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Pos X: {part.offsetX}
          <input type="range" min={-60} max={60} value={part.offsetX} onChange={e=>onChange({...part,offsetX:+e.target.value})}
            style={{display:"block",width:"100%",marginTop:3,accentColor:"#8844ff"}} />
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Pos Y: {part.offsetY}
          <input type="range" min={-80} max={80} value={part.offsetY} onChange={e=>onChange({...part,offsetY:+e.target.value})}
            style={{display:"block",width:"100%",marginTop:3,accentColor:"#8844ff"}} />
        </label>
      </div>
      <div style={{marginTop:8}}>
        <span style={{color:"#aaa",fontSize:11}}>Efeitos:</span>
        <div style={{display:"flex",flexWrap:"wrap",gap:4,marginTop:4}}>
          {EFFECTS.map(ef=>(
            <button key={ef} onClick={()=>{
              const efx = part.effects||[];
              onChange({...part, effects: efx.includes(ef)?efx.filter(e=>e!==ef):[...efx,ef]});
            }} style={{
              padding:"2px 6px",fontSize:10,borderRadius:4,cursor:"pointer",border:"none",
              background:part.effects?.includes(ef)?"#8844ff":"rgba(255,255,255,0.1)",
              color:part.effects?.includes(ef)?"#fff":"#aaa"
            }}>{ef}</button>
          ))}
        </div>
      </div>
    </div>
  );
}

// ─── POWER EDITOR ─────────────────────────────────────────────────────────────
function PowerEditor({ power, onChange, onRemove }) {
  return (
    <div style={{background:"rgba(255,255,255,0.07)",borderRadius:10,padding:12,marginBottom:8,border:"1px solid rgba(255,255,255,0.12)"}}>
      <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:8}}>
        <input value={power.name} onChange={e=>onChange({...power,name:e.target.value})}
          style={{background:"transparent",border:"1px solid rgba(255,255,255,0.2)",borderRadius:5,color:"#fff",padding:"2px 6px",fontSize:13,fontWeight:700,width:130}} />
        <button onClick={onRemove} style={{background:"#ff4444",border:"none",borderRadius:5,color:"#fff",padding:"2px 8px",cursor:"pointer",fontSize:12}}>✕</button>
      </div>
      <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:6}}>
        <label style={{color:"#aaa",fontSize:11}}>
          Tipo
          <select value={power.type} onChange={e=>onChange({...power,type:e.target.value})}
            style={{display:"block",marginTop:3,background:"#1a1a2e",color:"#fff",border:"1px solid rgba(255,255,255,0.2)",borderRadius:4,padding:"3px 6px",fontSize:11,width:"100%"}}>
            {POWER_TYPES.map(t=><option key={t}>{t}</option>)}
          </select>
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Dano/Efeito: {power.power}
          <input type="range" min={1} max={100} value={power.power} onChange={e=>onChange({...power,power:+e.target.value})}
            style={{display:"block",width:"100%",marginTop:3,accentColor:"#ff4444"}} />
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Cooldown: {power.cooldown}s
          <input type="range" min={0.1} max={10} step={0.1} value={power.cooldown} onChange={e=>onChange({...power,cooldown:+e.target.value})}
            style={{display:"block",width:"100%",marginTop:3,accentColor:"#ff8800"}} />
        </label>
        <label style={{color:"#aaa",fontSize:11}}>
          Cor do Efeito
          <div style={{display:"flex",gap:3,marginTop:3,flexWrap:"wrap"}}>
            {COLORS.map(c=>(
              <div key={c} onClick={()=>onChange({...power,color:c})}
                style={{width:14,height:14,borderRadius:"50%",background:c,cursor:"pointer",
                  border:power.color===c?"2px solid white":"2px solid transparent"}} />
            ))}
          </div>
        </label>
      </div>
    </div>
  );
}

// ─── PUBLISHED MAPS ───────────────────────────────────────────────────────────
function PublishedMaps({ published, onPlay }) {
  if (published.length === 0) return (
    <div style={{textAlign:"center",color:"#666",padding:40}}>
      <div style={{fontSize:48,marginBottom:8}}>🗺️</div>
      <div>Nenhum mapa publicado ainda.<br/>Crie seu personagem e publique!</div>
    </div>
  );
  return (
    <div style={{display:"grid",gridTemplateColumns:"repeat(auto-fill,minmax(200px,1fr))",gap:12}}>
      {published.map((p,i)=>(
        <div key={i} style={{background:"rgba(255,255,255,0.07)",borderRadius:12,padding:16,border:"1px solid rgba(255,255,255,0.1)"}}>
          <div style={{fontSize:24,marginBottom:4}}>{MAPS.find(m=>m.id===p.mapId)?.name||"🗺️"}</div>
          <div style={{color:"#fff",fontWeight:700,marginBottom:2}}>{p.characterName}</div>
          <div style={{color:"#aaa",fontSize:11,marginBottom:4}}>{MAPS.find(m=>m.id===p.mapId)?.desc}</div>
          <div style={{color:"#888",fontSize:10,marginBottom:8}}>{p.powers?.length||0} poderes • {p.parts?.length||0} partes • {p.gender}</div>
          <button onClick={()=>onPlay(p)} style={{
            width:"100%",padding:"6px",background:"linear-gradient(90deg,#8844ff,#00ccff)",
            border:"none",borderRadius:6,color:"#fff",cursor:"pointer",fontWeight:700,fontSize:12
          }}>▶ Jogar</button>
        </div>
      ))}
    </div>
  );
}

// ─── MAIN APP ─────────────────────────────────────────────────────────────────
export default function App() {
  const [tab, setTab] = useState("criar"); // criar | poderes | testar | mapas | publicados
  const [character, setCharacter] = useState({
    name: "Meu Personagem",
    gender: "Masculino",
    parts: [
      { id:1, name:"Cabeça",   color:"#ff8800", size:32, rotation:0, scale:1, offsetX:0,  offsetY:-40, effects:[] },
      { id:2, name:"Tronco",   color:"#4488ff", size:40, rotation:0, scale:1, offsetX:0,  offsetY:0,   effects:[] },
      { id:3, name:"Braço Esq",color:"#4488ff", size:28, rotation:20,scale:1, offsetX:-22,offsetY:5,  effects:[] },
      { id:4, name:"Braço Dir",color:"#4488ff", size:28, rotation:-20,scale:1,offsetX:22, offsetY:5,  effects:[] },
      { id:5, name:"Perna Esq",color:"#2244cc", size:32, rotation:5, scale:1, offsetX:-10,offsetY:32, effects:[] },
      { id:6, name:"Perna Dir",color:"#2244cc", size:32, rotation:-5,scale:1, offsetX:10, offsetY:32, effects:[] },
    ],
    powers: [
      { id:1, name:"Teleporte", type:"Teleporte", power:50, cooldown:2, color:"#8844ff" },
      { id:2, name:"Chama",     type:"Fogo",      power:30, cooldown:1, color:"#ff4400" },
    ]
  });
  const [selectedMap, setSelectedMap] = useState("escola");
  const [testMode, setTestMode] = useState(false);
  const [activePower, setActivePower] = useState(null);
  const [published, setPublished] = useState([]);
  const [nextId, setNextId] = useState(10);
  const { player, setPlayer } = usePhysics(testMode, selectedMap);

  const newId = () => { setNextId(n=>n+1); return nextId; };

  const addPart = (partName) => {
    setCharacter(c=>({...c, parts:[...c.parts, {
      id:newId(), name:partName, color:COLORS[Math.floor(Math.random()*COLORS.length)],
      size:28, rotation:0, scale:1, offsetX:0, offsetY:0, effects:[]
    }]}));
  };
  const updatePart = (id, updated) => setCharacter(c=>({...c, parts:c.parts.map(p=>p.id===id?updated:p)}));
  const removePart = (id) => setCharacter(c=>({...c, parts:c.parts.filter(p=>p.id!==id)}));
  const addPower = () => setCharacter(c=>({...c, powers:[...c.powers, {
    id:newId(), name:"Novo Poder", type:POWER_TYPES[0], power:40, cooldown:3, color:"#8844ff"
  }]}));
  const updatePower = (id, updated) => setCharacter(c=>({...c, powers:c.powers.map(p=>p.id===id?updated:p)}));
  const removePower = (id) => setCharacter(c=>({...c, powers:c.powers.filter(p=>p.id!==id)}));
  const publishMap = () => {
    setPublished(prev=>[...prev, { ...character, mapId:selectedMap, publishedAt:new Date().toLocaleString("pt-BR") }]);
    alert("✅ Mapa publicado e salvo!");
    setTab("publicados");
  };
  const loadPublished = (p) => { setCharacter(p); setSelectedMap(p.mapId); setTab("testar"); setTestMode(true); };

  const TABS = [
    { id:"criar",      label:"🧬 Criar" },
    { id:"poderes",    label:"⚡ Poderes" },
    { id:"testar",     label:"🎮 Testar" },
    { id:"mapas",      label:"🗺️ Mapas" },
    { id:"publicados", label:"🌐 Publicados" },
  ];

  return (
    <div style={{
      minHeight:"100vh", background:"linear-gradient(135deg,#0a0a1a 0%,#1a0a2e 50%,#0a1a2e 100%)",
      color:"#fff", fontFamily:"'Courier New', monospace"
    }}>
      {/* Header */}
      <div style={{background:"rgba(0,0,0,0.5)",borderBottom:"1px solid rgba(255,255,255,0.1)",padding:"12px 20px",
        display:"flex",alignItems:"center",justifyContent:"space-between",backdropFilter:"blur(10px)"}}>
        <div style={{display:"flex",alignItems:"center",gap:10}}>
          <span style={{fontSize:24}}>⚡</span>
          <span style={{fontWeight:900,fontSize:18,letterSpacing:2,
            background:"linear-gradient(90deg,#8844ff,#00ccff,#ff4444)",WebkitBackgroundClip:"text",WebkitTextFillColor:"transparent"}}>
            POWER FORGE
          </span>
        </div>
        <div style={{fontSize:12,color:"#888"}}>
          {character.name} • {character.gender} • {character.parts.length} partes
        </div>
      </div>

      {/* Tabs */}
      <div style={{display:"flex",gap:4,padding:"12px 20px 0",borderBottom:"1px solid rgba(255,255,255,0.08)"}}>
        {TABS.map(t=>(
          <button key={t.id} onClick={()=>{setTab(t.id); if(t.id!=="testar") setTestMode(false);}}
            style={{
              padding:"8px 14px",fontSize:12,fontWeight:700,cursor:"pointer",border:"none",borderRadius:"6px 6px 0 0",
              background:tab===t.id?"rgba(136,68,255,0.3)":"rgba(255,255,255,0.05)",
              color:tab===t.id?"#cc88ff":"#888",
              borderBottom:tab===t.id?"2px solid #8844ff":"2px solid transparent",
              transition:"all 0.2s"
            }}>{t.label}</button>
        ))}
      </div>

      <div style={{padding:20,maxWidth:1100,margin:"0 auto"}}>

        {/* ── CRIAR ── */}
        {tab === "criar" && (
          <div style={{display:"grid",gridTemplateColumns:"1fr 340px",gap:20}}>
            <div>
              {/* Preview */}
              <div style={{background:"rgba(0,0,0,0.3)",borderRadius:12,padding:16,marginBottom:16,border:"1px solid rgba(255,255,255,0.08)"}}>
                <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:12}}>
                  <span style={{fontWeight:700,fontSize:14}}>👁️ Preview do Personagem</span>
                  <div style={{display:"flex",gap:8}}>
                    <label style={{color:"#aaa",fontSize:11}}>Gênero:
                      <select value={character.gender} onChange={e=>setCharacter(c=>({...c,gender:e.target.value}))}
                        style={{marginLeft:6,background:"#1a1a2e",color:"#fff",border:"1px solid rgba(255,255,255,0.2)",
                          borderRadius:4,padding:"2px 6px",fontSize:11}}>
                        {GENDER_OPTIONS.map(g=><option key={g}>{g}</option>)}
                      </select>
                    </label>
                  </div>
                </div>
                <div style={{position:"relative",height:200,background:"linear-gradient(180deg,#1a1a3e,#0a0a1e)",
                  borderRadius:8,overflow:"hidden",display:"flex",alignItems:"center",justifyContent:"center"}}>
                  {/* Static character preview */}
                  <svg width={120} height={180} style={{overflow:"visible"}}>
                    {character.parts.map(p=>(
                      <g key={p.id} transform={`translate(${60+p.offsetX},${90+p.offsetY}) rotate(${p.rotation}) scale(${p.scale})`}>
                        {(p.name==="Cabeça"||p.name==="Orbe")
                          ? <circle cx={0} cy={0} r={p.size/2} fill={p.color} stroke="rgba(0,0,0,0.4)" strokeWidth={1.5}
                              filter={p.effects?.includes("Brilho")?"url(#glow)":undefined} />
                          : p.name==="Asa"
                          ? <path d={`M0,0 Q${p.size/2},${-p.size*0.5} ${p.size*0.4},0 Q0,${p.size*0.2} 0,0`} fill={p.color} opacity={0.9}/>
                          : <rect x={-p.size*0.3} y={-p.size/2} width={p.size*0.6} height={p.size} rx={3} fill={p.color} stroke="rgba(0,0,0,0.4)" strokeWidth={1.5}/>
                        }
                      </g>
                    ))}
                    <defs><filter id="glow"><feGaussianBlur stdDeviation="3" result="blur"/><feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge></filter></defs>
                  </svg>
                  <div style={{position:"absolute",bottom:8,left:8,background:"rgba(0,0,0,0.5)",padding:"3px 8px",borderRadius:4,fontSize:11,color:"#aaa"}}>
                    {character.gender}
                  </div>
                </div>
              </div>

              {/* Name */}
              <div style={{marginBottom:16}}>
                <label style={{color:"#aaa",fontSize:12}}>Nome do Personagem</label>
                <input value={character.name} onChange={e=>setCharacter(c=>({...c,name:e.target.value}))}
                  style={{display:"block",marginTop:4,width:"100%",background:"rgba(255,255,255,0.07)",
                    border:"1px solid rgba(255,255,255,0.15)",borderRadius:8,color:"#fff",padding:"8px 12px",
                    fontSize:14,fontFamily:"'Courier New',monospace",boxSizing:"border-box"}} />
              </div>

              {/* Add parts */}
              <div style={{marginBottom:12}}>
                <div style={{color:"#aaa",fontSize:12,marginBottom:8}}>Adicionar Parte:</div>
                <div style={{display:"flex",flexWrap:"wrap",gap:6}}>
                  {PART_TYPES.map(pt=>(
                    <button key={pt} onClick={()=>addPart(pt)} style={{
                      padding:"5px 10px",fontSize:11,border:"1px solid rgba(136,68,255,0.4)",
                      borderRadius:6,background:"rgba(136,68,255,0.1)",color:"#cc88ff",cursor:"pointer"
                    }}>+ {pt}</button>
                  ))}
                </div>
              </div>
            </div>

            {/* Parts list */}
            <div style={{overflowY:"auto",maxHeight:"80vh"}}>
              <div style={{fontWeight:700,fontSize:13,marginBottom:10,color:"#cc88ff"}}>
                🦴 Partes ({character.parts.length})
              </div>
              {character.parts.map(p=>(
                <PartEditor key={p.id} part={p}
                  onChange={updated=>updatePart(p.id,updated)}
                  onRemove={()=>removePart(p.id)} />
              ))}
              {character.parts.length===0&&<div style={{color:"#555",textAlign:"center",padding:20}}>Adicione partes ao personagem</div>}
            </div>
          </div>
        )}

        {/* ── PODERES ── */}
        {tab === "poderes" && (
          <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:20}}>
            <div>
              <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:12}}>
                <span style={{fontWeight:700,fontSize:14,color:"#ff8844"}}>⚡ Poderes ({character.powers.length})</span>
                <button onClick={addPower} style={{
                  padding:"6px 14px",background:"linear-gradient(90deg,#ff4400,#ff8800)",
                  border:"none",borderRadius:6,color:"#fff",cursor:"pointer",fontWeight:700,fontSize:12
                }}>+ Novo Poder</button>
              </div>
              {character.powers.map(pw=>(
                <PowerEditor key={pw.id} power={pw}
                  onChange={updated=>updatePower(pw.id,updated)}
                  onRemove={()=>removePower(pw.id)} />
              ))}
              {character.powers.length===0&&<div style={{color:"#555",textAlign:"center",padding:20}}>Crie seus primeiros poderes!</div>}
            </div>
            <div>
              <div style={{fontWeight:700,fontSize:14,marginBottom:12,color:"#00ccff"}}>📖 Tipos de Poder</div>
              {POWER_TYPES.map(pt=>{
                const emojis = {Teleporte:"🌀",Dash:"💨",Explosão:"💥",Escudo:"🛡️",Raio:"⚡",Gelo:"❄️",Fogo:"🔥",Vento:"🌪️",Gravidade:"⬛",Cura:"💚"};
                const descs = {Teleporte:"Move instantaneamente",Dash:"Velocidade extrema",Explosão:"Dano em área",
                  Escudo:"Proteção total",Raio:"Ataque elétrico",Gelo:"Congela inimigos",Fogo:"Queima contínua",
                  Vento:"Empurra objetos",Gravidade:"Manipula física",Cura:"Restaura vida"};
                return (
                  <div key={pt} style={{display:"flex",alignItems:"center",gap:10,padding:"8px 10px",
                    background:"rgba(255,255,255,0.04)",borderRadius:7,marginBottom:5}}>
                    <span style={{fontSize:18}}>{emojis[pt]}</span>
                    <div>
                      <div style={{color:"#fff",fontSize:12,fontWeight:700}}>{pt}</div>
                      <div style={{color:"#888",fontSize:10}}>{descs[pt]}</div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* ── TESTAR ── */}
        {tab === "testar" && (
          <div>
            <div style={{display:"flex",gap:10,marginBottom:12,flexWrap:"wrap",alignItems:"center"}}>
              <button onClick={()=>setTestMode(t=>!t)} style={{
                padding:"8px 20px",fontWeight:900,fontSize:13,border:"none",borderRadius:8,cursor:"pointer",
                background:testMode?"#ff4444":"#44cc44",color:"#fff"
              }}>{testMode?"⏹ Parar Teste":"▶ Iniciar Teste"}</button>
              {testMode && <span style={{color:"#aaa",fontSize:12}}>← → ou A D = mover • Espaço = pular</span>}
              {character.powers.map(pw=>(
                <button key={pw.id} onClick={()=>setActivePower(ap=>ap===pw.type?null:pw.type)} style={{
                  padding:"6px 12px",fontSize:11,border:"none",borderRadius:6,cursor:"pointer",fontWeight:700,
                  background:activePower===pw.type?pw.color:"rgba(255,255,255,0.1)",
                  color:activePower===pw.type?"#fff":"#aaa"
                }}>{pw.name}</button>
              ))}
            </div>
            <div style={{borderRadius:12,overflow:"hidden",border:"2px solid rgba(255,255,255,0.1)",boxShadow:"0 0 30px rgba(136,68,255,0.2)"}}>
              <GameCanvas player={player} character={character} mapId={selectedMap} activePower={activePower} testMode={testMode} />
            </div>
            {!testMode && (
              <div style={{marginTop:12,textAlign:"center",color:"#666",fontSize:12}}>
                Clique em ▶ Iniciar Teste para jogar!
              </div>
            )}
          </div>
        )}

        {/* ── MAPAS ── */}
        {tab === "mapas" && (
          <div>
            <div style={{fontWeight:700,fontSize:14,marginBottom:16}}>🗺️ Escolha o Mapa</div>
            <div style={{display:"grid",gridTemplateColumns:"repeat(auto-fill,minmax(180px,1fr))",gap:12,marginBottom:20}}>
              {MAPS.map(m=>(
                <div key={m.id} onClick={()=>setSelectedMap(m.id)}
                  style={{
                    padding:16,borderRadius:12,cursor:"pointer",textAlign:"center",
                    background:selectedMap===m.id?"rgba(136,68,255,0.25)":"rgba(255,255,255,0.05)",
                    border:selectedMap===m.id?"2px solid #8844ff":"2px solid rgba(255,255,255,0.08)",
                    transition:"all 0.2s"
                  }}>
                  <div style={{fontSize:40,marginBottom:8}}>{m.name.split(" ")[0]}</div>
                  <div style={{fontWeight:700,fontSize:13,marginBottom:4}}>{m.name.split(" ").slice(1).join(" ")}</div>
                  <div style={{color:"#888",fontSize:11}}>{m.desc}</div>
                  {selectedMap===m.id && <div style={{marginTop:8,color:"#8844ff",fontSize:11,fontWeight:700}}>✓ Selecionado</div>}
                </div>
              ))}
            </div>
            <div style={{display:"flex",gap:10}}>
              <button onClick={()=>setTab("testar")} style={{
                padding:"10px 20px",background:"linear-gradient(90deg,#8844ff,#00ccff)",
                border:"none",borderRadius:8,color:"#fff",cursor:"pointer",fontWeight:700
              }}>▶ Testar neste Mapa</button>
              <button onClick={publishMap} style={{
                padding:"10px 20px",background:"linear-gradient(90deg,#ff4400,#ff8800)",
                border:"none",borderRadius:8,color:"#fff",cursor:"pointer",fontWeight:700
              }}>🌐 Publicar Mapa</button>
            </div>
          </div>
        )}

        {/* ── PUBLICADOS ── */}
        {tab === "publicados" && (
          <div>
            <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:16}}>
              <span style={{fontWeight:700,fontSize:14}}>🌐 Mapas Publicados ({published.length})</span>
              <button onClick={publishMap} style={{
                padding:"8px 16px",background:"linear-gradient(90deg,#ff4400,#ff8800)",
                border:"none",borderRadius:8,color:"#fff",cursor:"pointer",fontWeight:700,fontSize:12
              }}>+ Publicar Atual</button>
            </div>
            <PublishedMaps published={published} onPlay={loadPublished} />
          </div>
        )}

      </div>
    </div>
  );
}
