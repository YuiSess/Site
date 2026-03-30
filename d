<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Free Games — Plataforma 3D de Jogos</title>
<link href="https://fonts.googleapis.com/css2?family=Exo+2:wght@300;400;600;700;900&family=Share+Tech+Mono&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<style>
:root{
  --bg:#02040c;--s1:#060d1c;--s2:#0a1428;--s3:#0f1d38;
  --c:#00f5ff;--o:#ff6b00;--r:#ff1744;--g:#00e676;
  --p:#d500f9;--y:#ffd740;--w:#e8f4ff;
  --mu:#3a5a7a;--bd:rgba(0,245,255,0.1);
  --f:'Exo 2',sans-serif;--fm:'Share Tech Mono',monospace;
}
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:100%;height:100%;overflow:hidden;background:var(--bg);color:var(--w);font-family:var(--f)}
::-webkit-scrollbar{width:4px;height:4px}
::-webkit-scrollbar-thumb{background:rgba(0,245,255,0.2);border-radius:2px}

/* CURSOR */
*{cursor:none!important}
#cursor{position:fixed;width:18px;height:18px;border:2px solid var(--c);border-radius:50%;pointer-events:none;z-index:9999;transform:translate(-50%,-50%);transition:width .15s,height .15s,background .15s;mix-blend-mode:difference}
#cursor-dot{position:fixed;width:4px;height:4px;background:var(--c);border-radius:50%;pointer-events:none;z-index:9999;transform:translate(-50%,-50%)}

/* LAYOUT */
#app{width:100%;height:100%;display:flex;flex-direction:column;overflow:hidden}

/* TOPBAR */
#topbar{height:52px;flex-shrink:0;background:rgba(2,4,12,0.95);border-bottom:1px solid var(--bd);backdrop-filter:blur(20px);display:flex;align-items:center;padding:0 18px;gap:14px;z-index:200;position:relative}
.logo{font-family:var(--fm);font-size:1.4rem;color:var(--c);letter-spacing:4px;text-shadow:0 0 20px rgba(0,245,255,0.5)}
.logo b{color:var(--o)}
.tb-nav{display:flex;gap:2px;flex:1;overflow-x:auto}
.tb-nav::-webkit-scrollbar{display:none}
.tnb{background:none;border:none;color:var(--mu);padding:6px 12px;border-radius:5px;font-family:var(--f);font-size:.8rem;font-weight:600;letter-spacing:.5px;transition:all .2s;white-space:nowrap}
.tnb:hover,.tnb.on{color:var(--c);background:rgba(0,245,255,0.07)}
.tb-r{display:flex;align-items:center;gap:8px;margin-left:auto}
.tb-music{background:none;border:1px solid var(--bd);color:var(--mu);width:30px;height:30px;border-radius:5px;font-size:.85rem;transition:all .2s}
.tb-music:hover{border-color:var(--c);color:var(--c)}
.online-pill{background:rgba(0,230,118,.08);border:1px solid rgba(0,230,118,.2);color:var(--g);padding:4px 10px;border-radius:20px;font-size:.72rem;font-weight:700;display:flex;align-items:center;gap:5px}
.pdot{width:6px;height:6px;background:var(--g);border-radius:50%;animation:pdot 2s infinite}
@keyframes pdot{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.3;transform:scale(1.5)}}
.adm-btn{background:linear-gradient(135deg,var(--o),var(--r));color:#fff;border:none;padding:5px 14px;border-radius:5px;font-family:var(--fm);font-size:.72rem;font-weight:700;letter-spacing:1px}
.adm-btn:hover{filter:brightness(1.2)}
.av-btn{width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,var(--c),var(--p));border:none;color:#000;font-weight:700;font-size:.8rem;display:flex;align-items:center;justify-content:center}

/* PAGES */
#content{flex:1;overflow:hidden;position:relative}
.page{position:absolute;inset:0;overflow-y:auto;display:none;animation:pg .3s ease}
.page.on{display:block}
@keyframes pg{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:none}}
.page::-webkit-scrollbar{width:4px}

/* HERO */
.hero{min-height:380px;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:50px 20px 30px;position:relative;overflow:hidden}
.hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse 90% 60% at 50% 0%,rgba(0,245,255,0.06) 0%,transparent 65%)}
#hero-canvas{position:absolute;inset:0;z-index:0;pointer-events:none}
.hero-content{position:relative;z-index:1}
.hbadge{background:rgba(0,245,255,.08);border:1px solid rgba(0,245,255,.25);color:var(--c);padding:4px 18px;border-radius:20px;font-size:.72rem;font-weight:700;letter-spacing:2px;margin-bottom:18px;display:inline-block;animation:fa .5s .1s both}
.htitle{font-size:clamp(2.8rem,7vw,5.5rem);font-weight:900;line-height:1.05;margin-bottom:14px;animation:fa .5s .2s both}
.htitle .t1{display:block;color:var(--w)}
.htitle .t2{display:block;background:linear-gradient(90deg,var(--c),var(--p),var(--o));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;filter:drop-shadow(0 0 30px rgba(0,245,255,.3))}
.hsub{color:var(--mu);font-size:1rem;max-width:500px;margin:0 auto 28px;line-height:1.6;animation:fa .5s .3s both}
.hbtns{display:flex;gap:10px;flex-wrap:wrap;justify-content:center;animation:fa .5s .4s both}
@keyframes fa{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}

/* BUTTONS */
.btn{border:none;border-radius:7px;font-family:var(--f);font-weight:700;display:inline-flex;align-items:center;gap:7px;transition:all .2s;white-space:nowrap}
.btn-lg{padding:12px 28px;font-size:.9rem;letter-spacing:.5px}
.btn-md{padding:8px 18px;font-size:.82rem}
.btn-sm{padding:5px 12px;font-size:.75rem}
.btn-c{background:linear-gradient(135deg,var(--c),#0090c0);color:#000}
.btn-c:hover{transform:translateY(-2px);box-shadow:0 5px 20px rgba(0,245,255,.35)}
.btn-o{background:linear-gradient(135deg,var(--o),#cc4400);color:#fff}
.btn-o:hover{transform:translateY(-2px);box-shadow:0 5px 20px rgba(255,107,0,.35)}
.btn-g{background:transparent;border:1px solid rgba(255,255,255,.15);color:var(--w)}
.btn-g:hover{border-color:var(--c);color:var(--c)}
.btn-r{background:linear-gradient(135deg,var(--r),#aa0020);color:#fff}
.btn-p{background:linear-gradient(135deg,var(--p),#7700bb);color:#fff}
.btn-gr{background:linear-gradient(135deg,var(--g),#009944);color:#000}

/* STATS */
.sbar{display:flex;flex-wrap:wrap;border-top:1px solid var(--bd);border-bottom:1px solid var(--bd)}
.si{flex:1;min-width:110px;padding:18px 20px;text-align:center;border-right:1px solid var(--bd)}
.si:last-child{border-right:none}
.sn{font-family:var(--fm);font-size:1.7rem;color:var(--c)}
.sl{font-size:.7rem;color:var(--mu);margin-top:3px;letter-spacing:1px;text-transform:uppercase}

/* SEC */
.sec{padding:32px 20px}
.shtitle{font-size:1.35rem;font-weight:800;margin-bottom:5px}
.shsub{color:var(--mu);font-size:.85rem;margin-bottom:22px}
.hl{color:var(--c)}

/* GAME CARDS */
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:15px}
.grid-lg{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:16px}
.gc{background:var(--s1);border:1px solid var(--bd);border-radius:12px;overflow:hidden;transition:all .22s;position:relative}
.gc:hover{transform:translateY(-4px);border-color:var(--c);box-shadow:0 8px 30px rgba(0,245,255,.12)}
.gct{height:140px;display:flex;align-items:center;justify-content:center;position:relative;overflow:hidden;font-size:3.5rem}
.gct-3d{position:absolute;inset:0}
.gcbadges{position:absolute;top:8px;left:8px;display:flex;gap:5px;z-index:2}
.gb{font-size:.6rem;font-weight:700;padding:2px 7px;border-radius:3px;letter-spacing:.5px}
.gb-hot{background:var(--o);color:#fff}
.gb-new{background:var(--g);color:#000}
.gb-3d{background:var(--p);color:#fff}
.gb-2d{background:rgba(0,245,255,.2);color:var(--c);border:1px solid rgba(0,245,255,.3)}
.gb-tr{background:rgba(255,23,68,.15);color:var(--r);border:1px solid rgba(255,23,68,.25)}
.gcb{padding:12px 14px 14px}
.gctitle{font-size:.88rem;font-weight:700;margin-bottom:4px;font-family:var(--fm)}
.gcdesc{color:var(--mu);font-size:.77rem;line-height:1.45;margin-bottom:10px}
.gcmeta{display:flex;align-items:center;justify-content:space-between}
.gconl{font-size:.72rem;color:var(--g);display:flex;align-items:center;gap:4px;font-weight:600}
.gcplay{background:var(--c);color:#000;border:none;padding:4px 12px;border-radius:5px;font-family:var(--fm);font-size:.65rem;font-weight:700;transition:all .2s}
.gcplay:hover{background:#fff}

/* TICKER */
.ticker{background:rgba(0,245,255,.03);border:1px solid var(--bd);border-radius:7px;padding:7px 14px;display:flex;align-items:center;gap:10px;overflow:hidden;margin:8px 20px}
.tlbl{background:var(--c);color:#000;padding:2px 8px;border-radius:3px;font-size:.67rem;font-weight:800;letter-spacing:1px;white-space:nowrap}
.ttr{flex:1;overflow:hidden}
.tinn{display:flex;gap:40px;animation:tick 22s linear infinite;white-space:nowrap}
@keyframes tick{0%{transform:translateX(0)}100%{transform:translateX(-50%)}}
.tmsg{font-size:.78rem;color:var(--w);opacity:.75}

/* MODAL */
.mbg{display:none;position:fixed;inset:0;background:rgba(0,0,0,.85);z-index:600;align-items:center;justify-content:center;backdrop-filter:blur(10px)}
.mbg.on{display:flex;animation:mfade .25s ease}
@keyframes mfade{from{opacity:0}to{opacity:1}}
.modal{background:var(--s2);border:1px solid rgba(0,245,255,.18);border-radius:16px;width:min(660px,95vw);max-height:90vh;overflow-y:auto;animation:mscale .3s ease}
.modal-wide{width:min(860px,96vw)}
@keyframes mscale{from{transform:scale(.93);opacity:0}to{transform:scale(1);opacity:1}}
.mhd{display:flex;align-items:center;justify-content:space-between;padding:20px 24px;border-bottom:1px solid var(--bd);position:sticky;top:0;background:var(--s2);z-index:2}
.mhd h3{font-family:var(--fm);font-size:1rem;font-weight:700}
.mx{background:none;border:none;color:var(--mu);font-size:1.2rem;width:28px;height:28px;border-radius:5px;transition:all .2s}
.mx:hover{background:rgba(255,23,68,.15);color:var(--r)}
.mbody{padding:22px 24px}

/* OPTIONS */
.olbl{font-size:.73rem;font-weight:700;color:var(--mu);letter-spacing:1px;text-transform:uppercase;margin-bottom:9px}
.ogrp{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:4px}
.ob{background:var(--s3);border:1px solid rgba(255,255,255,.09);color:var(--w);padding:9px 16px;border-radius:7px;font-family:var(--f);font-size:.83rem;font-weight:600;transition:all .2s;display:flex;align-items:center;gap:7px}
.ob:hover{border-color:var(--c);color:var(--c)}
.ob.sel{background:rgba(0,245,255,.08);border-color:var(--c);color:var(--c)}
.ob.sel-g{background:rgba(0,230,118,.07);border-color:var(--g);color:var(--g)}
.ob.sel-r{background:rgba(255,23,68,.07);border-color:var(--r);color:var(--r)}
.ob.sel-o{background:rgba(255,107,0,.07);border-color:var(--o);color:var(--o)}
.ob.sel-p{background:rgba(213,0,249,.07);border-color:var(--p);color:var(--p)}
.osec{margin-bottom:20px}

/* CHAT */
.chat-wrap{display:flex;flex-direction:column;height:100%}
.ctabs{display:flex;border-bottom:1px solid var(--bd)}
.ctab{flex:1;background:none;border:none;color:var(--mu);padding:9px;font-family:var(--f);font-size:.77rem;font-weight:600;border-bottom:2px solid transparent;transition:all .2s}
.ctab.on{color:var(--c);border-bottom-color:var(--c)}
.cmsgs{flex:1;overflow-y:auto;padding:10px;display:flex;flex-direction:column;gap:8px;min-height:0}
.cmsgs::-webkit-scrollbar{width:3px}
.cmsgs::-webkit-scrollbar-thumb{background:rgba(0,245,255,.15)}
.cmsg{display:flex;flex-direction:column;gap:2px}
.cmu{font-size:.7rem;font-weight:700}
.cmu-me{color:var(--c)} .cmu-o{color:var(--o)} .cmu-ai{color:var(--p)} .cmu-sys{color:var(--y)} .cmu-adm{color:var(--r)}
.cmt{font-size:.82rem;background:rgba(255,255,255,.04);border-radius:5px;padding:6px 9px;line-height:1.4;word-break:break-word}
.mine .cmt{background:rgba(0,245,255,.07);border:1px solid rgba(0,245,255,.1)}
.cinp-row{display:flex;gap:6px;padding:8px;border-top:1px solid var(--bd)}
.cinp{flex:1;background:var(--s3);border:1px solid rgba(255,255,255,.09);color:var(--w);padding:7px 10px;border-radius:6px;font-family:var(--f);font-size:.82rem;outline:none;transition:border-color .2s}
.cinp:focus{border-color:var(--c)}
.csend{background:var(--c);color:#000;border:none;width:30px;height:30px;border-radius:6px;font-size:.8rem;flex-shrink:0}

/* ============ CHARACTER SELECT ============ */
#char-select{position:fixed;inset:0;background:rgba(0,0,0,.97);z-index:800;display:flex;flex-direction:column;align-items:center;justify-content:center}
.cs-title{font-family:var(--fm);font-size:2rem;color:var(--c);margin-bottom:8px;letter-spacing:3px;text-shadow:0 0 30px rgba(0,245,255,.5)}
.cs-sub{color:var(--mu);font-size:.9rem;margin-bottom:6px}
.cs-timer{font-family:var(--fm);font-size:1.5rem;color:var(--y);margin-bottom:28px;text-shadow:0 0 15px rgba(255,215,64,.5)}
.cs-grid{display:flex;gap:20px;flex-wrap:wrap;justify-content:center;margin-bottom:30px}
.cs-card{width:130px;border:2px solid rgba(255,255,255,.1);border-radius:12px;padding:12px;background:var(--s1);transition:all .25s;display:flex;flex-direction:column;align-items:center;gap:8px}
.cs-card:hover{border-color:var(--c);transform:translateY(-5px);box-shadow:0 10px 30px rgba(0,245,255,.2)}
.cs-card.sel{border-color:var(--c);background:rgba(0,245,255,.08)}
.cs-3d-wrap{width:100px;height:120px;position:relative}
.cs-name{font-family:var(--fm);font-size:.8rem;font-weight:700;color:var(--w);text-align:center}
.cs-type{font-size:.67rem;color:var(--mu);text-align:center}
.cs-bar-wrap{width:100%;height:3px;background:rgba(255,255,255,.08);border-radius:2px;margin-top:2px}
.cs-bar{height:100%;background:var(--c);border-radius:2px;transition:width .4s}
.cs-stat-row{display:flex;justify-content:space-between;font-size:.67rem;color:var(--mu);width:100%}

/* ============ 3D GAME VIEW ============ */
#game3d{position:fixed;inset:0;z-index:500;display:none}
#game3d.on{display:block}
#c3d{width:100%;height:100%;display:block}
#hud{position:fixed;inset:0;z-index:501;pointer-events:none;display:none}
#hud.on{display:block}
.hud-top{position:absolute;top:0;left:0;right:0;height:50px;background:linear-gradient(to bottom,rgba(0,0,0,.7),transparent);display:flex;align-items:center;justify-content:space-between;padding:0 20px;pointer-events:all}
.hud-score{font-family:var(--fm);font-size:1.4rem;display:flex;align-items:center;gap:12px}
.hs-l{color:var(--c)} .hs-sep{color:var(--mu)} .hs-r{color:var(--o)}
.hud-timer{font-family:var(--fm);font-size:1rem;color:var(--y)}
.hud-mode{font-size:.7rem;padding:3px 10px;border-radius:20px;background:rgba(0,230,118,.1);color:var(--g);border:1px solid rgba(0,230,118,.2);font-weight:700}
.hud-crosshair{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:28px;height:28px;pointer-events:none}
.hud-crosshair::before,.hud-crosshair::after{content:'';position:absolute;background:rgba(255,255,255,.9);border-radius:2px}
.hud-crosshair::before{width:2px;height:100%;top:0;left:50%;transform:translateX(-50%)}
.hud-crosshair::after{height:2px;width:100%;top:50%;left:0;transform:translateY(-50%)}
/* Sport crosshair ring */
#hud-cross.sport-aim::before{background:rgba(255,215,64,.95)}
#hud-cross.sport-aim::after{background:rgba(255,215,64,.95)}
#hud-cross.sport-aim{width:36px;height:36px;border:2px solid rgba(255,215,64,.6);border-radius:50%;box-shadow:0 0 12px rgba(255,215,64,.4)}
#hud-cross.sport-aim.charged{border-color:rgba(255,80,0,.9);box-shadow:0 0 20px rgba(255,80,0,.6)}
.hud-health{position:absolute;bottom:20px;left:20px;pointer-events:none}
.hud-hlbl{font-family:var(--fm);font-size:.7rem;color:var(--mu);margin-bottom:4px}
.hud-hbar{width:180px;height:8px;background:rgba(255,255,255,.1);border-radius:4px;overflow:hidden}
.hud-hfill{height:100%;background:linear-gradient(90deg,var(--r),var(--o));border-radius:4px;transition:width .3s}
.hud-ammo{position:absolute;bottom:20px;right:20px;font-family:var(--fm);font-size:1.2rem;color:var(--y);text-align:right}
.hud-kills{position:absolute;top:60px;right:20px;font-family:var(--fm);font-size:.8rem;color:var(--w);text-align:right}
.hud-chatbox{position:absolute;bottom:50px;left:20px;width:280px;background:rgba(0,0,0,.6);border:1px solid var(--bd);border-radius:8px;overflow:hidden;pointer-events:auto}
.hud-chatmsgs{height:120px;overflow-y:auto;padding:8px;display:flex;flex-direction:column;gap:6px}
.hud-chatmsgs::-webkit-scrollbar{width:2px}
.hud-ci{display:flex;gap:5px;padding:5px;border-top:1px solid var(--bd)}
.hud-ci input{flex:1;background:transparent;border:none;color:var(--w);font-family:var(--f);font-size:.78rem;outline:none;padding:3px 5px}
.hud-ci button{background:var(--c);color:#000;border:none;padding:3px 8px;border-radius:4px;font-size:.72rem;font-weight:700}
.hud-vfx{position:absolute;inset:0;pointer-events:none}
.hud-hit{position:absolute;inset:0;background:rgba(255,23,68,0);transition:background .15s}
.hud-hit.flash{background:rgba(255,23,68,.25)}
.exit-hint{position:absolute;top:10px;left:50%;transform:translateX(-50%);font-family:var(--fm);font-size:.72rem;color:rgba(255,255,255,.4);pointer-events:none;text-align:center}
.score-popup{position:absolute;font-family:var(--fm);font-size:1.6rem;color:var(--y);font-weight:900;pointer-events:none;text-shadow:0 0 20px rgba(255,215,64,.9),0 0 40px rgba(255,215,64,.4);animation:spop 1.8s forwards;transform:translateX(-50%)}
/* OVERHEAD NICKNAMES */
.overhead-nick{position:absolute;transform:translateX(-50%);pointer-events:none;font-family:var(--fm);font-size:.62rem;font-weight:700;padding:2px 7px;border-radius:3px;white-space:nowrap;z-index:510;text-shadow:0 1px 4px rgba(0,0,0,.9);letter-spacing:.5px}
.overhead-nick.bot-nick{background:rgba(255,107,0,.75);color:#fff;border:1px solid rgba(255,107,0,.5)}
.overhead-nick.player-nick{background:rgba(0,245,255,.75);color:#000;border:1px solid rgba(0,245,255,.5)}
/* HACKER ALERT */
.hacker-msg{background:rgba(255,0,50,.15)!important;border:1px solid rgba(255,0,50,.4)!important}
.hacker-name{color:#ff0032!important}
/* DREAMCORE */
#dreamcore-overlay{position:fixed;inset:0;z-index:502;pointer-events:none;display:none}
#dreamcore-overlay.on{display:block}
.dc-scanline{position:absolute;inset:0;background:repeating-linear-gradient(0deg,rgba(0,0,0,.18) 0px,rgba(0,0,0,.18) 1px,transparent 1px,transparent 2px)}
.dc-crt{position:absolute;inset:0;box-shadow:inset 0 0 80px rgba(0,0,0,.4)}
.dc-hud{position:absolute;top:6px;left:6px;font-family:'Share Tech Mono',monospace;font-size:10px;color:#00ff44;text-shadow:0 0 6px #00ff44;line-height:1.6;background:rgba(0,0,0,.5);padding:4px 8px;border:1px solid #00ff44}
.dc-score{position:absolute;top:6px;right:6px;font-family:'Share Tech Mono',monospace;font-size:10px;color:#00ff44;text-shadow:0 0 6px #00ff44;background:rgba(0,0,0,.5);padding:4px 8px;border:1px solid #00ff44}
.dc-kick-banner{position:absolute;inset:0;display:none;flex-direction:column;align-items:center;justify-content:center;background:rgba(0,0,0,.92)}
.dc-kick-banner.on{display:flex}
.dc-kick-title{font-family:'Share Tech Mono',monospace;font-size:1.4rem;color:#ff0032;text-shadow:0 0 12px #ff0032;animation:flick .2s infinite alternate;margin-bottom:10px}
.dc-kick-msg{font-family:'Share Tech Mono',monospace;font-size:.85rem;color:#aaa}
@keyframes flick{from{opacity:1}to{opacity:.6}}

/* MUSIC PLAYER BAR */
#music-bar{position:fixed;bottom:0;left:0;right:0;height:52px;background:rgba(2,4,12,0.97);border-top:1px solid rgba(0,245,255,0.12);backdrop-filter:blur(20px);display:flex;align-items:center;padding:0 16px;gap:12px;z-index:600;transform:translateY(100%);transition:transform .3s ease}
#music-bar.on{transform:translateY(0)}
.mb-art{width:36px;height:36px;border-radius:6px;background:linear-gradient(135deg,var(--c),var(--p));display:flex;align-items:center;justify-content:center;font-size:1.1rem;flex-shrink:0}
.mb-info{flex:1;min-width:0}
.mb-title{font-family:var(--fm);font-size:.72rem;color:var(--w);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.mb-artist{font-size:.65rem;color:var(--mu)}
.mb-controls{display:flex;align-items:center;gap:6px}
.mb-btn{background:none;border:none;color:var(--mu);font-size:1rem;width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;transition:all .2s}
.mb-btn:hover,.mb-btn.on{color:var(--c);background:rgba(0,245,255,.1)}
.mb-vol{display:flex;align-items:center;gap:6px}
.mb-vol input{width:70px;accent-color:var(--c)}
.mb-prog{flex:1;height:3px;background:rgba(255,255,255,.1);border-radius:2px;position:relative;cursor:pointer;max-width:200px}
.mb-prog-fill{height:100%;background:var(--c);border-radius:2px;transition:width .5s linear}
/* playlist popup */
#pl-popup{position:fixed;bottom:58px;right:16px;width:300px;max-height:340px;background:var(--s2);border:1px solid var(--bd);border-radius:12px;overflow-y:auto;z-index:601;display:none;box-shadow:0 -4px 30px rgba(0,0,0,.6)}
#pl-popup.on{display:block;animation:pg .25s ease}
.pl-item{display:flex;align-items:center;gap:10px;padding:9px 14px;border-bottom:1px solid rgba(255,255,255,.04);cursor:pointer;transition:background .15s}
.pl-item:hover,.pl-item.on{background:rgba(0,245,255,.06)}
.pl-num{font-family:var(--fm);font-size:.7rem;color:var(--mu);width:18px;flex-shrink:0}
.pl-info{flex:1;min-width:0}
.pl-name{font-size:.78rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pl-dur{font-size:.68rem;color:var(--mu)}


/* PROFILE SYSTEM */
.prof-item{background:var(--s1);border:1px solid var(--bd);border-radius:10px;padding:10px;cursor:pointer;transition:all .2s;position:relative;text-align:center}
.prof-item:hover{border-color:var(--c);transform:translateY(-2px)}
.prof-item.equipped{border-color:var(--c);background:rgba(0,245,255,.06)}
.prof-item.equipped::after{content:'✓';position:absolute;top:4px;right:6px;color:var(--c);font-weight:700;font-size:.75rem}
.rarity-common{border-color:rgba(255,255,255,.2)!important;color:#aaa}
.rarity-rare{border-color:rgba(0,150,255,.5)!important;color:#44aaff}
.rarity-epic{border-color:rgba(180,0,255,.5)!important;color:#cc44ff}
.rarity-legendary{border-color:rgba(255,180,0,.6)!important;color:#ffcc00;box-shadow:0 0 10px rgba(255,180,0,.2)}
.item-emoji{font-size:2.2rem;display:block;margin-bottom:5px}
.item-name{font-size:.7rem;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.item-price{font-size:.65rem;color:var(--y);margin-top:3px}
.item-rarity-tag{font-size:.58rem;font-weight:700;padding:2px 6px;border-radius:10px;display:inline-block;margin-top:3px}
.group-card{background:var(--s1);border:1px solid var(--bd);border-radius:10px;padding:12px;cursor:pointer;transition:all .2s}
.group-card:hover{border-color:var(--c);transform:translateY(-2px)}
.group-card.joined{border-color:var(--g);background:rgba(0,230,118,.05)}
.group-icon{font-size:1.8rem;margin-bottom:6px}
.group-name{font-size:.82rem;font-weight:700;margin-bottom:3px}
.group-meta{font-size:.68rem;color:var(--mu)}

/* POWER METER */
#power-meter-wrap{position:absolute;bottom:90px;left:50%;transform:translateX(-50%);display:none;flex-direction:column;align-items:center;gap:5px;pointer-events:none;z-index:512}
#power-meter-wrap.on{display:flex}
.pm-label{font-family:var(--fm);font-size:.7rem;color:var(--y);letter-spacing:2px;text-shadow:0 0 8px var(--y)}
.pm-bar-bg{width:180px;height:14px;background:rgba(0,0,0,.6);border:2px solid rgba(255,255,255,.25);border-radius:7px;overflow:hidden}
#pm-bar{height:100%;width:0%;border-radius:6px;transition:background .1s;background:linear-gradient(90deg,#00e676,#ffd740)}
.pm-tip{font-family:var(--fm);font-size:.62rem;color:rgba(255,255,255,.5)}

@keyframes spop{0%{opacity:1;transform:translateX(-50%) scale(1.3) translateY(0)}30%{opacity:1;transform:translateX(-50%) scale(1) translateY(-20px)}100%{opacity:0;transform:translateX(-50%) scale(.8) translateY(-80px)}}
.gol-overlay{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;pointer-events:none;z-index:25}
.gol-text{font-family:var(--fm);font-size:6rem;font-weight:900;color:var(--y);text-shadow:0 0 60px var(--y),0 0 100px rgba(255,215,64,.4);letter-spacing:8px;animation:golPop .8s cubic-bezier(.17,.67,.3,1.4) both}
@keyframes golPop{0%{transform:scale(0) rotate(-15deg);opacity:0}60%{transform:scale(1.2) rotate(3deg);opacity:1}100%{transform:scale(1);opacity:1}}


/* AI WIDGET */
#aiw{position:fixed;bottom:18px;right:18px;z-index:550;width:330px;background:var(--s2);border:1px solid rgba(0,245,255,.2);border-radius:14px;box-shadow:0 8px 40px rgba(0,0,0,.6);transition:all .3s}
#aiw.mini{height:44px;overflow:hidden;width:200px}
#aiw.gone{display:none}
.aihd{display:flex;align-items:center;gap:9px;padding:11px 13px;border-bottom:1px solid var(--bd)}
.aiav{width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,var(--c),var(--p));display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0;animation:aiglow 3s ease-in-out infinite}
@keyframes aiglow{0%,100%{box-shadow:0 0 8px rgba(0,245,255,.3)}50%{box-shadow:0 0 18px rgba(0,245,255,.6)}}
.aihd-t h4{font-family:var(--fm);font-size:.75rem;color:var(--c);margin-bottom:1px}
.aihd-t p{font-size:.68rem;color:var(--mu)}
.aictl{display:flex;gap:5px;margin-left:auto}
.aib{background:none;border:none;color:var(--mu);font-size:.85rem;width:22px;height:22px;border-radius:3px;transition:color .2s}
.aib:hover{color:var(--c)}
.aimsgs{padding:10px;max-height:200px;overflow-y:auto;display:flex;flex-direction:column;gap:8px}
.aimsgs::-webkit-scrollbar{width:3px}
.aimsgs::-webkit-scrollbar-thumb{background:rgba(0,245,255,.15)}
.aimsg{background:rgba(0,245,255,.05);border:1px solid rgba(0,245,255,.1);border-radius:7px 7px 7px 1px;padding:7px 10px;font-size:.79rem;line-height:1.5;color:var(--w)}
.aitdots{display:flex;gap:3px;padding:3px 0}
.td{width:5px;height:5px;background:var(--c);border-radius:50%;animation:tdb 1.2s infinite}
.td:nth-child(2){animation-delay:.2s} .td:nth-child(3){animation-delay:.4s}
@keyframes tdb{0%,80%,100%{transform:translateY(0)}40%{transform:translateY(-7px)}}
.aiqs{display:flex;flex-wrap:wrap;gap:5px;padding:8px 10px;border-top:1px solid var(--bd)}
.aiq{background:rgba(0,245,255,.05);border:1px solid rgba(0,245,255,.12);color:var(--c);padding:3px 9px;border-radius:20px;font-size:.68rem;font-weight:600;transition:all .2s}
.aiq:hover{background:rgba(0,245,255,.12)}
#ai-inp-row{display:flex;gap:5px;padding:8px 10px;border-top:1px solid var(--bd)}
#ai-inp{flex:1;background:var(--s3);border:1px solid var(--bd);color:var(--w);padding:6px 9px;border-radius:6px;font-family:var(--f);font-size:.78rem;outline:none}
#ai-inp:focus{border-color:var(--c)}
#ai-send{background:var(--c);color:#000;border:none;padding:6px 10px;border-radius:6px;font-size:.78rem;font-weight:700}

/* ADMIN */
.adm-wrap{display:grid;grid-template-columns:180px 1fr;height:100%;overflow:hidden}
.adm-sb{background:var(--s1);border-right:1px solid var(--bd);overflow-y:auto}
.adm-ni{display:flex;align-items:center;gap:8px;padding:10px 16px;color:var(--mu);font-size:.82rem;font-weight:600;border-left:3px solid transparent;transition:all .2s}
.adm-ni:hover,.adm-ni.on{color:var(--o);background:rgba(255,107,0,.05);border-left-color:var(--o)}
.adm-main{overflow-y:auto;padding:20px}
.adm-main::-webkit-scrollbar{width:4px}
.adm-card{background:var(--s1);border:1px solid var(--bd);border-radius:10px;padding:16px;margin-bottom:14px}
.adm-card h3{font-family:var(--fm);font-size:.85rem;color:var(--o);margin-bottom:12px}
.adt{width:100%;border-collapse:collapse;font-size:.78rem}
.adt th{text-align:left;padding:7px 10px;color:var(--mu);border-bottom:1px solid var(--bd);font-size:.7rem;letter-spacing:.5px;text-transform:uppercase}
.adt td{padding:9px 10px;border-bottom:1px solid rgba(255,255,255,.03)}
.adt tr:hover td{background:rgba(255,255,255,.02)}
.aa{display:flex;gap:5px}
.aab{border:none;padding:3px 9px;border-radius:3px;font-size:.68rem;font-weight:700}
.aak{background:rgba(255,107,0,.15);color:var(--o)}
.aam{background:rgba(255,215,64,.15);color:var(--y)}
.aaban{background:rgba(255,23,68,.15);color:var(--r)}
.aams{background:rgba(0,245,255,.1);color:var(--c)}

/* PROFILE */
.phero{background:linear-gradient(135deg,rgba(0,245,255,.04),rgba(213,0,249,.04));border-bottom:1px solid var(--bd);padding:32px 20px;display:flex;align-items:center;gap:20px}
.pav-big{width:72px;height:72px;border-radius:50%;background:linear-gradient(135deg,var(--c),var(--p));display:flex;align-items:center;justify-content:center;font-size:1.8rem;font-weight:700;color:#000;border:3px solid rgba(0,245,255,.35);flex-shrink:0}
.plv{color:var(--c);font-family:var(--fm);font-size:.8rem;margin-bottom:6px}
.pxpbar{background:rgba(255,255,255,.05);border-radius:20px;height:5px;margin:6px 0;overflow:hidden}
.pxpfill{height:100%;background:linear-gradient(90deg,var(--c),var(--p));border-radius:20px;transition:width .6s}
.sgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(130px,1fr));gap:10px}
.si2{background:var(--s1);border:1px solid var(--bd);border-radius:9px;padding:12px;text-align:center}
.sv{font-family:var(--fm);font-size:1.3rem;color:var(--c)}
.slbl{font-size:.7rem;color:var(--mu);margin-top:3px;letter-spacing:.5px}

/* ROOMS */
.rgrid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:14px}
.rc{background:var(--s1);border:1px solid var(--bd);border-radius:11px;padding:14px;transition:all .2s}
.rc:hover{border-color:var(--c);transform:translateY(-2px)}
.rc-hd{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:8px}
.rc-name{font-weight:700;font-size:.87rem;font-family:var(--fm)}
.rc-pub{font-size:.67rem;padding:2px 7px;border-radius:3px}
.rcp{background:rgba(0,230,118,.1);color:var(--g);border:1px solid rgba(0,230,118,.2)}
.rcpr{background:rgba(255,23,68,.1);color:var(--r);border:1px solid rgba(255,23,68,.2)}
.rc-game{font-size:.78rem;color:var(--mu);margin-bottom:7px}
.rc-meta{display:flex;gap:14px}
.rc-ms{font-size:.75rem;color:var(--mu)}
.rcd{display:inline-block;padding:2px 7px;border-radius:3px;font-size:.67rem;font-weight:700;margin-top:7px}
.rcd-e{background:rgba(0,230,118,.1);color:var(--g)}
.rcd-m{background:rgba(255,215,64,.1);color:var(--y)}
.rcd-h{background:rgba(255,23,68,.1);color:var(--r)}
.rcd-i{background:rgba(213,0,249,.1);color:var(--p)}

/* TOAST */
#toasts{position:fixed;bottom:20px;left:50%;transform:translateX(-50%);z-index:700;display:flex;flex-direction:column;align-items:center;gap:7px;pointer-events:none}
.toast{background:var(--s2);border:1px solid rgba(0,245,255,.2);color:var(--w);padding:9px 18px;border-radius:9px;font-size:.82rem;font-weight:600;animation:tin .3s ease;max-width:360px;text-align:center;box-shadow:0 4px 20px rgba(0,0,0,.5)}
.toast.ok{border-color:rgba(0,230,118,.3);color:var(--g)}
.toast.err{border-color:rgba(255,23,68,.3);color:var(--r)}
.toast.warn{border-color:rgba(255,215,64,.3);color:var(--y)}
@keyframes tin{from{transform:translateY(20px);opacity:0}to{transform:none;opacity:1}}

/* GLOBAL ALERT */
#galert{display:none;position:fixed;top:52px;left:0;right:0;z-index:400;background:linear-gradient(90deg,rgba(255,107,0,.12),rgba(255,23,68,.12));border-bottom:1px solid rgba(255,107,0,.25);padding:9px 18px;align-items:center;gap:10px}
#galert.on{display:flex}
.ga-msg{flex:1;font-size:.85rem;font-weight:600;color:var(--o)}
.ga-x{background:none;border:none;color:var(--mu);font-size:.9rem}

/* SEARCH */
.sbar-inp{position:relative;margin-bottom:18px}
.sinp{width:100%;background:var(--s1);border:1px solid var(--bd);color:var(--w);padding:11px 14px 11px 40px;border-radius:9px;font-family:var(--f);font-size:.9rem;outline:none;transition:border-color .2s}
.sinp:focus{border-color:var(--c);box-shadow:0 0 0 3px rgba(0,245,255,.07)}
.sico{position:absolute;left:13px;top:50%;transform:translateY(-50%);color:var(--mu);font-size:.9rem}
.frow{display:flex;gap:7px;flex-wrap:wrap;margin-bottom:18px}
.fch{background:var(--s1);border:1px solid var(--bd);color:var(--mu);padding:4px 12px;border-radius:20px;font-size:.75rem;font-weight:600;transition:all .2s}
.fch:hover,.fch.on{border-color:var(--c);color:var(--c);background:rgba(0,245,255,.05)}

/* LOBBY */
.lgrid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.lc{background:var(--s3);border:1px solid var(--bd);border-radius:9px;padding:12px}
.lc h4{font-family:var(--fm);font-size:.75rem;color:var(--c);margin-bottom:9px}
.ps{display:flex;align-items:center;gap:8px;padding:6px 0;border-bottom:1px solid rgba(255,255,255,.03)}
.ps:last-child{border-bottom:none}
.pav{width:28px;height:28px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.72rem;font-weight:700;color:#000;flex-shrink:0}
.pn{flex:1;font-size:.82rem;font-weight:600}
.pr{font-size:.68rem;color:var(--g)} .pw{font-size:.68rem;color:var(--mu)}

/* MAP EDITOR */
.meed-wrap{display:grid;grid-template-columns:180px 1fr 200px;gap:14px;padding:14px 18px;height:calc(100vh - 52px - 60px);overflow:hidden}
.meed-panel{background:var(--s1);border:1px solid var(--bd);border-radius:11px;padding:12px;overflow-y:auto}
.meed-panel::-webkit-scrollbar{width:3px}
.ep{font-family:var(--fm);font-size:.7rem;color:var(--c);letter-spacing:1px;text-transform:uppercase;margin-bottom:10px}
.tiles-grid{display:grid;grid-template-columns:1fr 1fr;gap:5px}
.tile{aspect-ratio:1;border-radius:6px;border:2px solid transparent;display:flex;align-items:center;justify-content:center;font-size:1.2rem;background:var(--s3);transition:all .15s}
.tile:hover,.tile.on{border-color:var(--c);transform:scale(1.05)}
.map-cont{overflow:auto;background:var(--s1);border:1px solid var(--bd);border-radius:11px;padding:8px}
.mgrid{display:grid;gap:1px}
.mc{width:32px;height:32px;background:rgba(255,255,255,.02);border-radius:3px;display:flex;align-items:center;justify-content:center;font-size:1rem;border:1px solid rgba(255,255,255,.03);transition:background .1s}
.mc:hover{background:rgba(0,245,255,.06)}
.epf{margin-bottom:10px}
.epf label{display:block;font-size:.7rem;color:var(--mu);font-weight:600;letter-spacing:.5px;margin-bottom:4px;text-transform:uppercase}
.epf input,.epf textarea,.epf select{width:100%;background:var(--s3);border:1px solid rgba(255,255,255,.08);color:var(--w);padding:7px 9px;border-radius:6px;font-family:var(--f);font-size:.82rem;outline:none;resize:none;transition:border-color .2s}
.epf input:focus,.epf textarea:focus,.epf select:focus{border-color:var(--c)}

/* MAP COMMUNITY */
.mcc{background:var(--s1);border:1px solid var(--bd);border-radius:11px;padding:13px;transition:all .2s}
.mcc:hover{border-color:var(--o);transform:translateY(-3px)}
.mcc-pre{height:85px;background:var(--s3);border-radius:7px;margin-bottom:9px;display:flex;align-items:center;justify-content:center;font-size:2rem}
.mcc-n{font-family:var(--fm);font-size:.82rem;font-weight:700;margin-bottom:3px}
.mcc-a{color:var(--mu);font-size:.73rem;margin-bottom:7px}
.mcc-f{display:flex;justify-content:space-between;align-items:center}
.mcc-s{display:flex;gap:9px}
.mcc-st{color:var(--mu);font-size:.72rem}

/* REACT ICONS SVG */
.ico{display:inline-block;width:1em;height:1em;vertical-align:middle;fill:currentColor}

/* LOGIN */
.login-pg{display:flex;align-items:center;justify-content:center;min-height:100vh;padding:20px}
.login-card{background:var(--s2);border:1px solid rgba(0,245,255,.18);border-radius:16px;padding:36px;width:min(400px,100%)}
.login-card h2{font-family:var(--fm);font-size:1.2rem;color:var(--c);margin-bottom:4px;text-align:center;letter-spacing:2px}
.login-card p{color:var(--mu);font-size:.82rem;text-align:center;margin-bottom:22px}
.lroles{display:flex;gap:7px;margin-bottom:18px}
.lrole{flex:1;background:var(--s3);border:1px solid rgba(255,255,255,.08);color:var(--mu);padding:9px;border-radius:7px;font-family:var(--f);font-weight:600;font-size:.8rem;transition:all .2s;text-align:center}
.lrole.on{border-color:var(--c);color:var(--c);background:rgba(0,245,255,.07)}
.lrole-adm.on{border-color:var(--o);color:var(--o);background:rgba(255,107,0,.07)}
.lff{margin-bottom:14px}
.lff label{display:block;font-size:.74rem;color:var(--mu);font-weight:600;margin-bottom:5px;letter-spacing:.5px;text-transform:uppercase}
.lff input{width:100%;background:var(--s3);border:1px solid rgba(255,255,255,.08);color:var(--w);padding:10px 12px;border-radius:7px;font-family:var(--f);font-size:.9rem;outline:none;transition:border-color .2s}
.lff input:focus{border-color:var(--c)}

/* VFX PARTICLES */
#vfx-layer{position:fixed;inset:0;pointer-events:none;z-index:1;overflow:hidden}
.vp{position:absolute;border-radius:50%;pointer-events:none;animation:vpf linear infinite}
@keyframes vpf{0%{transform:translateY(100vh) scale(0);opacity:0}10%{opacity:.5}90%{opacity:.1}100%{transform:translateY(-100px) scale(1.5);opacity:0}}

/* SCORE ANIM LAYER */
#score-layer{position:fixed;inset:0;pointer-events:none;z-index:502}

/* MINI MAP */
.minimap{position:absolute;top:60px;right:16px;width:120px;height:90px;background:rgba(0,0,0,.6);border:1px solid var(--bd);border-radius:6px;overflow:hidden}
.mm-canvas{width:100%;height:100%}

@media(max-width:700px){
  .tb-nav{display:none}
  .meed-wrap{grid-template-columns:1fr}
  .adm-wrap{grid-template-columns:1fr}
  .lgrid{grid-template-columns:1fr}
  .cs-grid{gap:12px}
  .cs-card{width:110px}
}

/* ── MINECRAFT MODE ──────────────────────────────────────────────── */
#mc-overlay{position:fixed;inset:0;background:#222;z-index:600;display:none;flex-direction:column}
#mc-overlay.on{display:flex}
#mc-hud{position:absolute;top:0;left:0;right:0;height:46px;background:rgba(0,0,0,.7);display:flex;align-items:center;gap:12px;padding:0 16px;z-index:2;pointer-events:all}
#mc-canvas{width:100%;height:100%;display:block}
.mc-hud-btn{background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.2);color:#fff;padding:4px 12px;border-radius:5px;font-size:.75rem;font-weight:700}
.mc-hud-btn:hover{background:rgba(255,255,255,.2)}
.mc-toolbar{position:absolute;bottom:12px;left:50%;transform:translateX(-50%);display:flex;gap:4px;background:rgba(0,0,0,.7);padding:6px 8px;border-radius:8px;z-index:2}
.mc-slot{width:44px;height:44px;border:2px solid rgba(255,255,255,.25);border-radius:6px;display:flex;align-items:center;justify-content:center;font-size:1.4rem;cursor:pointer;transition:border-color .15s}
.mc-slot.active{border-color:#ffd740}
.mc-slot:hover{border-color:rgba(255,255,255,.6)}
.mc-crosshair{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:20px;height:20px;pointer-events:none;z-index:2}
.mc-crosshair::before,.mc-crosshair::after{content:'';position:absolute;background:rgba(255,255,255,.85)}
.mc-crosshair::before{width:2px;height:100%;top:0;left:50%;transform:translateX(-50%)}
.mc-crosshair::after{height:2px;width:100%;top:50%;left:0;transform:translateY(-50%)}
#mc-fly-ind{position:absolute;top:54px;left:50%;transform:translateX(-50%);background:rgba(255,215,64,.15);border:1px solid rgba(255,215,64,.4);color:#ffd740;padding:2px 10px;border-radius:4px;font-size:.72rem;font-weight:700;z-index:2;display:none}
#mc-info{position:absolute;top:54px;left:10px;font-size:.7rem;color:rgba(255,255,255,.7);z-index:2;font-family:monospace;pointer-events:none}
/* Minecraft lobby */
.mc-lobby{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;gap:18px;background:linear-gradient(135deg,#1a2a1a,#0a1a0a)}
.mc-lobby h2{font-family:var(--fm);font-size:2rem;color:#4caf50;text-shadow:0 0 20px rgba(76,175,80,.5);letter-spacing:3px}
.mc-room-code{font-family:monospace;font-size:2.5rem;color:#ffd740;background:rgba(255,215,64,.1);border:2px solid rgba(255,215,64,.4);padding:12px 28px;border-radius:10px;letter-spacing:8px;text-align:center}
.mc-inp{background:rgba(0,0,0,.4);border:1px solid rgba(255,255,255,.2);color:#fff;padding:10px 14px;border-radius:7px;font-size:.9rem;outline:none;width:200px;text-align:center;font-family:monospace;letter-spacing:2px}
.mc-inp::placeholder{color:rgba(255,255,255,.3);letter-spacing:0}

/* ── MINI BROWSER ─────────────────────────────────────────────── */
#mini-browser{position:fixed;inset:0;z-index:650;display:none;flex-direction:column;background:#111}
#mini-browser.on{display:flex}
.mb-bar{display:flex;align-items:center;gap:6px;padding:6px 10px;background:#1a1a1a;border-bottom:1px solid #333}
.mb-navbtn{background:#2a2a2a;border:1px solid #333;color:#aaa;width:28px;height:28px;border-radius:5px;font-size:.9rem;flex-shrink:0}
.mb-navbtn:hover{background:#333;color:#fff}
.mb-url{flex:1;background:#0a0a0a;border:1px solid #333;color:#eee;padding:5px 10px;border-radius:5px;font-size:.82rem;outline:none;font-family:monospace}
.mb-url:focus{border-color:#00f5ff}
.mb-go{background:#00f5ff;color:#000;border:none;padding:5px 12px;border-radius:5px;font-weight:700;font-size:.78rem}
.mb-tabs{display:flex;gap:4px;padding:4px 10px;background:#111;border-bottom:1px solid #222}
.mb-tab{background:#1a1a1a;border:1px solid #2a2a2a;color:#888;padding:3px 12px;border-radius:4px;font-size:.72rem;cursor:pointer}
.mb-tab.on{background:#2a2a2a;color:#fff;border-color:#444}
#mb-frame{flex:1;border:none;background:#fff}
.mb-blocked{display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;color:#888;gap:10px;font-family:monospace;font-size:.85rem}

/* ── ADMIN POWERS PANEL ─────────────────────────────────────────── */
#admin-powers{position:fixed;top:60px;right:14px;z-index:550;background:rgba(10,5,20,.95);border:1px solid rgba(255,107,0,.4);border-radius:12px;padding:12px;min-width:200px;display:none}
#admin-powers.on{display:block}
.adp-title{font-family:var(--fm);font-size:.72rem;color:var(--o);letter-spacing:2px;margin-bottom:8px}
.adp-btn{width:100%;background:rgba(255,107,0,.08);border:1px solid rgba(255,107,0,.2);color:var(--o);padding:5px 10px;border-radius:5px;font-size:.75rem;font-weight:700;margin-bottom:4px;text-align:left;transition:all .15s}
.adp-btn:hover{background:rgba(255,107,0,.2)}
.adp-btn.on{background:rgba(255,107,0,.25);border-color:var(--o)}

/* ── GENDER SELECT ──────────────────────────────────────────────── */
.gender-sel{display:flex;gap:10px;margin-bottom:14px}
.gender-btn{flex:1;background:var(--s3);border:1px solid rgba(255,255,255,.1);color:var(--mu);padding:10px;border-radius:8px;font-size:1.3rem;transition:all .2s;display:flex;flex-direction:column;align-items:center;gap:4px}
.gender-btn span{font-size:.72rem;font-weight:700}
.gender-btn.on{border-color:var(--c);background:rgba(0,245,255,.08);color:var(--c)}
.gender-btn.on-f{border-color:var(--p);background:rgba(213,0,249,.08);color:var(--p)}

/* ── SECRET AREA ────────────────────────────────────────────────── */
#secret-overlay{position:fixed;inset:0;z-index:680;background:#000;display:none;flex-direction:column;align-items:center;justify-content:center;gap:16px}
#secret-overlay.on{display:flex;animation:secretIn .8s ease}
@keyframes secretIn{from{opacity:0;filter:blur(20px)}to{opacity:1;filter:none}}
.secret-title{font-family:var(--fm);font-size:3rem;color:#ffd740;text-shadow:0 0 40px #ffd740,0 0 80px #ff9100;letter-spacing:6px;animation:secretPulse 2s infinite}
@keyframes secretPulse{0%,100%{text-shadow:0 0 20px #ffd740,0 0 60px #ff9100}50%{text-shadow:0 0 50px #ffd740,0 0 120px #ff9100,0 0 200px #ffd740}}
.secret-sub{color:rgba(255,215,64,.6);font-size:1rem;letter-spacing:3px}
.secret-canvas{width:500px;height:300px;border-radius:12px;border:2px solid rgba(255,215,64,.4)}

/* ── SAVED BADGE ────────────────────────────────────────────────── */
.save-indicator{position:fixed;bottom:70px;right:18px;background:rgba(0,230,118,.12);border:1px solid rgba(0,230,118,.3);color:var(--g);padding:4px 10px;border-radius:5px;font-size:.7rem;font-weight:700;z-index:400;opacity:0;transition:opacity .4s;pointer-events:none}
.save-indicator.show{opacity:1}
</style>
</head>
<body>

<!-- CUSTOM CURSOR -->
<div id="cursor"></div>
<div id="cursor-dot"></div>

<!-- VFX PARTICLES -->
<div id="vfx-layer" id="vfx-layer"></div>

<!-- GLOBAL ALERT -->
<div id="galert">
  <span style="font-size:1rem">📡</span>
  <span class="ga-msg" id="ga-txt">Bem-vindo ao Free Games! Evento especial ativo — Terror Coop liberado!</span>
  <button class="ga-x" onclick="gax()">✕</button>
</div>

<!-- SCORE POPUP LAYER -->
<div id="score-layer"></div>

<div id="app">
<!-- TOPBAR -->
<nav id="topbar">
  <div class="logo" onclick="goPage('home')">FREE<b>GAMES</b></div>
  <div class="tb-nav">
    <button class="tnb on" onclick="goPage('home');playSound('nav')">Início</button>
    <button class="tnb" onclick="goPage('games');playSound('nav')">Jogos</button>
    <button class="tnb" onclick="goPage('rooms');playSound('nav')">Salas</button>
    <button class="tnb" onclick="goPage('creative');playSound('nav')">Criativo</button>
    <button class="tnb" onclick="goPage('community');playSound('nav')">Comunidade</button>
    <button class="tnb" onclick="goPage('profile');playSound('nav')">Perfil</button>
    <button class="tnb" onclick="goPage('search');playSound('nav')">Buscar</button>
    <button class="tnb" onclick="openMC();playSound('nav')">⛏️ Minecraft</button>
    <button class="tnb" onclick="openMB();playSound('nav')">🌐 Browser</button>
  </div>
  <div class="tb-r">
    <button class="tb-music" id="mus-btn" onclick="openMusicBar()" title="Abrir player de música" style="font-size:1rem;letter-spacing:0">🎵</button>
    <div style="background:rgba(255,215,64,.08);border:1px solid rgba(255,215,64,.25);color:var(--y);padding:4px 10px;border-radius:20px;font-size:.72rem;font-weight:700;font-family:var(--fm);cursor:pointer" onclick="profTab('shop',null);goPage('profile')">
    💰 <span id="topbar-nebux">6000</span>
  </div>
  <div class="online-pill"><span class="pdot"></span><span id="onl-cnt">3,241</span> online</div>
    <button class="adm-btn" id="adm-btn" onclick="goPage('admin')" style="display:none">ADMIN</button>
    <button class="adm-btn" id="adm-pwr-btn" onclick="document.getElementById('admin-powers').classList.toggle('on')" style="display:none;background:linear-gradient(135deg,var(--p),#7700bb)">⚡</button>
    <button class="av-btn" onclick="goPage('profile')" id="av-btn">P</button>
  </div>
</nav>

<div id="content">

<!-- HOME -->
<div class="page on" id="page-home">
  <canvas id="hero-canvas"></canvas>
  <div class="hero">
    <div class="hero-content">
      <div class="hbadge">PLATAFORMA 3D ONLINE</div>
      <h1 class="htitle"><span class="t1">JOGUE. CRIE.</span><span class="t2">CONQUISTE.</span></h1>
      <p class="hsub">Esportes 3D, terror imersivo, aventura e criativo — tudo em uma plataforma. Desafie pessoas reais ou bots com IA avançada.</p>
      <div class="hbtns">
        <button class="btn btn-lg btn-c" onclick="goPage('games')">Jogar Agora</button>
        <button class="btn btn-lg btn-o" onclick="goPage('creative')">Criar Mapa</button>
        <button class="btn btn-lg btn-g" onclick="goPage('rooms')">Multiplayer</button>
        <button class="btn btn-lg btn-g" onclick="goPage('community');playSound('nav')">Comunidade</button>
      </div>
    </div>
  </div>
  <div class="ticker">
    <span class="tlbl">AO VIVO</span>
    <div class="ttr"><div class="tinn" id="ticker-inn"></div></div>
  </div>
  <div class="sbar">
    <div class="si"><div class="sn" id="s-onl">3,241</div><div class="sl">Online</div></div>
    <div class="si"><div class="sn">52</div><div class="sl">Salas Ativas</div></div>
    <div class="si"><div class="sn">16</div><div class="sl">Jogos</div></div>
    <div class="si"><div class="sn">1.4K</div><div class="sl">Mapas</div></div>
    <div class="si"><div class="sn">99ms</div><div class="sl">Latência</div></div>
  </div>
  <div class="sec">
    <div class="shtitle">Destaque <span class="hl">3D</span></div>
    <div class="shsub">Os jogos mais jogados agora na plataforma</div>
    <div class="grid" id="home-feat"></div>
  </div>
  <div class="sec" style="padding-top:0">
    <div class="shtitle"><span class="hl">Categorias</span></div>
    <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:10px" id="cat-row"></div>
  </div>
  <div class="sec" style="padding-top:0">
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:5px">
      <div class="shtitle">Salas <span class="hl">Abertas</span></div>
      <button class="btn btn-sm btn-g" onclick="goPage('rooms')">Ver todas</button>
    </div>
    <div class="shsub">Entre agora</div>
    <div class="rgrid" id="home-rooms"></div>
  </div>
  <div class="sec" style="padding-top:0">
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:5px">
      <div class="shtitle">Mapas <span class="hl">Recentes</span></div>
      <button class="btn btn-sm btn-g" onclick="goPage('community')">Ver todos</button>
    </div>
    <div class="shsub">Criados pela comunidade</div>
    <div class="grid" id="home-maps"></div>
  </div>
</div>

<!-- GAMES -->
<div class="page" id="page-games">
  <div class="sec">
    <div class="shtitle">Todos os <span class="hl">Jogos</span></div>
    <div class="shsub">Clique para configurar e jogar</div>
    <div style="display:flex;gap:7px;flex-wrap:wrap;margin-bottom:20px" id="game-cat-tabs"></div>
    <div class="grid-lg" id="games-grid"></div>
  </div>
</div>

<!-- ROOMS -->
<div class="page" id="page-rooms">
  <div class="sec">
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:5px">
      <div class="shtitle">Salas <span class="hl">Multiplayer</span></div>
      <button class="btn btn-md btn-c" onclick="openModal('cr-modal')">+ Criar Sala</button>
    </div>
    <div class="shsub">Partidas abertas agora</div>
    <div class="frow" id="rooms-filters"></div>
    <div class="rgrid" id="rooms-grid"></div>
  </div>
</div>

<!-- CREATIVE -->
<div class="page" id="page-creative">
  <div style="padding:10px 18px 0;display:flex;align-items:center;justify-content:space-between">
    <div>
      <div class="shtitle">Modo <span class="hl">Criativo</span></div>
      <div class="shsub" style="margin-bottom:0">Construa e publique seu mapa</div>
    </div>
    <div style="display:flex;gap:8px">
      <button class="btn btn-sm btn-g" onclick="clearME()">Limpar</button>
      <button class="btn btn-sm btn-g" onclick="testME()">Testar</button>
      <button class="btn btn-sm btn-o" onclick="pubMap()">Publicar</button>
      <button class="btn btn-sm btn-g" onclick="saveLocal()">Salvar</button>
      <button class="btn btn-sm btn-p" onclick="dupMap()">Duplicar</button>
    </div>
  </div>
  <div class="meed-wrap">
    <div class="meed-panel">
      <div class="ep">Tiles</div>
      <div class="tiles-grid" id="tile-pal"></div>
      <div style="margin-top:12px"><div class="ep">Objetos</div>
      <div class="tiles-grid" id="obj-pal"></div></div>
      <div style="margin-top:12px"><div class="ep">Dimensão</div>
      <div style="display:flex;gap:6px;margin-top:5px">
        <button class="ob sel" id="d2btn" onclick="setDim('2d')" style="flex:1;justify-content:center;padding:7px;font-size:.78rem">2D</button>
        <button class="ob" id="d3btn" onclick="setDim('3d')" style="flex:1;justify-content:center;padding:7px;font-size:.78rem">3D</button>
      </div></div>
      <div style="margin-top:12px"><div class="ep">Esporte/Tipo</div>
      <select style="width:100%;background:var(--s3);border:1px solid var(--bd);color:var(--w);padding:7px;border-radius:6px;font-family:var(--f);font-size:.8rem;outline:none;margin-top:5px" id="me-sport">
        <option>Futebol</option><option>Basquete</option><option>Terror</option><option>PvP</option><option>Corrida</option><option>Custom</option>
      </select></div>
    </div>
    <div class="map-cont">
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:7px">
        <span style="font-family:var(--fm);font-size:.72rem;color:var(--c)">CANVAS DO MAPA (20x14)</span>
        <div style="display:flex;gap:6px">
          <button class="btn btn-sm btn-g" onclick="fillME()">Preencher</button>
          <button class="btn btn-sm btn-g" onclick="fillGrass()">Grama</button>
        </div>
      </div>
      <div class="mgrid" id="me-grid"></div>
    </div>
    <div class="meed-panel">
      <div class="ep">Propriedades</div>
      <div class="epf"><label>Nome</label><input type="text" id="mn" placeholder="Meu Mapa"></div>
      <div class="epf"><label>Descrição</label><textarea id="md" rows="2" placeholder="Descreva..."></textarea></div>
      <div class="epf"><label>Categoria</label>
        <select id="mc"><option>Esportes</option><option>Terror</option><option>Aventura</option><option>Ação</option><option>Casual</option></select>
      </div>
      <div class="epf"><label>Max Jogadores</label>
        <select id="mmx"><option>2</option><option>4</option><option selected>8</option><option>16</option></select>
      </div>
      <div class="epf"><label>Visibilidade</label>
        <select id="mv"><option>Público</option><option>Privado</option><option>Amigos</option><option>Em teste</option></select>
      </div>
      <div class="epf"><label>Bots</label>
        <select id="mb"><option>Sim</option><option>Não</option></select>
      </div>
      <button class="btn btn-o btn-sm" style="width:100%;justify-content:center;margin-bottom:7px" onclick="pubMap()">Publicar Mapa</button>
      <button class="btn btn-g btn-sm" style="width:100%;justify-content:center" onclick="testME()">Testar no 3D</button>
    </div>
  </div>
</div>

<!-- COMMUNITY -->
<div class="page" id="page-community">
  <div class="sec">
    <div class="shtitle">Mapas da <span class="hl">Comunidade</span></div>
    <div class="shsub">Criados por jogadores do mundo todo</div>
    <div class="frow">
      <span class="fch on" onclick="filtComm(this,'all')">Todos</span>
      <span class="fch" onclick="filtComm(this,'Esportes')">Esportes</span>
      <span class="fch" onclick="filtComm(this,'Terror')">Terror</span>
      <span class="fch" onclick="filtComm(this,'Aventura')">Aventura</span>
      <span class="fch" onclick="filtComm(this,'Ação')">Ação</span>
      <span class="fch" onclick="filtComm(this,'Casual')">Casual</span>
    </div>
    <div class="grid" id="comm-grid"></div>
  </div>
</div>

<!-- PROFILE -->
<div class="page" id="page-profile">
  <!-- PROFILE TABS -->
  <div style="display:flex;gap:0;border-bottom:1px solid var(--bd);background:var(--s1);flex-shrink:0;overflow-x:auto">
    <button class="ctab on" onclick="profTab('overview',this)">Perfil</button>
    <button class="ctab" onclick="profTab('wardrobe',this)">👕 Vestiário</button>
    <button class="ctab" onclick="profTab('shop',this)">🏪 Loja</button>
    <button class="ctab" onclick="profTab('groups',this)">👥 Grupos</button>
    <button class="ctab" onclick="profTab('edit',this)">✏️ Editar</button>
  </div>

  <!-- OVERVIEW -->
  <div id="prof-overview" class="sec">
    <div class="phero">
      <div id="p-av-wrap" style="position:relative;flex-shrink:0">
        <canvas id="avatar-canvas-profile" width="90" height="110" style="border-radius:10px;border:2px solid var(--c);background:var(--s2)"></canvas>
        <div id="p-rarity-badge" style="position:absolute;bottom:-6px;left:50%;transform:translateX(-50%);font-size:.6rem;font-weight:700;padding:2px 7px;border-radius:10px;white-space:nowrap"></div>
      </div>
      <div style="flex:1;min-width:0">
        <h2 style="font-size:1.5rem;font-weight:800;margin-bottom:2px" id="p-name-disp">Jogador</h2>
        <div style="font-size:.75rem;color:var(--mu);margin-bottom:5px" id="p-bio-disp">Sem bio ainda.</div>
        <div class="plv" id="p-level-disp">Nível 1</div>
        <div class="pxpbar"><div class="pxpfill" id="p-xpfill" style="width:10%"></div></div>
        <div style="font-size:.7rem;color:var(--mu);margin-top:3px;margin-bottom:8px" id="p-xp-disp">100/1000 XP</div>
        <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap">
          <div style="background:rgba(255,215,64,.1);border:1px solid rgba(255,215,64,.3);color:var(--y);padding:4px 12px;border-radius:20px;font-family:var(--fm);font-size:.8rem;font-weight:700">
            💰 <span id="p-nebux-disp">6000</span> NeBux
          </div>
          <div id="p-fav-games-disp" style="display:flex;gap:5px;flex-wrap:wrap"></div>
        </div>
      </div>
      <div style="display:flex;flex-direction:column;gap:6px">
        <button class="btn btn-md btn-c" onclick="profTab('wardrobe',null)">👕 Vestiário</button>
        <button class="btn btn-md btn-g" onclick="profTab('edit',null)">✏️ Editar Perfil</button>
        <button class="btn btn-md btn-o" onclick="profTab('shop',null)">🏪 Loja</button>
      </div>
    </div>
    <div class="sgrid" id="p-stats" style="margin-top:16px"></div>
    <div style="margin-top:20px"><div class="shtitle" style="margin-bottom:10px">Grupos</div>
    <div id="p-groups-mini" style="display:flex;gap:8px;flex-wrap:wrap"></div></div>
  </div>

  <!-- WARDROBE -->
  <div id="prof-wardrobe" style="display:none">
    <div style="display:flex;height:calc(100vh - 106px)">
      <!-- Avatar 3D preview -->
      <div style="width:220px;flex-shrink:0;background:var(--s1);border-right:1px solid var(--bd);display:flex;flex-direction:column;align-items:center;padding:16px 10px;gap:10px">
        <canvas id="wardrobe-canvas" width="190" height="220" style="border-radius:12px;border:2px solid var(--bd);background:linear-gradient(135deg,#0a1428,#080018)"></canvas>
        <div style="font-family:var(--fm);font-size:.7rem;color:var(--c)" id="wd-char-name">MEU PERSONAGEM</div>
        <div style="font-size:.7rem;color:var(--mu)" id="wd-rarity"></div>
        <div style="display:flex;gap:6px;flex-wrap:wrap;justify-content:center" id="wd-equipped-icons"></div>
        <button class="btn btn-sm btn-g" onclick="randomOutfit()">🎲 Aleatório</button>
        <button class="btn btn-sm btn-c" onclick="saveOutfit()">💾 Salvar</button>
      </div>
      <!-- Items grid -->
      <div style="flex:1;overflow-y:auto;padding:14px">
        <div style="display:flex;gap:8px;margin-bottom:14px;flex-wrap:wrap">
          <button class="fch on" onclick="wdFilter('all',this)">Tudo</button>
          <button class="fch" onclick="wdFilter('hair',this)">💇 Cabelo</button>
          <button class="fch" onclick="wdFilter('shirt',this)">👕 Camiseta</button>
          <button class="fch" onclick="wdFilter('pants',this)">👖 Calça</button>
          <button class="fch" onclick="wdFilter('shoes',this)">👟 Tênis</button>
          <button class="fch" onclick="wdFilter('hat',this)">🎩 Chapéu</button>
          <button class="fch" onclick="wdFilter('acc',this)">💎 Acessório</button>
        </div>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(110px,1fr));gap:10px" id="wardrobe-grid"></div>
      </div>
    </div>
  </div>

  <!-- SHOP -->
  <div id="prof-shop" style="display:none;padding:16px">
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:16px">
      <div class="shtitle">🏪 Loja de Itens</div>
      <div style="background:rgba(255,215,64,.1);border:1px solid rgba(255,215,64,.3);color:var(--y);padding:6px 14px;border-radius:20px;font-family:var(--fm);font-size:.85rem;font-weight:700">
        💰 <span id="shop-nebux-disp">6000</span> NeBux
      </div>
    </div>
    <div style="display:flex;gap:8px;margin-bottom:14px;flex-wrap:wrap">
      <button class="fch on" onclick="shopFilter('all',this)">Tudo</button>
      <button class="fch" onclick="shopFilter('rare',this)">💎 Raros</button>
      <button class="fch" onclick="shopFilter('epic',this)">🔮 Épicos</button>
      <button class="fch" onclick="shopFilter('legendary',this)">⭐ Lendários</button>
      <button class="fch" onclick="shopFilter('common',this)">🔵 Comuns</button>
    </div>
    <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:12px" id="shop-grid"></div>
  </div>

  <!-- GROUPS -->
  <div id="prof-groups" style="display:none;padding:16px">
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px">
      <div class="shtitle">👥 Grupos <span style="color:var(--mu);font-size:.8rem">(840 disponíveis)</span></div>
      <input style="background:var(--s2);border:1px solid var(--bd);color:var(--w);padding:6px 12px;border-radius:6px;font-size:.8rem;outline:none;width:200px" placeholder="Buscar grupos..." oninput="filterGroups(this.value)" id="group-search">
    </div>
    <div style="margin-bottom:20px">
      <div style="font-size:.8rem;color:var(--mu);margin-bottom:8px;font-weight:600">MEUS GRUPOS</div>
      <div id="my-groups" style="display:flex;gap:8px;flex-wrap:wrap"></div>
    </div>
    <div style="font-size:.8rem;color:var(--mu);margin-bottom:8px;font-weight:600">DESCOBRIR GRUPOS</div>
    <div id="groups-grid" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:10px"></div>
  </div>

  <!-- EDIT PROFILE -->
  <div id="prof-edit" style="display:none;padding:20px;max-width:500px">
    <div class="shtitle" style="margin-bottom:16px">✏️ Editar Perfil</div>
    <div style="display:flex;flex-direction:column;gap:14px">
      <div>
        <div class="olbl">Gênero</div>
        <div class="gender-sel" style="margin-bottom:0">
          <button class="gender-btn on" data-g="m" onclick="selectGender('m')">👦<span>Masculino</span></button>
          <button class="gender-btn" data-g="f" onclick="selectGender('f')">👧<span>Feminino</span></button>
        </div>
      </div>
      <div>
        <div class="olbl">Nickname</div>
        <input id="edit-name" style="width:100%;background:var(--s2);border:1px solid var(--bd);color:var(--w);padding:9px 12px;border-radius:7px;font-family:var(--f);font-size:.9rem;outline:none" placeholder="Seu nickname...">
      </div>
      <div>
        <div class="olbl">Bio</div>
        <textarea id="edit-bio" rows="3" style="width:100%;background:var(--s2);border:1px solid var(--bd);color:var(--w);padding:9px 12px;border-radius:7px;font-family:var(--f);font-size:.85rem;outline:none;resize:vertical" placeholder="Conte algo sobre você..."></textarea>
      </div>
      <div>
        <div class="olbl">Jogos Favoritos</div>
        <div style="display:flex;flex-wrap:wrap;gap:6px;margin-top:6px" id="fav-games-picker"></div>
      </div>
      <div>
        <div class="olbl">Cor do Perfil</div>
        <div style="display:flex;gap:8px;flex-wrap:wrap;margin-top:6px" id="profile-color-picker"></div>
      </div>
      <button class="btn btn-lg btn-c" onclick="saveProfile()" style="margin-top:4px">💾 Salvar Perfil</button>
    </div>
  </div>
</div>

<!-- SEARCH -->
<div class="page" id="page-search">
  <div class="sec">
    <div class="shtitle">Buscar <span class="hl">Free Games</span></div>
    <div class="sbar-inp" style="margin-top:14px">
      <span class="sico">◎</span>
      <input class="sinp" id="sinp" placeholder="Buscar jogos, mapas, salas, jogadores..." oninput="doSearch(this.value)">
    </div>
    <div class="frow" id="s-filters"></div>
    <div class="grid" id="s-results"></div>
  </div>
</div>

<!-- ADMIN -->
<div class="page" id="page-admin" style="padding:0;overflow:hidden">
  <div class="adm-wrap" style="height:calc(100vh - 52px)">
    <div class="adm-sb">
      <div style="padding:14px 16px 6px;font-family:var(--fm);font-size:.7rem;color:var(--o);letter-spacing:1px">ADMIN</div>
      <div class="adm-ni on" onclick="adTab('ov')">Visão Geral</div>
      <div class="adm-ni" onclick="adTab('pl')">Jogadores</div>
      <div class="adm-ni" onclick="adTab('rm')">Salas</div>
      <div class="adm-ni" onclick="adTab('mp')">Mapas</div>
      <div class="adm-ni" onclick="adTab('rp')">Denúncias</div>
      <div class="adm-ni" onclick="adTab('lg')">Logs</div>
      <div class="adm-ni" onclick="adTab('bc')">Broadcast</div>
      <div class="adm-ni" onclick="adTab('st')">Config</div>
    </div>
    <div class="adm-main" id="adm-main"></div>
  </div>
</div>

<!-- LOGIN -->
<div class="page" id="page-login" style="overflow:hidden">
  <div class="login-pg">
    <div class="login-card">
      <h2>NEX<span style="color:var(--o)">US</span></h2>
      <p>Entre ou crie sua conta para jogar</p>
      <div class="lroles">
        <div class="lrole on" onclick="selRole(this,'p')">Jogador</div>
        <div class="lrole lrole-adm" onclick="selRole(this,'a')">Admin</div>
      </div>
      <div class="gender-sel">
        <button class="gender-btn on" data-g="m" onclick="document.querySelectorAll('.gender-btn').forEach(b=>{b.classList.remove('on','on-f')});this.classList.add('on');PROFILE.gender='m'">
          👦<span>Masculino</span>
        </button>
        <button class="gender-btn" data-g="f" onclick="document.querySelectorAll('.gender-btn').forEach(b=>{b.classList.remove('on','on-f')});this.classList.add('on-f');PROFILE.gender='f'">
          👧<span>Feminino</span>
        </button>
      </div>
      <div class="lff"><label>Usuário</label><input type="text" id="lu" placeholder="SeuNome" value="Jogador"></div>
      <div class="lff"><label>Senha</label><input type="password" id="lp" placeholder="••••••••" value="1234"></div>
      <button class="btn btn-c btn-lg" style="width:100%;justify-content:center;margin-bottom:10px" onclick="doLogin()">Entrar</button>
      <button class="btn btn-g btn-md" style="width:100%;justify-content:center" onclick="guestLogin()">Entrar como Convidado</button>
    </div>
  </div>
</div>

</div><!-- content -->
</div><!-- app -->

<!-- ===== 3D GAME VIEW ===== -->
<div id="game3d">
  <canvas id="c3d"></canvas>
</div>

<!-- ===== HUD ===== -->
<div id="hud">
  <div class="hud-vfx"><div class="hud-hit" id="hud-hit"></div></div>
  <div class="hud-top">
    <div style="display:flex;align-items:center;gap:12px">
      <span style="font-family:var(--fm);font-size:.85rem" id="hud-title">FUTEBOL 3D</span>
      <span class="hud-mode" id="hud-mode">BOT — FACIL</span>
    </div>
    <div class="hud-score">
      <span class="hs-l" id="hud-sl">0</span>
      <span class="hs-sep">:</span>
      <span class="hs-r" id="hud-sr">0</span>
    </div>
    <div style="display:flex;align-items:center;gap:12px">
      <span class="hud-timer" id="hud-timer">05:00</span>
      <button class="btn btn-sm btn-g" id="hud-pause" 
        onclick="if(document.pointerLockElement)document.exitPointerLock();togglePause()" 
        style="pointer-events:all;position:relative;z-index:600;cursor:pointer!important">Pausar</button>
      <button class="btn btn-sm btn-r" 
        onclick="if(document.pointerLockElement)document.exitPointerLock();exitGame3d()" 
        style="pointer-events:all;position:relative;z-index:600;cursor:pointer!important">Sair</button>
    </div>
  </div>
  <div class="exit-hint" id="exit-hint">Pressione ESC para soltar o mouse | Tab para chat</div>
  <div class="hud-crosshair" id="hud-cross"></div>
  <div class="hud-health">
    <div class="hud-hlbl">VIDA</div>
    <div class="hud-hbar"><div class="hud-hfill" id="hud-hfill" style="width:100%"></div></div>
  </div>
  <div class="hud-ammo" id="hud-ammo"></div>
  <div class="hud-kills" id="hud-kills"></div>
  <div class="hud-points" id="hud-points" style="position:absolute;top:60px;left:50%;transform:translateX(-50%);font-family:var(--fm);font-size:.8rem;color:var(--y);text-shadow:0 0 10px var(--y)"></div>
  <div id="score-layer" style="position:absolute;inset:0;pointer-events:none;z-index:20;overflow:hidden"></div>
  <div class="minimap"><canvas class="mm-canvas" id="mm-canvas"></canvas></div>
  <div class="hud-chatbox">
    <div class="hud-chatmsgs" id="hud-chatmsgs"></div>
    <div class="hud-ci" id="hud-ci-row">
      <input id="hud-ci-inp" placeholder="Chat..." onkeydown="if(event.key==='Enter')sendHudChat()" style="display:none">
      <button onclick="toggleHudChat()" style="background:var(--bd);color:var(--mu);border:none;padding:3px 8px;border-radius:4px;font-size:.72rem">Chat</button>
    </div>
  </div>
  <div id="ball-held-ind" class="ball-held-indicator" style="display:none">⛹ BOLA NA MÃO</div>
  <div id="power-meter-wrap">
    <div class="pm-label">FORÇA DO CHUTE</div>
    <div class="pm-bar-bg"><div id="pm-bar"></div></div>
    <div class="pm-tip">Solte F para chutar</div>
  </div>
</div>

<!-- DREAMCORE OVERLAY -->
<div id="dreamcore-overlay">
  <div class="dc-scanline"></div>
  <div class="dc-crt"></div>
  <div class="dc-hud" id="dc-hud-info">HP: 100<br>MODO: DREAMCORE<br>VID: 16BIT</div>
  <div class="dc-score" id="dc-score-info">SCORE<br>0 : 0</div>
  <div class="dc-kick-banner" id="dc-kick-banner">
    <div class="dc-kick-title">!! VOCÊ FOI KICKADO !!</div>
    <div class="dc-kick-msg" id="dc-kick-msg">Sua Internet e fraca</div>
  </div>
</div>
<!-- OVERHEAD NICKNAMES CONTAINER -->
<div id="nick-layer" style="position:fixed;inset:0;pointer-events:none;z-index:509;overflow:hidden"></div>
<!-- ===== CHARACTER SELECT ===== -->
<div id="char-select" style="display:none">
  <div class="cs-title">ESCOLHA SEU PERSONAGEM</div>
  <div class="cs-sub">Você tem <span id="cs-timer-val" style="color:var(--y);font-weight:700">10</span> segundos</div>
  <div class="cs-timer" id="cs-timer-bar">
    <div id="cs-timer-fill" style="width:100%;height:6px;background:var(--y);border-radius:3px;transition:width 1s linear;max-width:400px;margin:0 auto"></div>
  </div>
  <div class="cs-grid" id="cs-grid"></div>
  <button class="btn btn-lg btn-c" onclick="confirmChar()">Confirmar e Jogar</button>
</div>

<!-- ===== AI WIDGET ===== -->
<div id="aiw">
  <div class="aihd" onclick="toggleAI()">
    <div class="aiav">AI</div>
    <div class="aihd-t"><h4>Free Games IA</h4><p id="ai-st">Online — Pronto para ajudar</p></div>
    <div class="aictl">
      <button class="aib" onclick="event.stopPropagation();toggleAI()">—</button>
      <button class="aib" onclick="event.stopPropagation();document.getElementById('aiw').classList.add('gone')">✕</button>
    </div>
  </div>
  <div id="ai-body">
    <div class="aimsgs" id="ai-msgs"></div>
    <div class="aiqs">
      <button class="aiq" onclick="aiAsk('como jogar')">Como jogar?</button>
      <button class="aiq" onclick="aiAsk('3d')">Modo 3D</button>
      <button class="aiq" onclick="aiAsk('criar mapa')">Criar mapa</button>
      <button class="aiq" onclick="aiAsk('terror')">Terror</button>
      <button class="aiq" onclick="aiAsk('bots')">Bots</button>
      <button class="aiq" onclick="aiAsk('regras')">Regras</button>
      <button class="aiq" onclick="aiAsk('denunciar')">Denunciar</button>
      <button class="aiq" onclick="aiAsk('admin')">Admin</button>
    </div>
    <div id="ai-inp-row">
      <input id="ai-inp" placeholder="Pergunte algo..." onkeydown="if(event.key==='Enter')aiSendMsg()">
      <button id="ai-send" onclick="aiSendMsg()">Enviar</button>
    </div>
  </div>
</div>


<!-- MUSIC BAR -->
<div id="music-bar">
  <div class="mb-art" id="mb-art">🎵</div>
  <div class="mb-info">
    <div class="mb-title" id="mb-title">Nenhuma música</div>
    <div class="mb-artist" id="mb-artist">Free Games Music</div>
  </div>
  <div class="mb-prog" id="mb-prog" onclick="seekMusic(event)">
    <div class="mb-prog-fill" id="mb-prog-fill" style="width:0%"></div>
  </div>
  <div class="mb-controls">
    <button class="mb-btn" onclick="prevTrack()" title="Anterior">⏮</button>
    <button class="mb-btn" id="mb-play" onclick="togglePlay()">▶</button>
    <button class="mb-btn" onclick="nextTrack()" title="Próxima">⏭</button>
    <button class="mb-btn" id="mb-shuffle" onclick="toggleShuffle()" title="Aleatório">🔀</button>
    <button class="mb-btn" id="mb-repeat" onclick="toggleRepeat()" title="Repetir">🔁</button>
    <button class="mb-btn" onclick="togglePlaylist()" title="Playlist">≡</button>
  </div>
  <div class="mb-vol">
    <span style="font-size:.8rem">🔊</span>
    <input type="range" min="0" max="100" value="60" id="mb-vol-inp" oninput="setVolume(this.value)">
  </div>
  <button class="mb-btn" onclick="closeMusicBar()" title="Fechar">✕</button>
</div>

<!-- PLAYLIST POPUP -->
<div id="pl-popup">
  <div style="padding:10px 14px;font-family:var(--fm);font-size:.72rem;color:var(--c);border-bottom:1px solid var(--bd);display:flex;justify-content:space-between;align-items:center">
    PLAYLIST <span id="pl-count" style="color:var(--mu)"></span>
  </div>
  <div id="pl-list"></div>
</div>

<!-- Hidden YouTube iframe player -->
<iframe id="yt-player" style="display:none" allow="autoplay"></iframe>

<!-- TOASTS -->
<div id="toasts"></div>

<!-- SAVE INDICATOR -->
<div class="save-indicator" id="save-ind">💾 Salvo</div>

<!-- MINI BROWSER -->
<div id="mini-browser">
  <div class="mb-bar">
    <button class="mb-navbtn" onclick="mbBack()">←</button>
    <button class="mb-navbtn" onclick="mbFwd()">→</button>
    <button class="mb-navbtn" onclick="mbReload()">↻</button>
    <input class="mb-url" id="mb-url" value="https://www.youtube.com" onkeydown="if(event.key==='Enter')mbGo()">
    <button class="mb-go" onclick="mbGo()">IR</button>
    <button class="mb-navbtn" onclick="closeMB()" style="color:#ff6b6b;margin-left:4px">✕</button>
  </div>
  <div class="mb-tabs">
    <span class="mb-tab on" onclick="mbLoadUrl('https://www.youtube.com')">▶ YouTube</span>
    <span class="mb-tab" onclick="mbLoadUrl('https://en.wikipedia.org')">📖 Wiki</span>
    <span class="mb-tab" onclick="mbLoadUrl('https://scratch.mit.edu')">🐱 Scratch</span>
  </div>
  <iframe id="mb-frame" src="about:blank"></iframe>
</div>

<!-- MINECRAFT OVERLAY -->
<div id="mc-overlay">
  <div id="mc-lobby-screen" class="mc-lobby">
    <div style="font-size:3rem">⛏️</div>
    <h2>MODO MINECRAFT</h2>
    <p style="color:rgba(255,255,255,.5);font-size:.85rem;text-align:center;max-width:340px">Construa, explore e sobreviva com amigos em tempo real</p>
    <div style="display:flex;gap:10px;flex-wrap:wrap;justify-content:center">
      <button class="btn btn-gr btn-md" onclick="mcCreateRoom()">➕ Criar Sala</button>
      <button class="btn btn-g btn-md" onclick="mcShowJoin()">🚪 Entrar em Sala</button>
    </div>
    <div id="mc-join-section" style="display:none;flex-direction:column;align-items:center;gap:8px;margin-top:4px">
      <p style="color:rgba(255,255,255,.4);font-size:.78rem">Digite o código da sala (6 letras):</p>
      <input class="mc-inp" id="mc-code-inp" placeholder="XXXXXX" maxlength="6" oninput="this.value=this.value.toUpperCase()">
      <button class="btn btn-c btn-md" onclick="mcJoinRoom()">Entrar →</button>
    </div>
    <div id="mc-room-display" style="display:none;flex-direction:column;align-items:center;gap:10px;margin-top:4px">
      <p style="color:rgba(255,255,255,.4);font-size:.78rem">Código da sala (compartilhe com amigos):</p>
      <div class="mc-room-code" id="mc-code-disp">------</div>
      <button class="btn btn-sm btn-g" onclick="mcCopyCode()">📋 Copiar Código</button>
      <p style="color:rgba(255,255,255,.3);font-size:.75rem;margin-top:2px">Selecione o modo de jogo:</p>
      <div style="display:flex;gap:8px;flex-wrap:wrap;justify-content:center">
        <button class="btn btn-md" style="background:rgba(255,100,50,.2);border:1px solid rgba(255,100,50,.4);color:#ff6432" onclick="mcStartGame('survival')">⚔️ Sobrevivência</button>
        <button class="btn btn-md" style="background:rgba(33,150,243,.2);border:1px solid rgba(33,150,243,.4);color:#2196f3" onclick="mcStartGame('creative')">🏗️ Criativo</button>
      </div>
    </div>
    <button class="btn btn-sm btn-g" onclick="closeMC()" style="margin-top:10px">✕ Fechar</button>
  </div>
  <canvas id="mc-canvas" style="display:none"></canvas>
  <div id="mc-hud" style="display:none">
    <span style="font-family:var(--fm);font-size:.8rem;color:#4caf50">⛏️ MINECRAFT</span>
    <span id="mc-mode-lbl" style="font-size:.72rem;padding:2px 8px;border-radius:3px;background:rgba(76,175,80,.2);color:#4caf50;border:1px solid rgba(76,175,80,.3)">CRIATIVO</span>
    <span id="mc-coords" style="font-family:monospace;font-size:.72rem;color:rgba(255,255,255,.6)">X:0 Y:64 Z:0</span>
    <div style="margin-left:auto;display:flex;gap:6px">
      <button class="mc-hud-btn" id="mc-fly-btn" onclick="mcToggleFly()">✈️ Voar: OFF</button>
      <button class="mc-hud-btn" onclick="mcSaveWorld()">💾 Salvar</button>
      <button class="mc-hud-btn" style="color:#ff6b6b" onclick="closeMCGame()">✕ Sair</button>
    </div>
  </div>
  <div class="mc-crosshair" id="mc-cross" style="display:none"></div>
  <div id="mc-fly-ind">✈️ VOANDO</div>
  <div id="mc-info" style="display:none"></div>
  <div class="mc-toolbar" id="mc-toolbar" style="display:none"></div>
</div>

<!-- ADMIN POWERS PANEL -->
<div id="admin-powers">
  <div class="adp-title">⚡ ADMIN POWERS</div>
  <button class="adp-btn" id="adp-fly" onclick="adpToggle('fly')">✈️ Voar: OFF</button>
  <button class="adp-btn" id="adp-speed" onclick="adpToggle('speed')">⚡ Speed: OFF</button>
  <button class="adp-btn" id="adp-invis" onclick="adpToggle('invis')">👻 Invisível: OFF</button>
  <button class="adp-btn" id="adp-noclip" onclick="adpToggle('noclip')">🌀 Noclip: OFF</button>
  <button class="adp-btn" onclick="adpGiveNebux()">💰 +5000 NeBux</button>
  <button class="adp-btn" onclick="adpOpenSecret()">⭐ 7 A E MELHOR</button>
  <button class="adp-btn" onclick="if(S.running){addHudChat('Admin','🚀 Teleportando...','sys');player3d.x=0;player3d.y=5;player3d.z=0;}else toast('Entre em um jogo primeiro','warn')">📍 Teleportar Origem</button>
  <button class="adp-btn" onclick="document.getElementById('admin-powers').classList.remove('on')" style="margin-top:4px;color:var(--mu);font-size:.68rem">Fechar Painel</button>
</div>

<!-- SECRET: 7 A E MELHOR -->
<div id="secret-overlay">
  <canvas id="secret-canvas" class="secret-canvas" width="500" height="300"></canvas>
  <div class="secret-title">7 A E MELHOR</div>
  <div class="secret-sub">✦ ÁREA SECRETA LENDÁRIA ✦</div>
  <p style="color:rgba(255,215,64,.5);font-size:.82rem;max-width:420px;text-align:center;line-height:1.6">Parabéns! Você descobriu o local mais raro da plataforma.<br>Somente os mais corajosos e admins chegam aqui.</p>
  <div style="display:flex;gap:10px;flex-wrap:wrap;justify-content:center">
    <button class="btn btn-lg" style="background:linear-gradient(135deg,#ffd740,#ff9100);color:#000" onclick="collectSecretReward()">🏆 Coletar Recompensa Lendária</button>
    <button class="btn btn-md btn-g" onclick="closeSecret()">← Voltar</button>
  </div>
  <div id="secret-msg" style="color:rgba(255,215,64,.7);font-size:.82rem;text-align:center;margin-top:6px;min-height:24px"></div>
</div>

<!-- ===== MODALS ===== -->
<!-- GAME MODAL -->
<div class="mbg" id="gm-modal">
  <div class="modal">
    <div class="mhd"><h3 id="gm-title">Configurar Partida</h3><button class="mx" onclick="closeM('gm-modal')">✕</button></div>
    <div class="mbody">
      <div style="background:linear-gradient(135deg,rgba(0,245,255,.04),rgba(213,0,249,.04));border:1px solid rgba(0,245,255,.12);border-radius:10px;padding:14px;margin-bottom:18px;display:flex;gap:12px">
        <div style="width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,var(--c),var(--p));display:flex;align-items:center;justify-content:center;font-size:.85rem;flex-shrink:0;animation:aiglow 3s infinite">AI</div>
        <div><div style="font-family:var(--fm);font-size:.72rem;color:var(--c);margin-bottom:4px">IA Free Games — SUPORTE</div>
          <div id="gm-ai-tip" style="font-size:.8rem;line-height:1.5"></div>
          <div id="gm-typing" class="aitdots" style="display:none"><div class="td"></div><div class="td"></div><div class="td"></div></div>
        </div>
      </div>
      <div class="osec"><div class="olbl">Adversário</div>
        <div class="ogrp" id="opt-opp">
          <button class="ob sel" onclick="setOpt(this,'opp','bot')">Bot IA</button>
          <button class="ob" onclick="setOpt(this,'opp','pvp')">Multiplayer</button>
          <button class="ob" onclick="setOpt(this,'opp','mix')">Misto</button>
          <button class="ob" onclick="setOpt(this,'opp','solo')">Solo</button>
        </div>
      </div>
      <div class="osec" id="diff-sec">
        <div class="olbl">Dificuldade</div>
        <div class="ogrp">
          <button class="ob sel-g" style="border-color:var(--g);color:var(--g);background:rgba(0,230,118,.06)" onclick="setOpt(this,'diff','easy')">Fácil</button>
          <button class="ob sel" onclick="setOpt(this,'diff','med')">Médio</button>
          <button class="ob" onclick="setOpt(this,'diff','hard')">Difícil</button>
          <button class="ob" onclick="setOpt(this,'diff','insane')">Insano</button>
          <button class="ob" onclick="setOpt(this,'diff','ultra')">ULTRA INSANO</button>
        </div>
      </div>
      <div class="osec" id="bot-sec" style="display:none">
        <div class="olbl">Comportamento dos Bots</div>
        <div class="ogrp">
          <button class="ob sel" onclick="setOpt(this,'bot-b','agr')">Agressivo</button>
          <button class="ob" onclick="setOpt(this,'bot-b','def')">Defensivo</button>
          <button class="ob" onclick="setOpt(this,'bot-b','rnd')">Aleatório</button>
          <button class="ob" onclick="setOpt(this,'bot-b','int')">Inteligente</button>
        </div>
        <div class="olbl" style="margin-top:12px">Bots no Time (1-5)</div>
        <input type="range" id="bot-count" min="1" max="5" value="1" style="width:100%;margin-top:5px;accent-color:var(--c)">
        <div id="bot-count-lbl" style="font-size:.75rem;color:var(--mu);margin-top:3px">1 bot por time</div>
      </div>
      <div class="osec" id="lobby-sec" style="display:none">
        <div class="olbl">Lobby</div>
        <div class="lgrid" id="lob-grid"></div>
      </div>
      <div class="osec">
        <div class="olbl">Dimensão</div>
        <div class="ogrp">
          <button class="ob" onclick="setOpt(this,'dim','2d')">2D Arcade</button>
          <button class="ob sel" onclick="setOpt(this,'dim','3d')">3D Imersivo</button>
        </div>
      </div>
      <div class="osec">
        <div class="olbl">Duração</div>
        <div class="ogrp">
          <button class="ob" onclick="setOpt(this,'dur','2')">2 min</button>
          <button class="ob sel" onclick="setOpt(this,'dur','5')">5 min</button>
          <button class="ob" onclick="setOpt(this,'dur','10')">10 min</button>
          <button class="ob" onclick="setOpt(this,'dur','99')">Sem limite</button>
        </div>
      </div>
      <button class="btn btn-c btn-lg" style="width:100%;justify-content:center;margin-top:4px" onclick="goCharSelect()">Jogar</button>
    </div>
  </div>
</div>

<!-- CREATE ROOM MODAL -->
<div class="mbg" id="cr-modal">
  <div class="modal">
    <div class="mhd"><h3>Criar Nova Sala</h3><button class="mx" onclick="closeM('cr-modal')">✕</button></div>
    <div class="mbody">
      <div class="osec"><div class="olbl">Nome</div><input style="width:100%;background:var(--s3);border:1px solid var(--bd);color:var(--w);padding:9px 12px;border-radius:7px;font-family:var(--f);font-size:.88rem;outline:none" id="cr-nm" placeholder="Minha Sala Épica"></div>
      <div class="osec"><div class="olbl">Jogo</div>
        <select style="width:100%;background:var(--s3);border:1px solid var(--bd);color:var(--w);padding:9px;border-radius:7px;font-family:var(--f);font-size:.85rem;outline:none" id="cr-gm">
          <option>Futebol 3D</option><option>Basquete 3D</option><option>Terror Escape</option><option>Aim Lab</option><option>PvP Arena</option><option>Corrida 3D</option>
        </select>
      </div>
      <div class="osec"><div class="olbl">Privacidade</div>
        <div class="ogrp">
          <button class="ob sel" onclick="setOpt(this,'rp','pub')">Pública</button>
          <button class="ob" onclick="setOpt(this,'rp','prv')">Privada</button>
        </div>
      </div>
      <div class="osec"><div class="olbl">Dificuldade</div>
        <div class="ogrp">
          <button class="ob sel" onclick="setOpt(this,'rd','easy')">Fácil</button>
          <button class="ob" onclick="setOpt(this,'rd','med')">Médio</button>
          <button class="ob" onclick="setOpt(this,'rd','hard')">Difícil</button>
          <button class="ob" onclick="setOpt(this,'rd','ultra')">Ultra Insano</button>
        </div>
      </div>
      <div class="osec"><div class="olbl">Max Jogadores</div>
        <div class="ogrp">
          <button class="ob" onclick="setOpt(this,'rmx','2')">2</button>
          <button class="ob sel" onclick="setOpt(this,'rmx','4')">4</button>
          <button class="ob" onclick="setOpt(this,'rmx','8')">8</button>
          <button class="ob" onclick="setOpt(this,'rmx','16')">16</button>
        </div>
      </div>
      <button class="btn btn-c btn-lg" style="width:100%;justify-content:center" onclick="createRoom()">Criar Sala</button>
    </div>
  </div>
</div>

<!-- ROOM MODAL -->
<div class="mbg" id="rm-modal">
  <div class="modal">
    <div class="mhd"><h3 id="rm-title">Sala</h3><button class="mx" onclick="closeM('rm-modal')">✕</button></div>
    <div class="mbody">
      <div class="lgrid" id="rm-lob"></div>
      <div style="background:var(--s3);border:1px solid var(--bd);border-radius:9px;padding:12px;margin:14px 0">
        <div style="display:flex;justify-content:space-between;font-size:.8rem;margin-bottom:5px"><span style="color:var(--mu)">Jogo</span><span id="rm-gm">—</span></div>
        <div style="display:flex;justify-content:space-between;font-size:.8rem;margin-bottom:5px"><span style="color:var(--mu)">Dificuldade</span><span id="rm-df">—</span></div>
        <div style="display:flex;justify-content:space-between;font-size:.8rem"><span style="color:var(--mu)">Status</span><span style="color:var(--g)">Aguardando</span></div>
      </div>
      <div style="background:var(--s3);border:1px solid var(--bd);border-radius:9px;overflow:hidden;margin-bottom:14px">
        <div style="padding:9px 12px;border-bottom:1px solid var(--bd);font-family:var(--fm);font-size:.72rem;color:var(--c)">Chat da Sala</div>
        <div style="height:100px;overflow-y:auto;padding:8px;display:flex;flex-direction:column;gap:6px" id="rm-chat"></div>
        <div style="display:flex;gap:5px;padding:7px;border-top:1px solid var(--bd)">
          <input style="flex:1;background:var(--s2);border:1px solid var(--bd);color:var(--w);padding:6px 9px;border-radius:6px;font-family:var(--f);font-size:.8rem;outline:none" id="rm-ci" placeholder="Mensagem..." onkeydown="if(event.key==='Enter')rmChat()">
          <button style="background:var(--c);color:#000;border:none;padding:6px 10px;border-radius:6px;font-size:.75rem;font-weight:700" onclick="rmChat()">OK</button>
        </div>
      </div>
      <button class="btn btn-c btn-lg" style="width:100%;justify-content:center" onclick="enterRm()">Entrar na Partida</button>
    </div>
  </div>
</div>

<script>
// ═══════════════════════════════════════
// STATE
// ═══════════════════════════════════════
const S = {
  user:null, isAdmin:false, char:null,
  game:null,
  opts:{ opp:'bot', diff:'easy', dim:'3d', dur:'5', 'bot-b':'agr', rp:'pub', rd:'easy', rmx:'4' },
  running:false, paused:false, timer:300,
  sL:0, sR:0, hp:100, kills:0, ammo:30,
  mapData:{}, tile:'🟩', dim:'2d',
  curRoom:null,
  adminTab:'ov'
};
let gTimer=null, raf=null;

// ═══════════════════════════════════════
// FAKE DATA
// ═══════════════════════════════════════
const PLAYERS = ['ZephyrPro','NovaStar','CyberDunk','KingSlayer','NightCrawler','RacerX','ParkourK','DarkWarden','NeonRifle','StormHunt','AimGod99','PixelWarr','ShadowRun','BlazeKick','FrostByte'];
const PCOLORS = ['#00f5ff','#ff6b00','#ff1744','#ffd740','#d500f9','#00e676','#ff006e','#00b8d9','#ff9100','#76ff03'];

const CHARS = [
  { id:'apex',  name:'Apex',      type:'Velocidade',   spd:95, str:60, def:70,  special:'Dash Triplo',    desc:'Atleta ultra-veloz, ideal para futebol e corrida' },
  { id:'tank',  name:'Titan',     type:'Tanque',        spd:45, str:95, def:90,  special:'Escudo Brutal',  desc:'Corpo enorme, absorve dano e derruba inimigos' },
  { id:'ghost', name:'Shade',     type:'Stealth',       spd:80, str:65, def:55,  special:'Invisibilidade', desc:'Agente fantasma, mestre do terror e furtividade' },
  { id:'snip',  name:'Hawkeye',   type:'Precisão',      spd:60, str:70, def:60,  special:'Olho de Águia',  desc:'Atirador de elite, perfeito para Aim Lab e PvP' },
  { id:'mage',  name:'Voltex',    type:'Tecnologia',    spd:70, str:75, def:65,  special:'Pulso EMP',      desc:'Especialista em gadgets e ataques elétricos' },
  { id:'beast', name:'Feral',     type:'Força Bruta',   spd:65, str:90, def:75,  special:'Modo Berserk',   desc:'Lutador feroz, explode de dano em curto prazo' },
];

const GAMES_DATA = [
  { id:'football',  cat:'Esportes', name:'Futebol 3D',     bg:'#0a2a0a', desc:'Campo 3D completo com times de bots e multiplayer.', online:980,  modes:['2D','3D'], bots:true,  tags:['HOT'] },
  { id:'basketball',cat:'Esportes', name:'Basquete 3D',    bg:'#2a1200', desc:'Quadra 3D com enterradas e arremessos espetaculares.', online:542, modes:['3D'],    bots:true,  tags:['NEW'] },
  { id:'racing',    cat:'Esportes', name:'Corrida 3D',     bg:'#200020', desc:'Pistas abertas com nitro, colisões e física real.', online:724,    modes:['3D'],    bots:true,  tags:['HOT'] },
  { id:'aimlab',    cat:'Ação',    name:'Aim Lab',         bg:'#001a2a', desc:'Treine sua mira com alvos 3D dinâmicos e rankings.', online:1204,  modes:['3D'],    bots:false, tags:['HOT','NEW'] },
  { id:'pvp',       cat:'Ação',    name:'PvP Arena 3D',    bg:'#180028', desc:'Combate FPS 3D com pointer lock e física realista.', online:1540,  modes:['3D'],    bots:true,  tags:['HOT'] },
  { id:'ctf',       cat:'Ação',    name:'Capture a Bandeira',bg:'#202000',desc:'Roube e defenda bandeiras em arenas 3D enormes.', online:430,  modes:['2D','3D'],bots:true,  tags:[] },
  { id:'survival',  cat:'Ação',    name:'Sobrevivência',   bg:'#001a1a', desc:'Hordas infinitas. Quanto tempo você dura?', online:318,             modes:['3D'],    bots:true,  tags:['NEW'] },
  { id:'escape',    cat:'Terror',  name:'Escape do Terror',bg:'#0a0000', desc:'Ambiente 3D escuro com monstro caçando jogadores.', online:1100,  modes:['3D'],    bots:false, tags:['HOT','TERROR'] },
  { id:'labyrinth', cat:'Terror',  name:'Labirinto Maldito',bg:'#050008',desc:'Labirinto 3D gerado proceduralmente. Escapa se puder.', online:677,modes:['3D'],    bots:false, tags:['TERROR'] },
  { id:'horror-coop',cat:'Terror', name:'Terror Coop',     bg:'#080010', desc:'4 jogadores contra o monstro. Coop 3D completo.', online:443,     modes:['3D'],    bots:false, tags:['TERROR','NEW'] },
  { id:'adventure', cat:'Aventura',name:'Aventura 3D',     bg:'#0a1a05', desc:'Mundo aberto, missões e coleta de itens em 3D.', online:289,      modes:['3D'],    bots:true,  tags:['NEW'] },
  { id:'parkour',   cat:'Casual',  name:'Parkour Extremo', bg:'#10102a', desc:'Pule e corra por plataformas 3D impossíveis.', online:567,         modes:['3D'],    bots:false, tags:['HOT'] },
  { id:'dreamcore', cat:'Especial',name:'DreamCore 16-BIT',bg:'#000820', desc:'Mundo 16-bit em 3D pixelado com IA profissional e eventos imprevisíveis.', online:333, modes:['3D'], bots:true, tags:['NEW','HOT'] },
  { id:'volleyball',cat:'Esportes', name:'Vôlei 3D',       bg:'#001a3a', desc:'Quadra 3D com manchetes, levantamentos e cortadas espetaculares.', online:412, modes:['3D'], bots:true, tags:['NEW'] },
  { id:'tennis',    cat:'Esportes', name:'Tênis 3D',        bg:'#0a2a00', desc:'Quadra de tênis 3D com física real de bola e serviços potentes.', online:287, modes:['3D'], bots:true, tags:[] },
  { id:'boxing',    cat:'Ação',    name:'Boxe 3D',          bg:'#2a0000', desc:'Ringue 3D com combos, esquivas e nocautes em câmera lenta.', online:634, modes:['3D'], bots:true, tags:['HOT'] },
  { id:'archery',   cat:'Ação',    name:'Tiro com Arco',    bg:'#0a1a00', desc:'Alvos em movimento, ventos e distâncias crescentes. Precisão máxima!', online:198, modes:['3D'], bots:false, tags:['NEW'] },
  { id:'chess',     cat:'Casual',  name:'Xadrez 3D',        bg:'#1a1a1a', desc:'Xadrez clássico com peças 3D animadas e IA de vários níveis.', online:521, modes:['3D'], bots:true, tags:[] },
  { id:'swimming',  cat:'Esportes', name:'Natação',          bg:'#001428', desc:'Competição de natação com raia 3D, técnicas e recordes.', online:165, modes:['3D'], bots:true, tags:['NEW'] },
  { id:'cycling',   cat:'Esportes', name:'Ciclismo 3D',      bg:'#141400', desc:'Pedale por montanhas, cidades e pistas de velódromo em 3D.', online:244, modes:['3D'], bots:true, tags:[] },
  { id:'dance',     cat:'Casual',  name:'Dance Battle',     bg:'#200028', desc:'Batalha de dança com timing, combos e estilos únicos de personagem.', online:889, modes:['3D'], bots:true, tags:['HOT','NEW'] },
  { id:'skiing',    cat:'Casual',  name:'Esqui Radical',    bg:'#002030', desc:'Desça montanhas nevadas desviando de obstáculos em alta velocidade.', online:376, modes:['3D'], bots:true, tags:['NEW'] },
  { id:'nexusbots', cat:'Especial',name:'NexusBots',        bg:'#050010', desc:'Criaturas estranhas correm pelo mapa enorme! Sobreviva ou corra.', online:666, modes:['3D'], bots:true, tags:['HOT','NEW'] },
  { id:'battleroyale',cat:'Ação',  name:'Battle Royale',   bg:'#0a1400', desc:'Mapa gigante com zona de dano. Última pessoa viva vence!', online:2840, modes:['3D'], bots:true, tags:['HOT','NEW'] },
  { id:'aimlabpvp',  cat:'Ação',   name:'Aimlab PvP',      bg:'#001428', desc:'Duela de mira com um bot IA. Quem acerta mais alvos vence!', online:988, modes:['3D'], bots:true, tags:['NEW'] },
  { id:'minecraft',  cat:'Especial',name:'Minecraft Mode',  bg:'#1a2a0a', desc:'Construa e explore com amigos! Salas por código, sobrevivência e criativo.', online:1234, modes:['3D'], bots:false, tags:['HOT','NEW'] },
];

const ROOMS_DATA = [
  { name:'Futebol Pros',     game:'Futebol 3D',    players:3, max:6,  diff:'med',   priv:false, host:'ZephyrPro' },
  { name:'Terror Coop MAX',  game:'Terror Coop',   players:2, max:4,  diff:'ultra', priv:false, host:'NightCrawler' },
  { name:'Aim Lab Ranked',   game:'Aim Lab',       players:1, max:8,  diff:'hard',  priv:false, host:'AimGod99' },
  { name:'PvP Elite',        game:'PvP Arena 3D',  players:4, max:4,  diff:'ultra', priv:true,  host:'KingSlayer' },
  { name:'Corrida Noobs',    game:'Corrida 3D',    players:2, max:6,  diff:'easy',  priv:false, host:'NewPlayer99' },
  { name:'Labirinto Inferno',game:'Labirinto',     players:3, max:4,  diff:'ultra', priv:false, host:'CyberDunk' },
];

const COMM_MAPS = [
  { name:'Arena Neon',        author:'CyberDunk',   tile:'▪',  cat:'Ação',    likes:312,  plays:2100, r:4.8 },
  { name:'Campo do Inferno',  author:'ZephyrPro',   tile:'▫',  cat:'Esportes',likes:234,  plays:1560, r:4.6 },
  { name:'Labirinto Maldito', author:'NightCrawler',tile:'■',  cat:'Terror',  likes:876,  plays:5400, r:4.9 },
  { name:'Pista Galáxia',     author:'RacerX',      tile:'▪',  cat:'Esportes',likes:445,  plays:3200, r:4.7 },
  { name:'Bunker Zero',       author:'SurvivalKing',tile:'▫',  cat:'Ação',    likes:98,   plays:445,  r:4.1 },
  { name:'Caverna do Medo',   author:'HorrorMstr',  tile:'■',  cat:'Terror',  likes:543,  plays:3800, r:4.9 },
  { name:'Parque Louco',      author:'ParkourK',    tile:'▪',  cat:'Casual',  likes:167,  plays:1100, r:4.3 },
  { name:'Objetivo Final',    author:'DarkWarden',  tile:'▫',  cat:'Aventura',likes:209,  plays:860,  r:4.5 },
];

// ═══════════════════════════════════════
// CURSOR
// ═══════════════════════════════════════
const cur = document.getElementById('cursor');
const curDot = document.getElementById('cursor-dot');
document.addEventListener('mousemove', e=>{
  cur.style.left=e.clientX+'px'; cur.style.top=e.clientY+'px';
  curDot.style.left=e.clientX+'px'; curDot.style.top=e.clientY+'px';
});
document.addEventListener('mousedown',()=>{cur.style.width='12px';cur.style.height='12px';cur.style.background='rgba(0,245,255,.2)'});
document.addEventListener('mouseup',()=>{cur.style.width='18px';cur.style.height='18px';cur.style.background=''});

// ═══════════════════════════════════════
// VFX PARTICLES
// ═══════════════════════════════════════
function spawnParticles(){
  const vfx=document.getElementById('vfx-layer');
  for(let i=0;i<15;i++){
    const p=document.createElement('div'); p.className='vp';
    const size=Math.random()*4+1;
    const color=Math.random()>.5?'var(--c)':Math.random()>.5?'var(--p)':'var(--o)';
    p.style.cssText=`width:${size}px;height:${size}px;left:${Math.random()*100}%;background:${color};opacity:${Math.random()*.4+.1};animation-duration:${Math.random()*10+8}s;animation-delay:${Math.random()*10}s`;
    vfx.appendChild(p);
  }
}
spawnParticles();

// ═══════════════════════════════════════
// NAVIGATION
// ═══════════════════════════════════════
function goPage(id){
  if(!S.user&&id!=='login'){goPage('login');return;}
  document.querySelectorAll('.page').forEach(p=>p.classList.remove('on'));
  document.querySelectorAll('.tnb').forEach(b=>b.classList.remove('on'));
  const pg=document.getElementById('page-'+id);
  if(pg) pg.classList.add('on');
  const map={home:0,games:1,rooms:2,creative:3,community:4,profile:5,search:6};
  const btns=document.querySelectorAll('.tnb');
  if(map[id]!==undefined&&btns[map[id]]) btns[map[id]].classList.add('on');
  if(id==='admin') renderAdmin();
  if(id==='profile') renderProfile();
  if(id==='creative') initME();
  if(id==='community') renderComm();
  if(id==='games') renderGames();
  if(id==='rooms') renderRooms();
  if(id==='search') initSearch();
  if(id==='home') renderHome();
}

// ═══════════════════════════════════════
// LOGIN
// ═══════════════════════════════════════
let loginRole='p';
function selRole(el,r){
  document.querySelectorAll('.lrole').forEach(x=>x.classList.remove('on'));
  el.classList.add('on'); loginRole=r;
}
function doLogin(){
  const u=document.getElementById('lu').value||'Jogador';
  S.user=u; S.isAdmin=(loginRole==='a');
  document.getElementById('av-btn').textContent=u[0].toUpperCase();
  document.getElementById('p-av').textContent=u[0].toUpperCase();
  document.getElementById('p-name').textContent=u;
  document.getElementById('adm-btn').style.display=S.isAdmin?'':'none';
  toast(`Bem-vindo, ${u}! ${S.isAdmin?'Admin ativado.':'Bom jogo!'}`, 'ok');
  goPage('home');
  setTimeout(()=>aiInit(),1200);
}
function guestLogin(){
  S.user='Convidado'; S.isAdmin=false;
  initPlayerProfile('Convidado');
  document.getElementById('av-btn').textContent='G';
  document.getElementById('topbar-nebux').textContent=PROFILE.nebux.toLocaleString();
  toast('Entrando como convidado...','');
  goPage('home');
  setTimeout(()=>aiInit(),1200);
}

// ═══════════════════════════════════════
// HOME
// ═══════════════════════════════════════
function renderHome(){
  // Hero 3D canvas
  initHeroCanvas();
  // Ticker
  const msgs=['ZephyrPro marcou gol épico no Futebol 3D!','Novo recorde no Aim Lab — 9840 pontos!','Terror Coop — 4 vagas disponíveis!','ArcadeKing publicou mapa "Neon Arena"!','Torneio PvP começa em 2 horas!','NightCrawler sobreviveu 3 minutos no Labirinto Insano!'];
  const ti=document.getElementById('ticker-inn');
  if(ti) ti.innerHTML=[...msgs,...msgs].map(m=>`<span class="tmsg"> — ${m}</span>`).join('');
  // Featured
  const hf=document.getElementById('home-feat');
  if(hf) hf.innerHTML=GAMES_DATA.slice(0,4).map(g=>gcHTML(g)).join('');
  // Cats
  const cats=[{id:'Esportes',icon:'◎',c:'#00e676'},{id:'Ação',icon:'◈',c:'#ff6b00'},{id:'Terror',icon:'◉',c:'#ff1744'},{id:'Aventura',icon:'◌',c:'#ffd740'},{id:'Casual',icon:'◍',c:'#d500f9'}];
  const cr=document.getElementById('cat-row');
  if(cr) cr.innerHTML=cats.map(c=>`<div onclick="filterGames('${c.id}')" style="background:var(--s1);border:1px solid var(--bd);border-radius:10px;padding:16px 12px;text-align:center;transition:all .2s" onmouseover="this.style.borderColor='${c.c}';this.style.transform='translateY(-3px)'" onmouseout="this.style.borderColor='var(--bd)';this.style.transform='none'">
      <div style="font-size:2rem;color:${c.c};margin-bottom:6px">${c.icon}</div>
      <div style="font-weight:700;font-size:.82rem">${c.id}</div>
      <div style="font-size:.68rem;color:var(--mu);margin-top:2px">${GAMES_DATA.filter(g=>g.cat===c.id).length} jogos</div>
    </div>`).join('');
  // Rooms preview
  const hr=document.getElementById('home-rooms');
  if(hr) hr.innerHTML=ROOMS_DATA.slice(0,3).map(r=>rcHTML(r)).join('');
  // Maps preview
  const hm=document.getElementById('home-maps');
  if(hm) hm.innerHTML=COMM_MAPS.slice(0,4).map(m=>mccHTML(m)).join('');
}

// ═══════════════════════════════════════
// HERO CANVAS (Three.js background)
// ═══════════════════════════════════════
function initHeroCanvas(){
  const cv=document.getElementById('hero-canvas');
  if(!cv||cv._init) return; cv._init=true;
  const W=cv.offsetWidth||window.innerWidth, H=cv.offsetHeight||400;
  cv.width=W; cv.height=H;
  const scene=new THREE.Scene();
  const cam=new THREE.PerspectiveCamera(60,W/H,.1,1000);
  cam.position.set(0,0,5);
  const renderer=new THREE.WebGLRenderer({canvas:cv,antialias:true,alpha:true});
  renderer.setSize(W,H); renderer.setClearColor(0x000000,0);
  // Floating particles
  const geo=new THREE.BufferGeometry();
  const N=300, pos=new Float32Array(N*3);
  for(let i=0;i<N*3;i++) pos[i]=(Math.random()-.5)*20;
  geo.setAttribute('position',new THREE.BufferAttribute(pos,3));
  const mat=new THREE.PointsMaterial({color:0x00f5ff,size:.04,transparent:true,opacity:.6});
  const pts=new THREE.Points(geo,mat);
  scene.add(pts);
  // Floating geometric shapes
  const shapes=[];
  for(let i=0;i<8;i++){
    const g=Math.random()>.5?new THREE.IcosahedronGeometry(Math.random()*.3+.1,0):new THREE.OctahedronGeometry(Math.random()*.25+.1,0);
    const m=new THREE.MeshBasicMaterial({color:Math.random()>.5?0x00f5ff:0xd500f9,wireframe:true,transparent:true,opacity:.25});
    const mesh=new THREE.Mesh(g,m);
    mesh.position.set((Math.random()-.5)*8,(Math.random()-.5)*3,(Math.random()-.5)*3);
    mesh.userData={rx:Math.random()*.01-.005,ry:Math.random()*.01-.005};
    scene.add(mesh); shapes.push(mesh);
  }
  let t=0;
  function anim(){
    requestAnimationFrame(anim);
    t+=.005;
    pts.rotation.y=t*.2;
    shapes.forEach(s=>{s.rotation.x+=s.userData.rx;s.rotation.y+=s.userData.ry;});
    cam.position.x=Math.sin(t)*.5;
    cam.position.y=Math.cos(t*.7)*.3;
    renderer.render(scene,cam);
  }
  anim();
}

// ═══════════════════════════════════════
// CARD HTML HELPERS
// ═══════════════════════════════════════
const GAME_ICONS={
  football:'⚽', basketball:'🏀', racing:'🏎️', aimlab:'🎯', pvp:'🔫',
  ctf:'🚩', survival:'🧟', escape:'👻', labyrinth:'🌀', 'horror-coop':'🕯️',
  adventure:'🗺️', parkour:'🏃', dreamcore:'🕹️',
  volleyball:'🏐', tennis:'🎾', boxing:'🥊', chess:'♟️', archery:'🏹',
  swimming:'🏊', cycling:'🚴', skiing:'⛷️', dance:'💃',
  nexusbots:'👾', battleroyale:'🎯', aimlabpvp:'🎯', minecraft:'⛏️'
};
function gcHTML(g){
  const bgs=g.tags.map(t=>`<span class="gb gb-${t.toLowerCase()}">${t}</span>`).join('');
  const dim=g.modes.includes('3D')?`<span class="gb gb-3d">3D</span>`:`<span class="gb gb-2d">2D</span>`;
  const ter=g.cat==='Terror'?`<span class="gb gb-tr">TERROR</span>`:'';
  const icon=GAME_ICONS[g.id]||'🎮';
  return `<div class="gc" onclick="openGM('${g.id}')">
    <div class="gct" style="background:linear-gradient(135deg,${g.bg},${g.bg}cc);position:relative">
      <div class="gcbadges">${bgs}${dim}${ter}</div>
      <canvas class="gct-3d" id="gc3d-${g.id}" width="240" height="140" style="position:absolute;inset:0"></canvas>
      <div style="position:absolute;inset:0;display:flex;align-items:center;justify-content:center;z-index:1;pointer-events:none">
        <span style="font-size:3.8rem;filter:drop-shadow(0 2px 12px rgba(0,0,0,.7));opacity:.85">${icon}</span>
      </div>
    </div>
    <div class="gcb">
      <div class="gctitle">${g.name}</div>
      <div class="gcdesc">${g.desc}</div>
      <div class="gcmeta">
        <span class="gconl"><span class="pdot" style="width:5px;height:5px"></span>${g.online.toLocaleString()}</span>
        <button class="gcplay" onclick="event.stopPropagation();openGM('${g.id}');playSound('click')">JOGAR</button>
      </div>
    </div>
  </div>`;
}

function rcHTML(r){
  const dc=r.diff==='easy'?'rcd-e':r.diff==='med'?'rcd-m':r.diff==='ultra'?'rcd-i':'rcd-h';
  const dl=r.diff==='easy'?'Fácil':r.diff==='med'?'Médio':r.diff==='ultra'?'Ultra Insano':'Difícil';
  return `<div class="rc" onclick="openRoom('${r.name}','${r.game}','${dl}')">
    <div class="rc-hd">
      <span class="rc-name">${r.name}</span>
      <span class="rc-pub ${r.priv?'rcpr':'rcp'}">${r.priv?'Privada':'Pública'}</span>
    </div>
    <div class="rc-game">${r.game}</div>
    <div class="rc-meta">
      <span class="rc-ms">${r.players}/${r.max} jogadores</span>
      <span class="rc-ms">${r.host}</span>
    </div>
    <span class="rcd ${dc}">${dl}</span>
  </div>`;
}

function mccHTML(m){
  return `<div class="mcc" onclick="playMap('${m.name}')">
    <div class="mcc-pre" style="font-size:2.5rem">${m.tile||'▪'}</div>
    <div class="mcc-n">${m.name}${m.isNew?'<span style="background:rgba(0,230,118,.1);border:1px solid rgba(0,230,118,.2);color:var(--g);padding:2px 7px;border-radius:3px;font-size:.65rem;margin-left:7px">NOVO</span>':''}</div>
    <div class="mcc-a">por ${m.author} · ${m.cat}</div>
    <div class="mcc-f">
      <div class="mcc-s">
        <span class="mcc-st">♥ ${m.likes}</span>
        <span class="mcc-st">▷ ${m.plays}</span>
        <span class="mcc-st">★ ${m.r}</span>
      </div>
      <button style="background:var(--o);color:#fff;border:none;padding:3px 10px;border-radius:5px;font-size:.68rem;font-weight:700" onclick="event.stopPropagation();playMap('${m.name}')">JOGAR</button>
    </div>
  </div>`;
}

// Render tiny 3D preview in card
setTimeout(()=>{
  GAMES_DATA.forEach(g=>{
    const cv=document.getElementById('gc3d-'+g.id);
    if(!cv) return;
    renderCardPreview(cv,g);
  });
},500);

function renderCardPreview(cv,g){
  try{
    const scene=new THREE.Scene();
    const cam=new THREE.PerspectiveCamera(50,cv.width/cv.height,.1,100);
    cam.position.set(0,1.5,3);
    cam.lookAt(0,0,0);
    const renderer=new THREE.WebGLRenderer({canvas:cv,antialias:true,alpha:true});
    renderer.setSize(cv.width,cv.height);
    renderer.setClearColor(0x000000,0);
    // Floor
    const fl=new THREE.Mesh(new THREE.PlaneGeometry(4,4),new THREE.MeshBasicMaterial({color:g.cat==='Terror'?0x110000:g.cat==='Esportes'?0x003300:0x001122,transparent:true,opacity:.5}));
    fl.rotation.x=-Math.PI/2; scene.add(fl);
    // Grid lines on floor
    const gh=new THREE.GridHelper(4,8,g.cat==='Terror'?0x330000:0x004444,g.cat==='Terror'?0x110000:0x002222);
    scene.add(gh);
    // Character preview shape
    const bodyGeo=new THREE.CapsuleGeometry?new THREE.CylinderGeometry(.15,.2,.8,8):new THREE.CylinderGeometry(.15,.2,.8,8);
    const bodyMat=new THREE.MeshBasicMaterial({color:g.cat==='Terror'?0x660022:g.cat==='Esportes'?0x003388:0x002244,wireframe:false});
    const body=new THREE.Mesh(bodyGeo,bodyMat);
    body.position.y=.4; scene.add(body);
    // Head
    const head=new THREE.Mesh(new THREE.SphereGeometry(.14,8,8),new THREE.MeshBasicMaterial({color:0xffcc99}));
    head.position.y=1; scene.add(head);
    // Arms
    const armG=new THREE.CylinderGeometry(.05,.05,.4,6);
    const armM=new THREE.MeshBasicMaterial({color:g.cat==='Terror'?0x440011:0x002244});
    const la=new THREE.Mesh(armG,armM); la.position.set(-.25,.5,0); la.rotation.z=Math.PI/4; scene.add(la);
    const ra=new THREE.Mesh(armG,armM); ra.position.set(.25,.5,0); ra.rotation.z=-Math.PI/4; scene.add(ra);
    // Game object
    let gObj;
    if(g.id==='football'){
      gObj=new THREE.Mesh(new THREE.SphereGeometry(.15,8,8),new THREE.MeshBasicMaterial({color:0xffffff,wireframe:true}));
      gObj.position.set(.8,.15,0);
    } else if(g.id==='aimlab'){
      gObj=new THREE.Mesh(new THREE.SphereGeometry(.12,8,8),new THREE.MeshBasicMaterial({color:0xff1744}));
      gObj.position.set(.8,.5,0);
    } else {
      gObj=new THREE.Mesh(new THREE.BoxGeometry(.3,.3,.3),new THREE.MeshBasicMaterial({color:0x00f5ff,wireframe:true}));
      gObj.position.set(.8,.15,0);
    }
    scene.add(gObj);
    // Ambient glow sphere
    const glow=new THREE.Mesh(new THREE.SphereGeometry(2,6,6),new THREE.MeshBasicMaterial({color:g.cat==='Terror'?0x110000:0x000a14,transparent:true,opacity:.3,side:THREE.BackSide}));
    scene.add(glow);
    let t=0;
    function draw(){
      requestAnimationFrame(draw);
      t+=.02;
      body.rotation.y=Math.sin(t)*.3;
      head.rotation.y=Math.sin(t)*.3;
      if(gObj) gObj.rotation.y+=.03;
      renderer.render(scene,cam);
    }
    draw();
  }catch(e){}
}

// ═══════════════════════════════════════
// GAMES PAGE
// ═══════════════════════════════════════
let gameCat='Todos';
function renderGames(){
  const tabs=document.getElementById('game-cat-tabs');
  const cats=['Todos',...new Set(GAMES_DATA.map(g=>g.cat))];
  if(tabs) tabs.innerHTML=cats.map(c=>`<button class="fch${c===gameCat?' on':''}" onclick="filterGames('${c}')">${c}</button>`).join('');
  const grid=document.getElementById('games-grid');
  const fl=gameCat==='Todos'?GAMES_DATA:GAMES_DATA.filter(g=>g.cat===gameCat);
  if(grid) grid.innerHTML=fl.map(g=>gcHTML(g)).join('');
  setTimeout(()=>fl.forEach(g=>{const cv=document.getElementById('gc3d-'+g.id);if(cv&&!cv._init){cv._init=true;renderCardPreview(cv,g);};}),200);
}
function filterGames(cat){
  gameCat=cat;
  goPage('games');
}

// ═══════════════════════════════════════
// GAME MODAL
// ═══════════════════════════════════════
const AI_TIPS={
  football:['Flanquear pelo lado esquerdo cria mais espaço no meio.','Manter a posse é 70% da vitória — não corra atrás da bola.','No modo 3D, use a câmera livre para ver o campo todo.'],
  aimlab:['Mira a nível do pescoço reduce tempo de ajuste em 40%.','Comece devagar e aumente a velocidade gradualmente.','Alvos vermelhos pulsam — é o próximo que vai aparecer.'],
  escape:['Fique longe de cantos escuros — o monstro prefere eles.','Itens brilhantes são sempre coletáveis úteis.','Se ouvir respiração pesada, pare e espere — correr atrai.'],
  pvp:['Nunca ataque em linha reta — sempre diagonal.','O dash te dá 0.3s de invencibilidade.','Mira a cabeça dá dano dobrado no modo FPS.'],
  racing:['Nitro na reta longa, nunca nas curvas.','Bater nas laterais reduz velocidade em 30%.','A primeira curva é onde 60% das colisões ocorrem.'],
  default:['Use o modo 3D para uma experiência mais imersiva!','Escolha Fácil primeiro para conhecer o jogo.','No multiplayer você pode criar uma sala privada com senha.'],
};

function openGM(id){
  // Minecraft goes to its own overlay
  if(id==='minecraft'){ openMC(); return; }
  S.game=GAMES_DATA.find(g=>g.id===id);
  if(!S.game) return;
  document.getElementById('gm-title').textContent=S.game.name+' — Configurar Partida';
  openM('gm-modal');
  // NexusBots extra config
  const nbSec=document.getElementById('nexusbots-sec');
  if(nbSec) nbSec.style.display=(id==='nexusbots')?'':'none';
  // AI tip
  const tips=AI_TIPS[id]||AI_TIPS.default;
  const tip=tips[Math.floor(Math.random()*tips.length)];
  const tipEl=document.getElementById('gm-ai-tip');
  const ty=document.getElementById('gm-typing');
  tipEl.textContent=''; ty.style.display='flex';
  setTimeout(()=>{ty.style.display='none';tipEl.textContent='Dica: '+tip;},1100);
}

function setOpt(btn,type,val){
  const grp=btn.closest('.ogrp');
  if(grp) grp.querySelectorAll('.ob').forEach(b=>{b.classList.remove('sel','sel-g','sel-r','sel-o','sel-p');b.style.borderColor='';b.style.color='';b.style.background='';});
  btn.classList.add('sel');
  S.opts[type]=val;
  if(type==='opp'){
    const ds=document.getElementById('diff-sec');
    const bs=document.getElementById('bot-sec');
    const ls=document.getElementById('lobby-sec');
    if(ds) ds.style.display=val==='solo'?'none':'';
    if(bs) bs.style.display=(val==='bot'||val==='mix')?'':'none';
    if(ls){ls.style.display=(val==='pvp'||val==='mix')?'':'none'; if(ls.style.display!=='none') buildLobby();}
  }
  if(type==='bot-b'){
    const bc=document.getElementById('bot-count');
    if(bc) bc.oninput=()=>document.getElementById('bot-count-lbl').textContent=bc.value+' bot'+(bc.value>1?'s':'')+' por time';
  }
}

function buildLobby(){
  const lg=document.getElementById('lob-grid');
  if(!lg) return;
  const tA=[S.user,rp()]; const tB=[rp(),rp()];
  lg.innerHTML=`
    <div class="lc"><h4>TIME A</h4>
      ${tA.map((p,i)=>`<div class="ps"><div class="pav" style="background:${PCOLORS[i]}">${p[0]}</div><span class="pn">${p}</span><span class="pr">Pronto</span></div>`).join('')}
      <div class="ps"><div class="pav" style="background:rgba(255,255,255,.1)">?</div><span class="pn" style="color:var(--mu)">Aguardando...</span></div>
    </div>
    <div class="lc"><h4>TIME B</h4>
      ${tB.map((p,i)=>`<div class="ps"><div class="pav" style="background:${PCOLORS[i+3]}">${p[0]}</div><span class="pn">${p}</span><span class="${i===0?'pr':'pw'}">${i===0?'Pronto':'Aguardando'}</span></div>`).join('')}
    </div>`;
}

// ═══════════════════════════════════════
// CHARACTER SELECT
// ═══════════════════════════════════════
let csTimer=null, selectedChar=0;
function goCharSelect(){
  closeM('gm-modal');
  document.getElementById('char-select').style.display='flex';
  const grid=document.getElementById('cs-grid');
  grid.innerHTML=CHARS.map((c,i)=>`
    <div class="cs-card${i===0?' sel':''}" onclick="selChar(${i})" id="csc-${i}">
      <canvas id="csc3d-${i}" style="width:100px;height:120px;display:block"></canvas>
      <div class="cs-name">${c.name}</div>
      <div class="cs-type">${c.type}</div>
      <div class="cs-stat-row"><span>SPD</span><span>${c.spd}</span></div>
      <div class="cs-bar-wrap"><div class="cs-bar" style="width:${c.spd}%"></div></div>
      <div class="cs-stat-row"><span>STR</span><span>${c.str}</span></div>
      <div class="cs-bar-wrap"><div class="cs-bar" style="width:${c.str}%;background:var(--o)"></div></div>
      <div style="font-size:.62rem;color:var(--mu);text-align:center;margin-top:3px">${c.special}</div>
    </div>`).join('');
  // Render 3D characters
  setTimeout(()=>CHARS.forEach((c,i)=>render3DChar(i,c)),100);
  // Timer
  let t=10;
  document.getElementById('cs-timer-val').textContent=t;
  document.getElementById('cs-timer-fill').style.width='100%';
  csTimer=setInterval(()=>{
    t--;
    document.getElementById('cs-timer-val').textContent=t;
    document.getElementById('cs-timer-fill').style.width=(t/10*100)+'%';
    if(t<=0){clearInterval(csTimer);confirmChar();}
  },1000);
}

function render3DChar(i,c){
  const cv=document.getElementById('csc3d-'+i);
  if(!cv) return;
  cv.width=100; cv.height=120;
  try{
    const scene=new THREE.Scene();
    const cam=new THREE.PerspectiveCamera(45,100/120,.1,100);
    cam.position.set(0,1.5,3);
    cam.lookAt(0,.5,0);
    const renderer=new THREE.WebGLRenderer({canvas:cv,antialias:true,alpha:true});
    renderer.setSize(100,120,false);
    renderer.setClearColor(0,0);
    const colors={apex:0x00f5ff,tank:0xff6b00,ghost:0xd500f9,snip:0xffd740,mage:0x00e676,beast:0xff1744};
    const col=colors[c.id]||0x00f5ff;
    // Body torso
    const torso=new THREE.Mesh(new THREE.CylinderGeometry(.18,.22,.6,8),new THREE.MeshBasicMaterial({color:col,wireframe:false}));
    torso.position.y=.3; scene.add(torso);
    // Torso detail
    const chest=new THREE.Mesh(new THREE.BoxGeometry(.28,.25,.15),new THREE.MeshBasicMaterial({color:col,transparent:true,opacity:.8}));
    chest.position.y=.45; scene.add(chest);
    // Head
    const head=new THREE.Mesh(new THREE.SphereGeometry(.15,12,12),new THREE.MeshBasicMaterial({color:0xffcc99}));
    head.position.y=.9; scene.add(head);
    // Hair/helmet
    if(c.id==='snip'){
      const helm=new THREE.Mesh(new THREE.CylinderGeometry(.16,.15,.1,8),new THREE.MeshBasicMaterial({color:0x223344}));
      helm.position.y=1; scene.add(helm);
    }
    if(c.id==='ghost'){
      const hood=new THREE.Mesh(new THREE.ConeGeometry(.17,.15,8),new THREE.MeshBasicMaterial({color:0x221133,transparent:true,opacity:.8}));
      hood.position.y=1.05; scene.add(hood);
    }
    // Eyes
    const eyeM=new THREE.MeshBasicMaterial({color:col});
    const le=new THREE.Mesh(new THREE.SphereGeometry(.025,6,6),eyeM); le.position.set(-.05,.92,.13); scene.add(le);
    const re=new THREE.Mesh(new THREE.SphereGeometry(.025,6,6),eyeM); re.position.set(.05,.92,.13); scene.add(re);
    // Arms
    const armM=new THREE.MeshBasicMaterial({color:col,transparent:true,opacity:.85});
    const armG=new THREE.CylinderGeometry(.055,.065,.42,7);
    const la=new THREE.Mesh(armG,armM); la.position.set(-.28,.35,0); la.rotation.z=.3; scene.add(la);
    const ra=new THREE.Mesh(armG,armM); ra.position.set(.28,.35,0); ra.rotation.z=-.3; scene.add(ra);
    // Hands
    const hndM=new THREE.MeshBasicMaterial({color:0xffaa88});
    const lh=new THREE.Mesh(new THREE.SphereGeometry(.055,6,6),hndM); lh.position.set(-.33,.14,0); scene.add(lh);
    const rh=new THREE.Mesh(new THREE.SphereGeometry(.055,6,6),hndM); rh.position.set(.33,.14,0); scene.add(rh);
    // Legs
    const legM=new THREE.MeshBasicMaterial({color:col,transparent:true,opacity:.7});
    const legG=new THREE.CylinderGeometry(.07,.065,.45,7);
    const ll=new THREE.Mesh(legG,legM); ll.position.set(-.1,-.25,0); scene.add(ll);
    const rl=new THREE.Mesh(legG,legM); rl.position.set(.1,-.25,0); scene.add(rl);
    // Feet
    const ftM=new THREE.MeshBasicMaterial({color:0x111111});
    const lf=new THREE.Mesh(new THREE.BoxGeometry(.1,.06,.16),ftM); lf.position.set(-.1,-.49,.03); scene.add(lf);
    const rf=new THREE.Mesh(new THREE.BoxGeometry(.1,.06,.16),ftM); rf.position.set(.1,-.49,.03); scene.add(rf);
    // Weapon/special
    if(c.id==='snip'){
      const gun=new THREE.Mesh(new THREE.BoxGeometry(.04,.04,.4),new THREE.MeshBasicMaterial({color:0x333344}));
      gun.position.set(.3,.4,.2); scene.add(gun);
    }
    // Special glow
    const glow=new THREE.Mesh(new THREE.SphereGeometry(.8,6,6),new THREE.MeshBasicMaterial({color:col,transparent:true,opacity:.04,side:THREE.BackSide}));
    scene.add(glow);
    let t=0;
    function draw(){
      requestAnimationFrame(draw);
      t+=.025;
      torso.rotation.y=Math.sin(t)*.15;
      head.rotation.y=Math.sin(t)*.15;
      chest.rotation.y=Math.sin(t)*.15;
      la.rotation.z=.3+Math.sin(t)*.1;
      ra.rotation.z=-.3-Math.sin(t)*.1;
      ll.rotation.x=Math.sin(t)*.15;
      rl.rotation.x=-Math.sin(t)*.15;
      renderer.render(scene,cam);
    }
    draw();
  }catch(e){}
}

function selChar(i){
  document.querySelectorAll('.cs-card').forEach(c=>c.classList.remove('sel'));
  document.getElementById('csc-'+i)?.classList.add('sel');
  selectedChar=i;
}

function confirmChar(){
  clearInterval(csTimer);
  S.char=CHARS[selectedChar];
  document.getElementById('char-select').style.display='none';
  toast(`Personagem ${S.char.name} selecionado!`, 'ok');
  startGame3D();
}

// ═══════════════════════════════════════
// 3D GAME ENGINE
// ═══════════════════════════════════════
let scene3d,cam3d,ren3d,plock=false,pX=0,pY=0;
let player3d={x:0,y:0,z:0,vx:0,vz:0,vy:0,onGround:true,yaw:0,pitch:0,hp:100};
let ball3d={x:3,y:.3,z:0,vx:0,vy:0,vz:0};
let bots3d=[], targets3d=[], bullets3d=[], particles3d=[];
let keys3d={}, mouseDX=0, mouseDY=0;
let gameTime=300, scoreL=0, scoreR=0, kills=0, ammo=30;
let botMeshes=[], ballMesh, playerMesh, groundMesh;

function startGame3D(){
  document.getElementById('game3d').classList.add('on');
  document.getElementById('hud').classList.add('on');
  const g=S.game||GAMES_DATA[0];
  document.getElementById('hud-title').textContent=g.name.toUpperCase();
  const modeStr=S.opts.diff==='ultra'?'ULTRA INSANO':S.opts.diff==='insane'?'INSANO':S.opts.diff==='hard'?'DIFÍCIL':S.opts.diff==='med'?'MÉDIO':'FÁCIL';
  document.getElementById('hud-mode').textContent=modeStr+' — '+(S.opts.opp==='bot'?'BOT':'MULTI');
  const _cx=document.getElementById('hud-cross');
  if(_cx){
    const _sport=(g.id==='football'||g.id==='basketball');
    _cx.style.display=(g.id==='aimlab'||g.id==='pvp'||g.id==='nexusbots'||_sport)?'block':'none';
    if(_sport) _cx.classList.add('sport-aim'); else _cx.classList.remove('sport-aim');
  }
  gameTime=parseInt(S.opts.dur)*60; scoreL=0; scoreR=0; kills=0; ammo=30;
  S.running=true; S.paused=false; S.hp=100;
  // Reset per-game state
  ballHeld=false; kickCharging=false; kickPower=0; hackerEventDone=false; S.chessMode=false;
  const dcOv=document.getElementById('dreamcore-overlay');
  if(dcOv){dcOv.classList.remove('on');dcOv.style.filter='';const kb=document.getElementById('dc-kick-banner');if(kb)kb.classList.remove('on');}
  const nickL=document.getElementById('nick-layer'); if(nickL) nickL.innerHTML='';
  const hud2=document.getElementById('hud'); if(hud2) hud2.style.filter='';
  const bhi=document.getElementById('ball-held-ind'); if(bhi) bhi.style.display='none';
  updateHUD();
  initScene3D(g);
  // Pointer lock
  const cv=document.getElementById('c3d');
  cv.addEventListener('click',()=>{if(document.pointerLockElement!==cv) cv.requestPointerLock();});
  document.addEventListener('pointerlockchange',()=>{
    plock=document.pointerLockElement===cv;
    document.getElementById('exit-hint').textContent=plock?'ESC = soltar mouse | Tab = chat | F = ação/pegar':'Clique no jogo para ativar o mouse';
  });
  document.addEventListener('mousemove',onMM);
  document.addEventListener('keydown',onKD);
  document.addEventListener('keyup',onKU);
  document.addEventListener('mousedown',onMD);
  // Timer (1 second ticks just for countdown)
  clearInterval(gTimer);
  gTimer=setInterval(()=>{
    if(S.paused||!S.running) return;
    gameTime--;
    updateHUD();
    if(gameTime<=0) endGame3D();
  },1000);
  // Add initial chat
  addHudChat('Sistema','Partida iniciada! WASD = mover | Mouse = câmera | F = ação/pegar bola | SPACE = pular','sys');
  if(g.id==='basketball') setTimeout(()=>addHudChat('Sistema','Basquete: chegue perto da bola para pegar. F = arremessar na cesta!','sys'),2500);
  if(g.id==='football') setTimeout(()=>addHudChat('Sistema','Futebol: F ou SPACE perto da bola = domínio/chute. Marque na trave adversária!','sys'),2500);
  if(g.id==='dreamcore') setTimeout(()=>addHudChat('Sistema','DreamCore: colete os cubos dourados. Algo estranho pode acontecer...','sys'),2500);
  if(S.opts.opp!=='bot') setTimeout(()=>addHudChat(rp(),'pronto para ganhar hehe','o'),2000);
  if(S.opts.opp!=='bot') startFakeHudChat();
  // Schedule hacker event for multiplayer OR DreamCore
  if(S.opts.opp!=='bot'||g.id==='dreamcore'){
    hackerEventDone=false;
    scheduleHackerEvent();
  }
}

function onKD(e){
  keys3d[e.code]=true;
  if(e.code==='Tab'){e.preventDefault();toggleHudChat();}
  if(e.code==='Escape'&&plock) document.exitPointerLock();
  if(e.code==='Space') e.preventDefault();
  if(e.code==='KeyR'&&(S.game?.id==='pvp'||S.game?.id==='aimlab')){ammo=30;document.getElementById('hud-ammo').textContent='AMMO: 30';}
}
function onKU(e){
  keys3d[e.code]=false;
  // Release kick on F key up — call releaseKick first (it resets all flags internally)
  if(e.code==='KeyF'&&kickCharging&&ballHeld){
    releaseKick();
  }
}
function onMD(e){
  if(e.button!==0||!plock) return;
  if(S.chessMode) chessClick();
  else shoot3d();
}

function onMM(e){
  if(!plock) return;
  player3d.yaw-=e.movementX*.002;
  player3d.pitch-=e.movementY*.002;
  player3d.pitch=Math.max(-1.2,Math.min(.5,player3d.pitch));
}

function initScene3D(g){
  scene3d=new THREE.Scene();
  const cv=document.getElementById('c3d');
  cv.width=window.innerWidth; cv.height=window.innerHeight;
  cam3d=new THREE.PerspectiveCamera(75,cv.width/cv.height,.05,500);
  ren3d=new THREE.WebGLRenderer({canvas:cv,antialias:true});
  ren3d.setSize(cv.width,cv.height);
  ren3d.shadowMap.enabled=true;
  ren3d.shadowMap.type=THREE.PCFSoftShadowMap;
  window.addEventListener('resize',()=>{
    if(!ren3d) return;
    cv.width=window.innerWidth; cv.height=window.innerHeight;
    cam3d.aspect=cv.width/cv.height; cam3d.updateProjectionMatrix();
    ren3d.setSize(cv.width,cv.height);
  });
  // Scene setup based on game
  if(g.cat==='Terror'||g.id==='escape'||g.id==='labyrinth'||g.id==='horror-coop'){
    buildHorrorScene();
  } else if(g.id==='aimlab'){
    buildAimLabScene();
  } else if(g.id==='football'||g.id==='basketball'){
    buildSportScene(g.id);
  } else if(g.id==='pvp'||g.id==='ctf'){
    buildPVPScene();
  } else if(g.id==='racing'){
    buildRaceSceneExpanded();
  } else if(g.id==='dreamcore'){
    buildDreamCoreScene();
  } else if(g.id==='parkour'){
    buildParkourScene();
  } else if(g.id==='survival'){
    buildSurvivalScene();
  } else if(g.id==='adventure'){
    buildAdventureScene();
  } else if(g.id==='volleyball'){
    buildVolleyballScene();
  } else if(g.id==='tennis'){
    buildTennisScene();
  } else if(g.id==='boxing'){
    buildBoxingScene();
  } else if(g.id==='archery'){
    buildArcheryScene();
  } else if(g.id==='chess'){
    buildChessScene();
  } else if(g.id==='swimming'){
    buildSwimmingScene();
  } else if(g.id==='cycling'){
    buildCyclingScene();
  } else if(g.id==='skiing'){
    buildSkiingScene();
  } else if(g.id==='dance'){
    buildDanceScene();
  } else if(g.id==='nexusbots'){
    buildNexusBotsScene();
  } else if(g.id==='battleroyale'){
    buildBattleRoyaleScene();
  } else if(g.id==='aimlabpvp'){
    buildAimlabPvpScene();
  } else {
    buildDefaultScene(g);
  }
  cancelAnimationFrame(raf);
  // Build visible player mesh for 3rd-person games
  buildPlayerMesh3D(g);
  raf=requestAnimationFrame(loop3d);
}

function buildDefaultScene(g){
  scene3d.background=new THREE.Color(0x001122);
  scene3d.fog=new THREE.Fog(0x001122,15,80);
  addLights(0x334466,0.8);
  buildArena(g.cat==='Esportes'?0x003311:0x001122,0x005533);
  spawnBots3D(3);
  player3d={x:0,y:1,z:5,vx:0,vz:0,vy:0,onGround:true,yaw:0,pitch:0};
}

function buildParkourScene(){
  scene3d.background=new THREE.Color(0x050510);
  scene3d.fog=new THREE.Fog(0x050510,20,120);
  addLights(0x222244,1.0);
  // Neon grid floor far below
  const floor=new THREE.Mesh(new THREE.PlaneGeometry(200,200),new THREE.MeshStandardMaterial({color:0x000008,roughness:1}));
  floor.rotation.x=-Math.PI/2; floor.position.y=-20; scene3d.add(floor);
  const gh=new THREE.GridHelper(200,100,0x002244,0x001133); gh.position.y=-19.9; scene3d.add(gh);
  // Neon platform colors
  const platColors=[0x00f5ff,0xff6b00,0xd500f9,0x00e676,0xffd740,0xff1744];
  // Generate parkour course — ascending platforms with gaps
  const platforms=[];
  let px=0,py=0,pz=0;
  for(let i=0;i<28;i++){
    const w=Math.random()*2+1.5, d=Math.random()*2+1.5;
    const col=platColors[i%platColors.length];
    const mat=new THREE.MeshStandardMaterial({color:col,emissive:new THREE.Color(col),emissiveIntensity:.15,roughness:.4,metalness:.3});
    const plat=new THREE.Mesh(new THREE.BoxGeometry(w,.25,d),mat);
    plat.position.set(px,py,pz); plat.castShadow=true; plat.receiveShadow=true;
    scene3d.add(plat);
    // Neon edge glow
    const edge=new THREE.LineSegments(new THREE.EdgesGeometry(plat.geometry),new THREE.LineBasicMaterial({color:col,transparent:true,opacity:.6}));
    edge.position.copy(plat.position); scene3d.add(edge);
    // Point light under each plat
    const pl=new THREE.PointLight(col,.8,4); pl.position.set(px,py-.3,pz); scene3d.add(pl);
    platforms.push({x:px,y:py,z:pz,w,d});
    // Move to next platform with gap
    const dir=Math.random()>.5?1:-1;
    px+=(1.5+Math.random()*2.5)*(Math.random()>.3?1:-1);
    pz-=(2.5+Math.random()*2);
    py+=(Math.random()*1.2)-.2;
    if(i%5===0) py+=1.5; // step up sections
  }
  // Finish platform — gold
  const finMat=new THREE.MeshStandardMaterial({color:0xffd740,emissive:0xffd740,emissiveIntensity:.5});
  const fin=new THREE.Mesh(new THREE.BoxGeometry(4,.25,4),finMat);
  fin.position.set(px,py,pz-3); scene3d.add(fin);
  const finLight=new THREE.PointLight(0xffd740,3,10); finLight.position.set(px,py+2,pz-3); scene3d.add(finLight);
  // Store platforms for collision
  scene3d.userData.platforms=platforms.map(p=>({...p}));
  scene3d.userData.finishX=px; scene3d.userData.finishZ=pz-3; scene3d.userData.finishY=py;
  // Spawn bots running the course
  spawnParkourBots(platforms);
  player3d={x:platforms[0].x,y:platforms[0].y+1.5,z:platforms[0].z,vx:0,vz:0,vy:0,onGround:false,yaw:Math.PI,pitch:0};
}

function spawnParkourBots(platforms){
  bots3d=[]; botMeshes.forEach(m=>scene3d.remove(m)); botMeshes=[];
  const n=S.opts.diff==='ultra'?3:S.opts.diff==='hard'?2:1;
  const botColor=new THREE.Color(0xff6b00);
  const spd=S.opts.diff==='ultra'?.12:S.opts.diff==='hard'?.09:.06;
  for(let b=0;b<n;b++){
    const g=new THREE.Group();
    const body=new THREE.Mesh(new THREE.CylinderGeometry(.15,.17,.5,8),new THREE.MeshStandardMaterial({color:botColor,roughness:.5}));
    body.position.y=.85; g.add(body);
    const head=new THREE.Mesh(new THREE.SphereGeometry(.13,8,8),new THREE.MeshStandardMaterial({color:0xffbb88}));
    head.position.y=1.4; g.add(head);
    g.position.set(platforms[0].x+(b*.5),platforms[0].y+1,platforms[0].z);
    const bot={x:platforms[0].x+(b*.5),y:platforms[0].y+1,z:platforms[0].z,vx:0,vz:0,vy:0,hp:100,spd,team:0,walkT:b*1.5,group:g,isParkourBot:true,platIdx:0,platforms};
    scene3d.add(g); botMeshes.push(g); bots3d.push(bot);
  }
}

function buildSurvivalScene(){
  scene3d.background=new THREE.Color(0x050008);
  scene3d.fog=new THREE.FogExp2(0x050008,.04);
  scene3d.add(new THREE.AmbientLight(0x110022,.4));
  const dl=new THREE.DirectionalLight(0x6633aa,.6); dl.position.set(5,15,5); dl.castShadow=true; scene3d.add(dl);
  // Dark arena floor
  const fl=new THREE.Mesh(new THREE.PlaneGeometry(60,60),new THREE.MeshStandardMaterial({color:0x080010,roughness:1}));
  fl.rotation.x=-Math.PI/2; fl.receiveShadow=true; scene3d.add(fl); groundMesh=fl;
  const gh=new THREE.GridHelper(60,30,0x220033,0x110022); scene3d.add(gh);
  // Hexagonal arena walls with openings
  for(let i=0;i<6;i++){
    const angle=i*(Math.PI/3);
    const wall=new THREE.Mesh(new THREE.BoxGeometry(10,.1,4),new THREE.MeshStandardMaterial({color:0x330044,emissive:0x110022,roughness:.8}));
    wall.position.set(Math.cos(angle)*22,2,Math.sin(angle)*22);
    wall.rotation.y=-angle; wall.scale.y=40; wall.castShadow=true; scene3d.add(wall);
  }
  // Scatter obstacles/cover
  for(let i=0;i<14;i++){
    const h=Math.random()*1.5+.5;
    const cov=new THREE.Mesh(new THREE.BoxGeometry(Math.random()+.8,h,Math.random()+.8),new THREE.MeshStandardMaterial({color:0x220033,roughness:.8}));
    const a=Math.random()*Math.PI*2, r=Math.random()*14+3;
    cov.position.set(Math.cos(a)*r,h/2,Math.sin(a)*r); cov.castShadow=true; cov.receiveShadow=true; scene3d.add(cov);
  }
  // Pulsing center light
  const pl=new THREE.PointLight(0xd500f9,3,25); pl.position.set(0,3,0); scene3d.add(pl); pl.userData.isPulse=true;
  // Spawn wave of enemies
  S.survivalWave=1; S.survivalKills=0;
  spawnSurvivalWave(1);
  player3d={x:0,y:1,z:0,vx:0,vz:0,vy:0,onGround:true,yaw:0,pitch:0};
  document.getElementById('hud-ammo').textContent='AMMO: 30';
  document.getElementById('hud-kills').textContent='WAVE: 1';
  addHudChat('Sistema','Survival Mode! Elimine todos para avançar de onda!','sys');
}

function spawnSurvivalWave(wave){
  bots3d.forEach(b=>{if(b.group)scene3d.remove(b.group);}); bots3d=[]; botMeshes=[];
  const count=wave*2+1;
  const spd=.02+wave*.01+(S.opts.diff==='ultra'?.08:S.opts.diff==='hard'?.04:0);
  const colors=[0xff1744,0xd500f9,0xff6b00,0x00e676];
  for(let i=0;i<count;i++){
    const angle=Math.random()*Math.PI*2;
    const r=15+Math.random()*8;
    const g=new THREE.Group();
    const col=new THREE.Color(colors[i%colors.length]);
    const body=new THREE.Mesh(new THREE.CylinderGeometry(.2,.22,.8,8),new THREE.MeshStandardMaterial({color:col,emissive:col,emissiveIntensity:.2}));
    body.position.y=.9; g.add(body);
    const head=new THREE.Mesh(new THREE.SphereGeometry(.18,8,8),new THREE.MeshStandardMaterial({color:col}));
    head.position.y=1.55; g.add(head);
    // Glowing eyes
    const eyeM=new THREE.MeshBasicMaterial({color:0xffffff});
    const le=new THREE.Mesh(new THREE.SphereGeometry(.04,5,5),eyeM); le.position.set(-.07,1.58,.15); g.add(le);
    const re=new THREE.Mesh(new THREE.SphereGeometry(.04,5,5),eyeM); re.position.set(.07,1.58,.15); g.add(re);
    // Arms
    const armM=new THREE.MeshStandardMaterial({color:col});
    const laG=new THREE.Group(); laG.position.set(-.28,1.0,0);
    laG.add(new THREE.Mesh(new THREE.CylinderGeometry(.06,.07,.4,7),armM));
    g.add(laG);
    const raG=new THREE.Group(); raG.position.set(.28,1.0,0);
    raG.add(new THREE.Mesh(new THREE.CylinderGeometry(.06,.07,.4,7),armM));
    g.add(raG);
    // Legs
    const legM=new THREE.MeshStandardMaterial({color:new THREE.Color(col).multiplyScalar(.6)});
    const llG=new THREE.Group(); llG.position.set(-.1,.75,0);
    llG.add(new THREE.Mesh(new THREE.CylinderGeometry(.065,.06,.42,7),legM));
    g.add(llG);
    const rlG=new THREE.Group(); rlG.position.set(.1,.75,0);
    rlG.add(new THREE.Mesh(new THREE.CylinderGeometry(.065,.06,.42,7),legM));
    g.add(rlG);
    // Point light on enemy
    const eLight=new THREE.PointLight(col,.8,3); eLight.position.y=1; g.add(eLight);
    g.position.set(Math.cos(angle)*r,.3,Math.sin(angle)*r);
    const bot={x:Math.cos(angle)*r,y:.3,z:Math.sin(angle)*r,vx:0,vz:0,hp:60+wave*20,spd,team:0,walkT:Math.random()*Math.PI*2,group:g,laG,raG,llG,rlG,shootCd:60+Math.floor(Math.random()*60),isSurvivalEnemy:true};
    scene3d.add(g); botMeshes.push(g); bots3d.push(bot);
  }
  document.getElementById('hud-kills').textContent=`WAVE: ${wave} | ${count} inimigos`;
  addHudChat('Sistema',`Onda ${wave}! ${count} inimigos chegando!`,'sys');
}

function buildAdventureScene(){
  scene3d.background=new THREE.Color(0x050e1a);
  scene3d.fog=new THREE.Fog(0x050e1a,20,100);
  addLights(0x113322,1.1);
  // Ground
  const fl=new THREE.Mesh(new THREE.PlaneGeometry(80,80),new THREE.MeshStandardMaterial({color:0x0a2210,roughness:.9}));
  fl.rotation.x=-Math.PI/2; fl.receiveShadow=true; scene3d.add(fl); groundMesh=fl;
  // Trees
  for(let i=0;i<20;i++){
    const a=Math.random()*Math.PI*2, r=10+Math.random()*25;
    const trunk=new THREE.Mesh(new THREE.CylinderGeometry(.2,.3,Math.random()*2+2,6),new THREE.MeshStandardMaterial({color:0x3a1f00,roughness:1}));
    trunk.position.set(Math.cos(a)*r,trunk.geometry.parameters.height/2,Math.sin(a)*r); trunk.castShadow=true; scene3d.add(trunk);
    const leaves=new THREE.Mesh(new THREE.SphereGeometry(Math.random()+.8,7,7),new THREE.MeshStandardMaterial({color:0x1a4a10,roughness:.9}));
    leaves.position.set(Math.cos(a)*r,trunk.position.y+trunk.geometry.parameters.height*.6,Math.sin(a)*r); leaves.castShadow=true; scene3d.add(leaves);
  }
  // Ruins/structures
  for(let i=0;i<6;i++){
    const a=Math.random()*Math.PI*2, r=6+Math.random()*15;
    const ruin=new THREE.Mesh(new THREE.BoxGeometry(Math.random()*2+.5,Math.random()*3+.5,Math.random()*2+.5),new THREE.MeshStandardMaterial({color:0x443322,roughness:1}));
    ruin.position.set(Math.cos(a)*r,ruin.geometry.parameters.height/2,Math.sin(a)*r); ruin.castShadow=true; scene3d.add(ruin);
  }
  // Collectible items (glowing)
  S.adventureItems=[];
  for(let i=0;i<8;i++){
    const a=Math.random()*Math.PI*2, r=4+Math.random()*20;
    const item=new THREE.Mesh(new THREE.OctahedronGeometry(.25,0),new THREE.MeshStandardMaterial({color:0xffd740,emissive:0xffd740,emissiveIntensity:.8}));
    item.position.set(Math.cos(a)*r,.5+Math.sin(Date.now())*.1,Math.sin(a)*r);
    item.userData={isItem:true,collected:false};
    const il=new THREE.PointLight(0xffd740,1.5,3); il.position.copy(item.position); scene3d.add(il);
    scene3d.add(item); S.adventureItems.push({mesh:item,light:il,collected:false});
  }
  // NPCs
  spawnBots3D(S.opts.diff==='ultra'?5:S.opts.diff==='hard'?3:2);
  player3d={x:0,y:1,z:0,vx:0,vz:0,vy:0,onGround:true,yaw:0,pitch:0};
  addHudChat('Sistema','Modo Aventura! Explore e colete os 8 itens dourados. F para coletar.','sys');
  document.getElementById('hud-kills').textContent='ITENS: 0/8';
}

function buildSportScene(type){
  const isBasket=type==='basketball';
  scene3d.background=new THREE.Color(isBasket?0x0a0400:0x000d00);
  scene3d.fog=new THREE.Fog(isBasket?0x0a0400:0x000d00,50,200);
  scene3d.add(new THREE.AmbientLight(0xffffff,0.9));
  const sun=new THREE.DirectionalLight(0xfffff0,1.2);
  sun.position.set(20,40,10); sun.castShadow=true;
  sun.shadow.mapSize.width=2048; sun.shadow.mapSize.height=2048;
  scene3d.add(sun);

  const FW=80, FD=50; // bigger field
  // Ground
  const fg=new THREE.Mesh(new THREE.PlaneGeometry(FW,FD),
    new THREE.MeshStandardMaterial({color:isBasket?0x4a2800:0x005500,roughness:.9}));
  fg.rotation.x=-Math.PI/2; fg.receiveShadow=true; scene3d.add(fg); groundMesh=fg;

  // Field markings
  const lm=new THREE.LineBasicMaterial({color:0xffffff,transparent:true,opacity:.55});
  // Outer boundary
  [[0,0,FW-2,.1],[0,0,.1,FD-2],[-(FW/2)+1,0,FW-2,.1],[0,-(FD/2)+1,.1,FD-2]].forEach(([x,z,w,d])=>{
    const seg=new THREE.Line(new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(x,0.01,z-d/2),new THREE.Vector3(x,0.01,z+d/2)]),lm);
    scene3d.add(seg);
  });
  // Center line
  const cl=new THREE.Mesh(new THREE.PlaneGeometry(.12,FD),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.4}));
  cl.rotation.x=-Math.PI/2; cl.position.y=.01; scene3d.add(cl);
  // Center circle
  const cc=new THREE.Mesh(new THREE.RingGeometry(5.8,6,32),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.4,side:THREE.DoubleSide}));
  cc.rotation.x=-Math.PI/2; cc.position.y=.01; scene3d.add(cc);
  // Penalty areas
  if(!isBasket){
    [[-36,0,16,20],[36,0,16,20]].forEach(([x,z,w,d])=>{
      const pa=new THREE.Mesh(new THREE.PlaneGeometry(w,d),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.15,side:THREE.DoubleSide,wireframe:true}));
      pa.rotation.x=-Math.PI/2; pa.position.set(x,.01,z); scene3d.add(pa);
    });
  }

  // Goals/hoops
  if(!isBasket){
    addGoal(-38,0); addGoal(38,0,true);
  } else {
    addHoop(-34,3,0); addHoop(34,3,0,true);
  }

  // Ball — starts centered and STILL
  const bm=new THREE.Mesh(new THREE.SphereGeometry(.35,24,24),
    new THREE.MeshStandardMaterial({color:isBasket?0xff7700:0xeeeeee,roughness:.5,metalness:.1}));
  bm.castShadow=true; scene3d.add(bm); ballMesh=bm;
  ball3d={x:0,y:.35,z:0,vx:0,vy:0,vz:0}; // STARTS STOPPED

  // Stands — 4 sides, with more crowd
  [[0,FD/2+3,FW,4,3],[0,-(FD/2+3),FW,4,3],[FW/2+3,0,4,FD+6,3],[-(FW/2+3),0,4,FD+6,3]].forEach(([x,z,w,d,h])=>{
    const st=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),new THREE.MeshStandardMaterial({color:0x1a1a44,roughness:.9}));
    st.position.set(x,h/2,z); scene3d.add(st);
    const count=Math.floor(w*d/1.5);
    for(let c=0;c<count;c++){
      const cr=new THREE.Mesh(new THREE.SphereGeometry(.2,5,5),
        new THREE.MeshBasicMaterial({color:PCOLORS[Math.floor(Math.random()*PCOLORS.length)]}));
      cr.position.set(x+(Math.random()-.5)*(w-.5),h+Math.random()*.4,z+(Math.random()-.5)*(d-.3));
      scene3d.add(cr);
    }
  });

  // Stadium lights — 4 big towers
  [[-35,-22],[-35,22],[35,-22],[35,22]].forEach(([lx,lz])=>{
    const pole=new THREE.Mesh(new THREE.CylinderGeometry(.15,.2,15,6),
      new THREE.MeshStandardMaterial({color:0x888888,metalness:.6}));
    pole.position.set(lx,7.5,lz); scene3d.add(pole);
    const arm=new THREE.Mesh(new THREE.BoxGeometry(3,.2,.2),
      new THREE.MeshStandardMaterial({color:0x888888,metalness:.6}));
    arm.position.set(lx,15,lz); scene3d.add(arm);
    const light=new THREE.SpotLight(0xffffcc,3,120,Math.PI/5,.5);
    light.position.set(lx,15,lz); light.target.position.set(0,0,0);
    scene3d.add(light); scene3d.add(light.target);
  });

  const botCount=S.opts.diff==='ultra'?10:S.opts.diff==='insane'?7:S.opts.diff==='hard'?5:3;
  spawnBots3D(botCount);
  player3d={x:0,y:1.5,z:18,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  ballCooldown=0;
}

function addGoal(x,z,flip){
  const gm=new THREE.MeshStandardMaterial({color:0xdddddd,roughness:.3,metalness:.8});
  const h=3.5, w=7;
  const post1=new THREE.Mesh(new THREE.CylinderGeometry(.1,.1,h,8),gm);
  post1.position.set(x,h/2,z+w/2); scene3d.add(post1);
  const post2=new THREE.Mesh(new THREE.CylinderGeometry(.1,.1,h,8),gm);
  post2.position.set(x,h/2,z-w/2); scene3d.add(post2);
  const bar=new THREE.Mesh(new THREE.CylinderGeometry(.08,.08,w,8),gm);
  bar.rotation.z=Math.PI/2; bar.position.set(x,h,z); scene3d.add(bar);
  // Back post
  const back=new THREE.Mesh(new THREE.CylinderGeometry(.08,.08,h,8),gm);
  back.position.set(x+(flip?-2.5:2.5),h/2,z); scene3d.add(back);
  // Net — multiple planes for depth effect
  const netMat=new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.18,wireframe:true,side:THREE.DoubleSide});
  const netBack=new THREE.Mesh(new THREE.PlaneGeometry(2.5,h),netMat);
  netBack.position.set(x+(flip?-1.25:1.25),h/2,z); netBack.rotation.y=Math.PI/2; scene3d.add(netBack);
  const netTop=new THREE.Mesh(new THREE.PlaneGeometry(2.5,w),netMat);
  netTop.position.set(x+(flip?-.6:.6),h+.1,z); netTop.rotation.x=Math.PI/2; netTop.rotation.y=Math.PI/2; scene3d.add(netTop);
  const netL=new THREE.Mesh(new THREE.PlaneGeometry(h,2.5),netMat);
  netL.position.set(x+(flip?-.6:.6),h/2,z+w/2-.1); scene3d.add(netL);
  const netR=new THREE.Mesh(new THREE.PlaneGeometry(h,2.5),netMat);
  netR.position.set(x+(flip?-.6:.6),h/2,z-w/2+.1); scene3d.add(netR);
  // Goal line glow
  const gline=new THREE.Mesh(new THREE.PlaneGeometry(.2,w),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.5}));
  gline.rotation.x=-Math.PI/2; gline.position.set(x,.01,z); scene3d.add(gline);
}

function addHoop(x,y,z,flip){
  const hm=new THREE.MeshStandardMaterial({color:0xff6600,roughness:.4,metalness:.6});
  const ring=new THREE.Mesh(new THREE.TorusGeometry(.45,.04,8,24),hm);
  ring.rotation.x=Math.PI/2; ring.position.set(x,y+1,z); scene3d.add(ring);
  const board=new THREE.Mesh(new THREE.BoxGeometry(1.8,1.2,.1),new THREE.MeshStandardMaterial({color:0xffffff,transparent:true,opacity:.7}));
  board.position.set(x+(flip?.5:-.5),y+1.6,z); scene3d.add(board);
  const net=new THREE.Mesh(new THREE.CylinderGeometry(.35,.2,.5,12,1,true),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.3,wireframe:true}));
  net.position.set(x,y+.6,z); scene3d.add(net);
}


// ─── CHESS STATE ────────────────────────────────────────────────────
let chessPieces=[], chessSelected=null, chessTurn='white', chessTiles=[];
const PIECE_TYPES=['rook','knight','bishop','queen','king','bishop','knight','rook'];
const PIECE_SYMBOLS={rook:'R',knight:'N',bishop:'B',queen:'Q',king:'K',pawn:'P'};

function buildChessScene(){
  scene3d.background=new THREE.Color(0x080808);
  scene3d.fog=new THREE.Fog(0x080808,30,120);
  addLights(0x221100,1.4);
  chessPieces=[]; chessSelected=null; chessTurn='white'; chessTiles=[];

  // Grand hall floor
  const fl=new THREE.Mesh(new THREE.PlaneGeometry(80,80),
    new THREE.MeshStandardMaterial({color:0x111111,roughness:.2,metalness:.3}));
  fl.rotation.x=-Math.PI/2; fl.receiveShadow=true; scene3d.add(fl); groundMesh=fl;

  // Board tiles — 8x8
  for(let r=0;r<8;r++) for(let c=0;c<8;c++){
    const isLight=(r+c)%2===0;
    const tile=new THREE.Mesh(new THREE.BoxGeometry(1.1,0.12,1.1),
      new THREE.MeshStandardMaterial({
        color:isLight?0xf0d9b5:0x8b4513,
        roughness:.4,metalness:.1
      }));
    tile.position.set(r-3.5, 0.06, c-3.5);
    tile.userData={chessRow:r,chessCol:c,isTile:true};
    scene3d.add(tile); chessTiles.push(tile);
  }
  // Board border
  const border=new THREE.Mesh(new THREE.BoxGeometry(9.5,0.15,9.5),
    new THREE.MeshStandardMaterial({color:0x3d1a00,roughness:.6,metalness:.2}));
  border.position.set(-0.0,0.0,0); scene3d.add(border);

  // Place pieces
  function makePiece(type,color,row,col){
    const isBig=(type==='king'||type==='queen'||type==='rook');
    const h=isBig?0.9:type==='knight'?0.75:0.65;
    const mat=new THREE.MeshStandardMaterial({
      color:color==='white'?0xf5f0e8:0x1a1a2e,
      roughness:.3, metalness:color==='white'?.4:.5,
      emissive:color==='white'?0x111111:0x000011
    });
    const g=new THREE.Group();
    // Body
    const body=new THREE.Mesh(new THREE.CylinderGeometry(.18,.25,h,12),mat);
    body.position.y=h/2; g.add(body);
    // Head (different per type)
    let head;
    if(type==='king'){
      head=new THREE.Mesh(new THREE.BoxGeometry(.22,.22,.22),mat);
      head.position.y=h+.14; g.add(head);
      // Cross
      const cv=new THREE.Mesh(new THREE.BoxGeometry(.06,.22,.06),mat);
      cv.position.y=h+.27; g.add(cv);
    } else if(type==='queen'){
      head=new THREE.Mesh(new THREE.SphereGeometry(.18,10,10),mat);
      head.position.y=h+.12; g.add(head);
    } else if(type==='knight'){
      head=new THREE.Mesh(new THREE.BoxGeometry(.28,.18,.18),mat);
      head.position.set(.06,h+.12,0); g.add(head);
    } else if(type==='bishop'){
      head=new THREE.Mesh(new THREE.SphereGeometry(.12,8,8),mat);
      head.position.y=h+.1; g.add(head);
    } else {
      head=new THREE.Mesh(new THREE.CylinderGeometry(.2,.16,.12,8),mat);
      head.position.y=h+.06; g.add(head);
    }
    g.position.set(row-3.5, 0.18, col-3.5);
    g.castShadow=true;
    g.userData={isPiece:true,type,color,row,col,alive:true,baseY:0.18};
    scene3d.add(g);
    chessPieces.push(g);
    return g;
  }

  // White pieces (row 0-1)
  PIECE_TYPES.forEach((t,i)=>makePiece(t,'white',i,0));
  for(let i=0;i<8;i++) makePiece('pawn','white',i,1);
  // Black pieces (row 7-6)
  PIECE_TYPES.forEach((t,i)=>makePiece(t,'black',i,7));
  for(let i=0;i<8;i++) makePiece('pawn','black',i,6);

  // Hall pillars
  [[-5,-5],[-5,5],[5,-5],[5,5],[[-9,-9],[-9,9],[9,-9],[9,9]]].flat().forEach(pos=>{
    if(!Array.isArray(pos)) return;
    const pillar=new THREE.Mesh(new THREE.CylinderGeometry(.4,.5,8,8),
      new THREE.MeshStandardMaterial({color:0x2a1800,roughness:.7}));
    pillar.position.set(pos[0],4,pos[1]); scene3d.add(pillar);
  });
  for(let i=0;i<4;i++){
    const x=[-8,8,-8,8][i], z=[-8,-8,8,8][i];
    const pillar=new THREE.Mesh(new THREE.CylinderGeometry(.4,.5,8,8),
      new THREE.MeshStandardMaterial({color:0x2a1800,roughness:.7}));
    pillar.position.set(x,4,z); scene3d.add(pillar);
    const torch=new THREE.PointLight(0xff8800,3,12);
    torch.position.set(x,6.5,z); scene3d.add(torch);
  }
  // Ambient dramatic light
  const sl=new THREE.SpotLight(0xfff5dd,4,25,Math.PI/5,.4);
  sl.position.set(0,15,0); scene3d.add(sl);

  // Camera: top-down isometric view for chess
  player3d={x:0,y:12,z:0,vx:0,vz:0,vy:0,onGround:true,yaw:0,pitch:-Math.PI/2+0.1};
  addHudChat('Sistema','♟ XADREZ 3D — Clique numa peça branca para selecionar, clique no destino para mover!','sys');
  addHudChat('Sistema','Use WASD para orbitar o tabuleiro. É a vez das brancas.','sys');
  document.getElementById('hud-cross').style.display='block';
  // Override click for chess
  S.chessMode=true;
}

function chessClick(){
  if(!S.chessMode||!scene3d||!cam3d) return;
  // Raycast from camera center
  const raycaster=new THREE.Raycaster();
  raycaster.setFromCamera(new THREE.Vector2(0,0),cam3d);
  // Check pieces first
  const pieceObjs=[];
  chessPieces.forEach(p=>{if(p.userData.alive) p.traverse(c=>{if(c.isMesh) pieceObjs.push(c);});});
  const pHits=raycaster.intersectObjects(pieceObjs,false);
  if(pHits.length>0){
    // Find piece group
    let obj=pHits[0].object;
    while(obj.parent&&!obj.userData.isPiece) obj=obj.parent;
    if(obj.userData.isPiece){
      if(obj.userData.color===chessTurn){
        // Select this piece
        if(chessSelected) chessSelected.children.forEach(c=>{if(c.isMesh)c.material.emissive?.setHex(0);});
        chessSelected=obj;
        chessSelected.children.forEach(c=>{if(c.isMesh&&c.material.emissive) c.material.emissive.setHex(chessTurn==='white'?0x003300:0x330000);});
        addHudChat('Sistema',`♟ ${obj.userData.type.toUpperCase()} selecionado! Clique no destino.`,'sys');
        playSound('click');
      } else if(chessSelected&&obj.userData.color!==chessTurn){
        // Capture!
        chessCapture(chessSelected, obj);
      }
      return;
    }
  }
  // Check tile clicks for moving
  if(chessSelected){
    const tHits=raycaster.intersectObjects(chessTiles,false);
    if(tHits.length>0){
      const tile=tHits[0].object;
      const {chessRow:tr,chessCol:tc}=tile.userData;
      chessMovePiece(chessSelected, tr, tc);
    }
  }
}

function chessMovePiece(piece, toRow, toCol){
  // Check if destination occupied by same color
  const occupant=chessPieces.find(p=>p.userData.alive&&p.userData.row===toRow&&p.userData.col===toCol&&p!==piece);
  if(occupant&&occupant.userData.color===piece.userData.color){
    addHudChat('Sistema','Casa ocupada!','sys'); return;
  }
  if(occupant) chessCapture(piece, occupant, false);
  piece.userData.row=toRow; piece.userData.col=toCol;
  piece.position.set(toRow-3.5,0.18,toCol-3.5);
  // Lift animation
  piece.position.y=0.7;
  setTimeout(()=>{if(piece.userData.alive) piece.position.y=0.18;},200);
  chessSelected.children.forEach(c=>{if(c.isMesh&&c.material.emissive) c.material.emissive.setHex(0);});
  chessSelected=null;
  chessTurn=chessTurn==='white'?'black':'white';
  addHudChat('Sistema',`Movimento! Vez das ${chessTurn==='white'?'BRANCAS':'PRETAS'}.`,'sys');
  playSound('nav');
  // Simple AI response for black
  if(chessTurn==='black') setTimeout(chessAIMove, 800);
}

function chessCapture(attacker, target, move=true){
  scene3d.remove(target);
  const ti=chessPieces.indexOf(target); if(ti>-1) chessPieces.splice(ti,1);
  target.userData.alive=false;
  addHudChat('Sistema',`💥 ${attacker.userData.type} capturou ${target.userData.type}!`,'sys');
  spawnHitParticles(target.position.x,0.5,target.position.z);
  if(target.userData.type==='king'){
    showScorePopup(attacker.userData.color==='white'?'BRANCAS VENCEM! ♔':'PRETAS VENCEM! ♚');
    setTimeout(endGame3D,2000);
  }
  if(move) chessMovePiece(attacker, target.userData.row, target.userData.col);
}

function chessAIMove(){
  if(!S.running||chessTurn!=='black') return;
  const blackPieces=chessPieces.filter(p=>p.userData.alive&&p.userData.color==='black');
  if(!blackPieces.length) return;
  // Pick random piece and random valid destination
  const piece=blackPieces[Math.floor(Math.random()*blackPieces.length)];
  const dr=(Math.random()<0.5?-1:1)*Math.floor(Math.random()*2+1);
  const dc=-Math.floor(Math.random()*2+1); // black moves toward row 0
  const nr=Math.max(0,Math.min(7,piece.userData.row+dr));
  const nc=Math.max(0,Math.min(7,piece.userData.col+dc));
  const occupant=chessPieces.find(p=>p.userData.alive&&p.userData.row===nr&&p.userData.col===nc&&p!==piece);
  if(occupant&&occupant.userData.color==='black') return; // skip, retry not done for simplicity
  if(occupant) chessCapture(piece, occupant, false);
  piece.userData.row=nr; piece.userData.col=nc;
  piece.position.set(nr-3.5,0.7,nc-3.5);
  setTimeout(()=>{if(piece.userData.alive) piece.position.y=0.18;},200);
  chessTurn='white';
  addHudChat('Sistema','Pretas moveram. Sua vez!','sys');
}

function buildDanceScene(){
  scene3d.background=new THREE.Color(0x0a001a);
  scene3d.fog=new THREE.Fog(0x0a001a,20,80);
  addLights(0x220044,0.5);
  // Dance floor with colored tiles
  for(let x=-5;x<=5;x++) for(let z=-5;z<=5;z++){
    const col=[0xff1744,0x00e676,0x2979ff,0xffd740,0xd500f9][(Math.abs(x)+Math.abs(z))%5];
    const tile=new THREE.Mesh(new THREE.BoxGeometry(1.9,0.15,1.9),
      new THREE.MeshStandardMaterial({color:col,roughness:.3,emissive:col,emissiveIntensity:.15}));
    tile.position.set(x*2,0,z*2); scene3d.add(tile);
  }
  // Spinning disco ball
  const disco=new THREE.Mesh(new THREE.SphereGeometry(0.6,12,12),
    new THREE.MeshStandardMaterial({color:0xffffff,roughness:0,metalness:1}));
  disco.position.set(0,6,0); scene3d.add(disco); disco.userData.isDisco=true;
  // Colored stage lights
  const lColors=[0xff0044,0x00ffaa,0x4400ff,0xffcc00];
  lColors.forEach((col,i)=>{
    const pl=new THREE.PointLight(col,3,15);
    pl.position.set(Math.cos(i*Math.PI/2)*7,5,Math.sin(i*Math.PI/2)*7);
    pl.userData.danceLight=true; pl.userData.phase=i;
    scene3d.add(pl);
  });
  spawnBots3D(4);
  player3d={x:0,y:1,z:4,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  addHudChat('Sistema','Dance Battle! Mova-se no ritmo e mostre seus passos!','sys');
}

// ═══════════════════════════════════════
// NEXUSBOTS MODE
// ═══════════════════════════════════════
const NEXUS_IMGS = {
  purple_man: "data:image/jpeg;base64,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",
  beagle:     "data:image/jpeg;base64,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",
  creep:      "data:image/jpeg;base64,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",
  shadow:     "data:image/jpeg;base64,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",
  horror:     "data:image/jpeg;base64,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",
  bighead:    "data:image/jpeg;base64,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"
};
const NEXUS_NAMES = ['purple_man','beagle','creep','shadow','horror','bighead'];

function buildNexusBotsScene(){
  scene3d.background=new THREE.Color(0x010005);
  scene3d.fog=new THREE.Fog(0x010005,50,400);
  scene3d.add(new THREE.AmbientLight(0x110022,0.6));
  const dl=new THREE.DirectionalLight(0x3300aa,0.4);
  dl.position.set(20,50,20); scene3d.add(dl);

  // MAPA GIGANTE 500x500
  const ground=new THREE.Mesh(
    new THREE.PlaneGeometry(500,500,50,50),
    new THREE.MeshStandardMaterial({color:0x05000f,roughness:1})
  );
  ground.rotation.x=-Math.PI/2; ground.receiveShadow=true;
  scene3d.add(ground); groundMesh=ground;

  const grid=new THREE.GridHelper(500,100,0x220033,0x110022);
  grid.material.transparent=true; grid.material.opacity=0.3;
  scene3d.add(grid);

  const wallMat=new THREE.MeshStandardMaterial({color:0x0a000f,roughness:0.9,metalness:0.1});
  const glassMat=new THREE.MeshStandardMaterial({color:0x002233,roughness:0.1,metalness:0.5,transparent:true,opacity:0.4});

  // Helper: add building
  function addBuilding(x,z,w,d,h,col){
    const mat=new THREE.MeshStandardMaterial({color:col||0x0a000f,roughness:.85});
    const b=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),mat);
    b.position.set(x,h/2,z); b.castShadow=true; b.receiveShadow=true; scene3d.add(b);
    // Windows
    for(let wy=2;wy<h-1;wy+=3) for(let wxi=-Math.floor(w/4);wxi<=Math.floor(w/4);wxi++){
      const win=new THREE.Mesh(new THREE.BoxGeometry(0.8,1.2,0.1),
        new THREE.MeshStandardMaterial({color:0x003355,emissive:0x001122,emissiveIntensity:.6,transparent:true,opacity:.8}));
      win.position.set(x+wxi*3,wy,z+d/2+0.05); scene3d.add(win);
    }
    return b;
  }

  // DISTRICT 1 — Urban blocks
  const buildings=[
    [20,20,8,6,14],[20,-20,6,8,20],[30,0,5,5,10],
    [-20,25,7,5,16],[-30,10,5,7,22],[-25,-20,6,6,12],
    [40,40,9,7,18],[-40,40,8,8,24],[40,-40,7,9,16],[-40,-40,6,7,20],
    [0,35,12,4,8],[0,-35,4,12,12],[55,0,6,6,18],[-55,0,8,6,14],
    [70,30,5,5,10],[70,-30,5,5,14],[-70,30,6,5,18],[-70,-30,5,6,10],
    [90,15,7,5,20],[90,-15,5,7,16],[-90,15,5,5,12],[-90,-15,7,5,22],
  ];
  buildings.forEach(([x,z,w,d,h])=>{
    addBuilding(x,z,w,d,h,new THREE.Color().setHSL(Math.random()*.05+.7,.4,.06).getHex());
  });

  // CORRIDORS — long walls forming paths
  const corridors=[
    [0,10,40,0.5,3],[0,-10,40,0.5,3],
    [10,0,0.5,30,3],[-10,0,0.5,30,3],
    [50,15,0.5,25,4],[50,-15,0.5,25,4],
    [-50,15,0.5,25,4],[-50,-15,0.5,25,4],
    [0,60,60,0.5,3.5],[0,-60,60,0.5,3.5],
    [60,0,0.5,60,3.5],[-60,0,0.5,60,3.5],
  ];
  corridors.forEach(([x,z,w,d,h])=>{
    const wall=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),wallMat);
    wall.position.set(x,h/2,z); wall.castShadow=true; scene3d.add(wall);
  });

  // WAREHOUSES / GALPÕES
  const warehouses=[[100,0,20,14,8],[0,100,14,20,8],[-100,0,20,14,8],[0,-100,14,20,8]];
  warehouses.forEach(([x,z,w,d,h])=>{
    const roof=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),new THREE.MeshStandardMaterial({color:0x1a0a00,roughness:.9}));
    roof.position.set(x,h/2,z); roof.castShadow=true; scene3d.add(roof);
    // Doors
    const door=new THREE.Mesh(new THREE.BoxGeometry(2.5,4,0.2),new THREE.MeshStandardMaterial({color:0x330011,roughness:.8}));
    door.position.set(x,2,z+d/2+0.1); scene3d.add(door);
  });

  // PRÉDIOS CENTRAIS
  addBuilding(0,0,6,6,30,0x020010);
  // Observation tower
  const tower=new THREE.Mesh(new THREE.CylinderGeometry(2,3,40,8),new THREE.MeshStandardMaterial({color:0x0a000a,roughness:.8}));
  tower.position.set(0,20,0); scene3d.add(tower);
  const cap=new THREE.Mesh(new THREE.ConeGeometry(3,5,8),new THREE.MeshStandardMaterial({color:0x330022}));
  cap.position.set(0,42.5,0); scene3d.add(cap);

  // ALLEYWAYS — narrow passages
  [[-15,30,0.5,20,2.5],[15,30,0.5,20,2.5],[-15,-30,0.5,20,2.5],[15,-30,0.5,20,2.5]].forEach(([x,z,w,d,h])=>{
    const a=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),wallMat);
    a.position.set(x,h/2,z); scene3d.add(a);
  });

  // SECRET AREAS — hidden passages
  const secretMat=new THREE.MeshStandardMaterial({color:0x220011,emissive:0x110005,emissiveIntensity:.4,roughness:.7});
  const secretRoom=new THREE.Mesh(new THREE.BoxGeometry(10,4,10),secretMat);
  secretRoom.position.set(120,2,120); scene3d.add(secretRoom);
  const secretLight=new THREE.PointLight(0xd500f9,3,15);
  secretLight.position.set(120,5,120); scene3d.add(secretLight);

  // TUNNELS — underground passages
  const tunnelMat=new THREE.MeshStandardMaterial({color:0x050010,roughness:1});
  const tunnel=new THREE.Mesh(new THREE.BoxGeometry(30,3,4),tunnelMat);
  tunnel.position.set(0,.5,0); scene3d.add(tunnel);

  // STAIRS — scattered
  for(let i=0;i<8;i++){
    const stair=new THREE.Mesh(new THREE.BoxGeometry(2,.3,1),new THREE.MeshStandardMaterial({color:0x1a1a2a}));
    stair.position.set((Math.random()-.5)*80,(i+1)*.3,(Math.random()-.5)*80); scene3d.add(stair);
  }

  // ATMOSPHERE LIGHTS
  const lColors=[0xff0044,0x4400ff,0x00ffaa,0xff4400,0xd500f9,0x00f5ff,0xff1744];
  lColors.forEach((col,i)=>{
    const pl=new THREE.PointLight(col,2,80);
    pl.position.set(Math.cos(i/lColors.length*Math.PI*2)*120,10,Math.sin(i/lColors.length*Math.PI*2)*120);
    scene3d.add(pl);
  });
  // Close-range chase lights
  for(let i=0;i<12;i++){
    const pl=new THREE.PointLight(0x330055,1.5,30);
    pl.position.set((Math.random()-.5)*200,5,(Math.random()-.5)*200);
    scene3d.add(pl);
  }

  // SPAWN NEXTBOTS
  const count=parseInt(document.getElementById('nexusbots-count')?.value||8);
  spawnNexusBots(count);

  player3d={x:0,y:1.5,z:5,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  S.hp=100;
  addHudChat('Sistema','NEXUSBOTS! Mapa gigante — '+count+' criaturas chegando. WASD=mover, mouse=câmera. SOBREVIVA!','sys');
  document.getElementById('hud-kills').textContent='KILLS: 0';
  setTimeout(()=>addHudChat('Sistema','⚠ Eles estão chegando de todos os lados...','sys'),3000);
  setTimeout(()=>addHudChat('Sistema','🏃 Corra! Use os prédios e corredores para escapar!','sys'),7000);
}

function spawnNexusBots(count){
  bots3d=[]; botMeshes.forEach(m=>scene3d.remove(m)); botMeshes=[];
  const spd=S.opts.diff==='ultra'?0.12:S.opts.diff==='insane'?0.085:S.opts.diff==='hard'?0.055:0.032;

  for(let i=0;i<count;i++){
    const imgKey=NEXUS_NAMES[i%NEXUS_NAMES.length];
    const imgSrc=NEXUS_IMGS[imgKey];

    // Create canvas texture from base64 image
    const tex=new THREE.TextureLoader().load(imgSrc);
    tex.colorSpace=THREE.SRGBColorSpace||THREE.LinearEncoding;

    // Sprite material — billboard (always faces camera)
    const mat=new THREE.SpriteMaterial({map:tex, transparent:true, alphaTest:0.1, depthWrite:false});
    const sprite=new THREE.Sprite(mat);

    // Random size (some bigger = scarier)
    const sc=1.8+Math.random()*2.2;
    sprite.scale.set(sc, sc*1.2, 1);

    // Random position spread on the map
    const angle=Math.random()*Math.PI*2;
    const dist=15+Math.random()*120;
    const bx=Math.cos(angle)*dist, bz=Math.sin(angle)*dist;
    sprite.position.set(bx, sc*0.6, bz);
    scene3d.add(sprite);
    botMeshes.push(sprite);

    const botData={
      x:bx, y:sc*0.6, z:bz,
      vx:0, vz:0, hp:100,
      spd: spd*(0.8+Math.random()*0.6),
      walkT:Math.random()*6,
      group:sprite,
      isNexusBot:true,
      imgKey,
      scale:sc,
      // Pro AI state
      state:'patrol',
      wanderX:(Math.random()-0.5)*100,
      wanderZ:(Math.random()-0.5)*100,
      chargeTimer:0,
      bobPhase:Math.random()*Math.PI*2,
    };
    bots3d.push(botData);
  }
}

function updateNexusBots(t){
  if(!S.running||S.paused) return;
  const diff=S.opts.diff;
  const baseSpd=diff==='ultra'?0.32:diff==='insane'?0.22:diff==='hard'?0.15:0.10;

  bots3d.forEach((bot)=>{
    if(!bot.isNexusBot||!bot.group) return;
    const dx=player3d.x-bot.x, dz=player3d.z-bot.z;
    const dist=Math.sqrt(dx*dx+dz*dz)||0.001;

    // STATE MACHINE
    bot.stateTimer=(bot.stateTimer||0)-1;
    if(dist<80){
      bot.state='chase';
      bot.lastKnownX=player3d.x;
      bot.lastKnownZ=player3d.z;
    } else if(bot.state==='chase'&&dist>80&&bot.stateTimer<=0){
      bot.state='search';
      bot.stateTimer=300;
    } else if(bot.state==='search'&&bot.stateTimer<=0){
      bot.state='patrol';
      bot.wanderX=(Math.random()-.5)*200;
      bot.wanderZ=(Math.random()-.5)*200;
      bot.stateTimer=400;
    }

    let spd=baseSpd;
    if(bot.state==='chase'){
      // Accelerate the closer they get
      const closeBoost=dist<15?2.0:dist<40?1.4:dist<80?1.1:1.0;
      spd=baseSpd*closeBoost*(bot.spd||1);
      // Move directly to player
      bot.x+=dx/dist*spd;
      bot.z+=dz/dist*spd;
      // Natural turning — don't teleport rotation
      const targetAngle=Math.atan2(dx,dz);
      if(bot.angle===undefined) bot.angle=targetAngle;
      const angleDiff=((targetAngle-bot.angle)+Math.PI*3)%(Math.PI*2)-Math.PI;
      bot.angle+=angleDiff*0.15;
      bot.group.rotation.y=bot.angle;
    } else if(bot.state==='search'){
      // Move to last known player position
      const sdx=bot.lastKnownX-bot.x, sdz=bot.lastKnownZ-bot.z;
      const sd=Math.sqrt(sdx*sdx+sdz*sdz)||0.001;
      if(sd>2){
        bot.x+=sdx/sd*spd*.7;
        bot.z+=sdz/sd*spd*.7;
      }
    } else {
      // Patrol — wander
      const wdx=bot.wanderX-bot.x, wdz=bot.wanderZ-bot.z;
      const wd=Math.sqrt(wdx*wdx+wdz*wdz)||0.001;
      if(wd<3){bot.wanderX=(Math.random()-.5)*200;bot.wanderZ=(Math.random()-.5)*200;}
      bot.x+=wdx/wd*spd*.5;
      bot.z+=wdz/wd*spd*.5;
    }

    bot.y=bot.scale*0.6;

    // Running animation — bob based on state
    bot.walkT+=bot.state==='chase'?0.35:0.15;
    const runBob=bot.state==='chase'?Math.abs(Math.sin(bot.walkT*2))*0.3:Math.abs(Math.sin(bot.walkT))*0.12;
    bot.group.position.set(bot.x, bot.y+runBob, bot.z);

    // Scale pulsing when very close
    const scl=dist<6?bot.scale*(1+0.06*Math.sin(t*25)):bot.scale;
    bot.group.scale.set(scl, scl*1.2, 1);

    // Forward tilt when chasing
    bot.group.material.rotation=bot.state==='chase'?0.22:0;

    // Damage on contact
    if(dist<2.2&&!adminPowers.invis){
      const dmg=dist<1.0?100:40;
      S.hp=Math.max(0,S.hp-dmg);
      document.getElementById('hud-hfill').style.width=S.hp+'%';
      flashHit();
      player3d.vx-=(dx/dist)*0.35;
      player3d.vz-=(dz/dist)*0.35;
      if(S.hp<=0){
        addHudChat('Sistema','💀 NEXUSBOT TE PEGOU! GAME OVER','sys');
        showScorePopup('GAME OVER');
        endGame3D(); return;
      }
    }
  });
}


// ─── VOLLEYBALL ─────────────────────────────────────────────────────
function buildVolleyballScene(){
  scene3d.background=new THREE.Color(0x001428);
  scene3d.fog=new THREE.Fog(0x001428,40,150);
  addLights(0xffffff,1.3);
  // Sand court
  const sand=new THREE.Mesh(new THREE.PlaneGeometry(60,40),
    new THREE.MeshStandardMaterial({color:0xc2a55a,roughness:1}));
  sand.rotation.x=-Math.PI/2; sand.receiveShadow=true; scene3d.add(sand); groundMesh=sand;
  // Net in center
  const netPost1=new THREE.Mesh(new THREE.CylinderGeometry(.08,.08,3,8),new THREE.MeshStandardMaterial({color:0x888888}));
  netPost1.position.set(0,1.5,-9); scene3d.add(netPost1);
  const netPost2=netPost1.clone(); netPost2.position.set(0,1.5,9); scene3d.add(netPost2);
  const net=new THREE.Mesh(new THREE.BoxGeometry(.05,2.4,18),
    new THREE.MeshBasicMaterial({color:0xffffff,wireframe:true,transparent:true,opacity:.6}));
  net.position.set(0,1.5,0); scene3d.add(net);
  // Beach environment — palm trees
  for(let i=0;i<8;i++){
    const a=i/8*Math.PI*2, r=25+Math.random()*5;
    const trunk=new THREE.Mesh(new THREE.CylinderGeometry(.2,.35,5+Math.random()*2,6),
      new THREE.MeshStandardMaterial({color:0x6b4c11}));
    trunk.position.set(Math.cos(a)*r,trunk.geometry.parameters.height/2,Math.sin(a)*r);
    scene3d.add(trunk);
    const fronds=new THREE.Mesh(new THREE.SphereGeometry(2,6,4),
      new THREE.MeshStandardMaterial({color:0x2d5a1b}));
    fronds.position.set(Math.cos(a)*r,trunk.geometry.parameters.height+1,Math.sin(a)*r);
    scene3d.add(fronds);
  }
  // Ocean in background
  const ocean=new THREE.Mesh(new THREE.PlaneGeometry(200,80),
    new THREE.MeshStandardMaterial({color:0x006994,roughness:.1,metalness:.3}));
  ocean.rotation.x=-Math.PI/2; ocean.position.set(50,-.1,0); scene3d.add(ocean);
  // Volleyball
  const bm=new THREE.Mesh(new THREE.SphereGeometry(.28,16,16),
    new THREE.MeshStandardMaterial({color:0xffffff,roughness:.4}));
  bm.castShadow=true; scene3d.add(bm); ballMesh=bm; ball3d={x:0,y:.5,z:0,vx:0,vy:0,vz:0};
  spawnBots3D(4);
  player3d={x:0,y:1,z:7,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  addHudChat('Sistema','🏐 Vôlei na praia! F para passar a bola.','sys');
}

// ─── TENNIS ──────────────────────────────────────────────────────────
function buildTennisScene(){
  scene3d.background=new THREE.Color(0x6bb3ff);
  scene3d.fog=new THREE.Fog(0x6bb3ff,50,200);
  addLights(0xffffff,1.5);
  // Clay court — red-brown
  const court=new THREE.Mesh(new THREE.PlaneGeometry(36,18),
    new THREE.MeshStandardMaterial({color:0xcc4e00,roughness:.9}));
  court.rotation.x=-Math.PI/2; court.receiveShadow=true; scene3d.add(court); groundMesh=court;
  // Court lines
  [[0,0,36,.15],[0,0,.15,18],[-9,0,16.8,.1],[9,0,16.8,.1],[0,-4.5,.1,9],[0,4.5,.1,9]].forEach(([x,z,w,d])=>{
    const line=new THREE.Mesh(new THREE.PlaneGeometry(w,d),
      new THREE.MeshBasicMaterial({color:0xffffff}));
    line.rotation.x=-Math.PI/2; line.position.set(x,.01,z); scene3d.add(line);
  });
  // Net
  const net=new THREE.Mesh(new THREE.BoxGeometry(.05,1.1,18),
    new THREE.MeshBasicMaterial({color:0x333333,wireframe:true}));
  net.position.set(0,.55,0); scene3d.add(net);
  // Bleachers
  [-11,11].forEach(z=>{
    const bl=new THREE.Mesh(new THREE.BoxGeometry(30,3,2),
      new THREE.MeshStandardMaterial({color:0x2244aa}));
    bl.position.set(0,1.5,z); scene3d.add(bl);
    for(let i=0;i<30;i++){
      const cr=new THREE.Mesh(new THREE.SphereGeometry(.18,4,4),
        new THREE.MeshBasicMaterial({color:[0xff4444,0x4444ff,0xffff44,0x44ff44][i%4]}));
      cr.position.set(-14+i,.5+Math.random()*.5,z); scene3d.add(cr);
    }
  });
  // Sky gradient via background gradient illusion with a box
  const sky=new THREE.Mesh(new THREE.SphereGeometry(150,8,8),
    new THREE.MeshBasicMaterial({color:0x87ceeb,side:THREE.BackSide}));
  scene3d.add(sky);
  // Tennis ball
  const bm=new THREE.Mesh(new THREE.SphereGeometry(.18,12,12),
    new THREE.MeshStandardMaterial({color:0xccff00,roughness:.4}));
  scene3d.add(bm); ballMesh=bm; ball3d={x:0,y:.5,z:5,vx:0,vy:0,vz:0};
  spawnBots3D(2);
  player3d={x:0,y:1,z:7,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  addHudChat('Sistema','🎾 Tênis! Devolva a bola para o outro lado. F para rebater.','sys');
}

// ─── BOXING ──────────────────────────────────────────────────────────
function buildBoxingScene(){
  scene3d.background=new THREE.Color(0x0a0000);
  scene3d.fog=new THREE.Fog(0x0a0000,15,60);
  addLights(0x111111,.5);
  const floor=new THREE.Mesh(new THREE.PlaneGeometry(30,30),
    new THREE.MeshStandardMaterial({color:0x111111,roughness:1}));
  floor.rotation.x=-Math.PI/2; floor.receiveShadow=true; scene3d.add(floor); groundMesh=floor;
  // Boxing ring
  const canvas=new THREE.Mesh(new THREE.BoxGeometry(8,0.1,8),
    new THREE.MeshStandardMaterial({color:0x1a0a0a,roughness:.9}));
  canvas.position.y=.5; scene3d.add(canvas);
  // Ropes (4 sides, 3 heights)
  const ropeMat=new THREE.MeshBasicMaterial({color:0xff2222});
  [.8,1.3,1.8].forEach(ry=>{
    [[-4,0,0,.1,8],[4,0,0,.1,8],[0,0,-4,8,.1],[0,0,4,8,.1]].forEach(([rx,_,rz,rw,rd])=>{
      const rope=new THREE.Mesh(new THREE.BoxGeometry(rw,0.06,rd),ropeMat);
      rope.position.set(rx,.5+ry,rz); scene3d.add(rope);
    });
  });
  // Corner posts
  [[4,4],[-4,4],[4,-4],[-4,-4]].forEach(([px,pz])=>{
    const post=new THREE.Mesh(new THREE.CylinderGeometry(.08,.08,2.4,6),
      new THREE.MeshStandardMaterial({color:0xaaaaaa}));
    post.position.set(px,.5+1.2,pz); scene3d.add(post);
  });
  // Spotlight on ring
  const spot=new THREE.SpotLight(0xffffff,8,20,Math.PI/6,.5);
  spot.position.set(0,15,0); scene3d.add(spot);
  // Crowd
  for(let a=0;a<40;a++){
    const ang=a/40*Math.PI*2, r=10+Math.random()*3;
    const cr=new THREE.Mesh(new THREE.SphereGeometry(.2,4,4),
      new THREE.MeshBasicMaterial({color:[0xff4444,0x4444ff,0xffff00,0xffffff][a%4]}));
    cr.position.set(Math.cos(ang)*r,1+Math.random()*.5,Math.sin(ang)*r); scene3d.add(cr);
  }
  spawnBots3D(1);
  player3d={x:0,y:1.6,z:3,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  addHudChat('Sistema','🥊 Boxe! Encurrale o oponente e ataque de perto.','sys');
}

// ─── ARCHERY ─────────────────────────────────────────────────────────
function buildArcheryScene(){
  scene3d.background=new THREE.Color(0x1a3a00);
  scene3d.fog=new THREE.Fog(0x1a3a00,30,150);
  addLights(0x334422,1.2);
  const ground=new THREE.Mesh(new THREE.PlaneGeometry(100,60),
    new THREE.MeshStandardMaterial({color:0x2d6a1a,roughness:1}));
  ground.rotation.x=-Math.PI/2; ground.receiveShadow=true; scene3d.add(ground); groundMesh=ground;
  // Forest edges
  for(let i=0;i<30;i++){
    const side=i%2===0?-1:1, xo=(Math.random()-.5)*80;
    const tr=new THREE.Mesh(new THREE.CylinderGeometry(.3,.5,4+Math.random()*4,6),
      new THREE.MeshStandardMaterial({color:0x3a1800,roughness:1}));
    tr.position.set(xo,tr.geometry.parameters.height/2,side*22); scene3d.add(tr);
    const lv=new THREE.Mesh(new THREE.SphereGeometry(1.5+Math.random(),6,6),
      new THREE.MeshStandardMaterial({color:0x1a5a0a,roughness:.9}));
    lv.position.set(xo,tr.geometry.parameters.height+.5,side*22); scene3d.add(lv);
  }
  // Archery targets at distance
  [20,30,45].forEach((dist,i)=>{
    const offsets=[-4,0,4];
    const z=offsets[i];
    // Target rings
    [.9,.65,.45,.28,.15].forEach((r,ri)=>{
      const ring=new THREE.Mesh(new THREE.CylinderGeometry(r,r,.05,24),
        new THREE.MeshStandardMaterial({color:[0xffcc00,0xff2200,0x0022ff,0x111111,0xffffff][ri]}));
      ring.rotation.x=Math.PI/2; ring.position.set(dist,.5+r*0,z); scene3d.add(ring);
    });
    // Target stand
    const stand=new THREE.Mesh(new THREE.CylinderGeometry(.05,.05,1.4,6),
      new THREE.MeshStandardMaterial({color:0x5a3a00}));
    stand.position.set(dist,.7,z); scene3d.add(stand);
    // Target label
  });
  // Wind indicator
  const windArrow=new THREE.Mesh(new THREE.ConeGeometry(.1,.4,6),
    new THREE.MeshBasicMaterial({color:0x00aaff}));
  windArrow.position.set(-5,3,0); scene3d.add(windArrow);
  windArrow.userData.isWindArrow=true;
  // AimLab targets for archery
  spawnTargets(S.opts.diff==='ultra'?8:S.opts.diff==='hard'?5:3);
  player3d={x:-8,y:1,z:0,vx:0,vz:0,vy:0,onGround:true,yaw:0,pitch:0};
  ammo=20; document.getElementById('hud-ammo').textContent='FLECHAS: 20';
  addHudChat('Sistema','🏹 Tiro com Arco! Mire com o mouse, clique para atirar. Alvos coloridos = pontos!','sys');
}

// ─── SWIMMING ────────────────────────────────────────────────────────
function buildSwimmingScene(){
  scene3d.background=new THREE.Color(0x0022aa);
  scene3d.fog=new THREE.FogExp2(0x001166,.015);
  addLights(0x002244,1.4);
  // Pool floor — tiled
  const pool=new THREE.Mesh(new THREE.PlaneGeometry(60,20),
    new THREE.MeshStandardMaterial({color:0x0044bb,roughness:.1,metalness:.1}));
  pool.rotation.x=-Math.PI/2; pool.position.y=-.5; scene3d.add(pool); groundMesh=pool;
  // Lane ropes
  for(let i=-2;i<=2;i++){
    const rope=new THREE.Mesh(new THREE.CylinderGeometry(.05,.05,60,6),
      new THREE.MeshBasicMaterial({color:i%2===0?0xff4400:0x0044ff}));
    rope.rotation.z=Math.PI/2; rope.position.set(0,-.4,i*3); scene3d.add(rope);
  }
  // Pool walls
  [[0,-10.5,60,.5],[0,10.5,60,.5],[-30,0,.5,21],[30,0,.5,21]].forEach(([x,z,w,d])=>{
    const wall=new THREE.Mesh(new THREE.BoxGeometry(w,.8,d),
      new THREE.MeshStandardMaterial({color:0x88aacc,roughness:.3}));
    wall.position.set(x,.4,z); scene3d.add(wall);
  });
  // Underwater caustics glow
  for(let i=0;i<8;i++){
    const pl=new THREE.PointLight(0x0066ff,1.5,15);
    pl.position.set(-25+i*7,-1,(Math.random()-.5)*6); scene3d.add(pl);
  }
  // Overhead lights
  for(let i=0;i<4;i++){
    const pl=new THREE.PointLight(0xffffff,2,20);
    pl.position.set(-20+i*13,6,0); scene3d.add(pl);
  }
  // Spawn swimmer bots with swim animation flag
  spawnBots3D(S.opts.diff==='ultra'?6:4);
  bots3d.forEach(b=>{ b.isSwimming=true; });
  player3d={x:-26,y:0,z:0,vx:0,vz:0,vy:0,onGround:true,yaw:0,pitch:0};
  addHudChat('Sistema','🏊 Natação! Nade pela piscina. Chegue ao lado oposto!','sys');
}

// ─── CYCLING ─────────────────────────────────────────────────────────
function buildCyclingScene(){
  scene3d.background=new THREE.Color(0x87ceeb);
  scene3d.fog=new THREE.Fog(0x87ceeb,50,300);
  addLights(0xffffff,1.6);
  // Rolling hills
  const geo=new THREE.PlaneGeometry(400,100,40,20);
  const pos=geo.attributes.position;
  for(let i=0;i<pos.count;i++){
    const x=pos.getX(i), z=pos.getZ(i);
    pos.setZ(i, Math.sin(x*.04)*4+Math.sin(x*.015+z*.02)*3);
  }
  geo.computeVertexNormals();
  const terrain=new THREE.Mesh(geo,new THREE.MeshStandardMaterial({color:0x4a9a3a,roughness:1}));
  terrain.rotation.x=-Math.PI/2; scene3d.add(terrain); groundMesh=terrain;
  // Road on flat strip
  const road=new THREE.Mesh(new THREE.PlaneGeometry(400,.12),
    new THREE.MeshStandardMaterial({color:0x333333,roughness:.9}));
  road.rotation.x=-Math.PI/2; road.position.y=.01; scene3d.add(road);
  // Road width
  const roadW=new THREE.Mesh(new THREE.PlaneGeometry(400,5),
    new THREE.MeshStandardMaterial({color:0x555555,roughness:.9}));
  roadW.rotation.x=-Math.PI/2; roadW.position.y=.005; scene3d.add(roadW);
  // Road markings
  for(let x=-180;x<200;x+=8){
    const mk=new THREE.Mesh(new THREE.PlaneGeometry(4,.15),
      new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.7}));
    mk.rotation.x=-Math.PI/2; mk.position.set(x,.02,0); scene3d.add(mk);
  }
  // Mountains in bg
  [[-100,0,-60],[50,0,-55],[-20,0,-65],[120,0,-58]].forEach(([x,,z])=>{
    const mt=new THREE.Mesh(new THREE.ConeGeometry(20+Math.random()*15,30+Math.random()*20,6),
      new THREE.MeshStandardMaterial({color:0x6688aa,roughness:1}));
    mt.position.set(x,0,z); scene3d.add(mt);
    const snow=new THREE.Mesh(new THREE.ConeGeometry(5,8,6),
      new THREE.MeshStandardMaterial({color:0xeeeeff,roughness:1}));
    snow.position.set(x,mt.geometry.parameters.height*.6,z); scene3d.add(snow);
  });
  // Trees along road
  for(let x=-180;x<200;x+=15){
    [8,-8].forEach(z=>{
      const tr=new THREE.Mesh(new THREE.CylinderGeometry(.15,.25,2.5,6),
        new THREE.MeshStandardMaterial({color:0x4a2500,roughness:1}));
      tr.position.set(x,1.25,z); scene3d.add(tr);
      const lv=new THREE.Mesh(new THREE.SphereGeometry(.8,6,6),
        new THREE.MeshStandardMaterial({color:0x2a6a1a,roughness:.9}));
      lv.position.set(x,2.8,z); scene3d.add(lv);
    });
  }
  // Racing line — use car physics
  spawnRaceCarsExpanded();
  bots3d.forEach(b=>{ b.isCyclist=true; });
  player3d={x:-180,y:.7,z:0,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI/2,pitch:0};
  addHudChat('Sistema','🚴 Ciclismo! Pedale pela rota de montanha (200m). WASD para pedalar!','sys');
}

// ─── SKIING ──────────────────────────────────────────────────────────
function buildSkiingScene(){
  scene3d.background=new THREE.Color(0xddeeff);
  scene3d.fog=new THREE.Fog(0xddeeff,40,200);
  addLights(0xaabbdd,1.6);
  // Snow slope — inclined plane going downhill (Z axis)
  const geo=new THREE.PlaneGeometry(80,300,20,60);
  const pos2=geo.attributes.position;
  for(let i=0;i<pos2.count;i++){
    const z=pos2.getY(i); // in plane space Z = Y before rotation
    pos2.setZ(i, Math.sin(pos2.getX(i)*.05)*2+Math.random()*.5); // bumps
  }
  geo.computeVertexNormals();
  const slope=new THREE.Mesh(geo,new THREE.MeshStandardMaterial({color:0xeef6ff,roughness:.7}));
  slope.rotation.x=-Math.PI/2-0.18; // tilt ~10° for slope
  slope.position.z=-50; scene3d.add(slope); groundMesh=slope;
  // Slalom gates
  for(let z=-10;z>-200;z-=15){
    const side=Math.random()<0.5?-1:1;
    const color=Math.abs(z)%30<15?0xff1744:0x2196f3;
    [-1,1].forEach(s=>{
      const pole=new THREE.Mesh(new THREE.CylinderGeometry(.05,.05,1.5,6),
        new THREE.MeshBasicMaterial({color}));
      pole.position.set(side*6+s*.5,-.2,z); scene3d.add(pole);
    });
  }
  // Pine trees on edges
  for(let z=-10;z>-280;z-=8){
    [-15,15].forEach(x=>{
      const tr=new THREE.Mesh(new THREE.ConeGeometry(1.5,5,7),
        new THREE.MeshStandardMaterial({color:0x1a4a10,roughness:1}));
      tr.position.set(x+(Math.random()-.5)*4,2.5,z); scene3d.add(tr);
    });
  }
  // Finish line
  const finish=new THREE.Mesh(new THREE.BoxGeometry(14,.01,.4),
    new THREE.MeshBasicMaterial({color:0xffd740}));
  finish.position.set(0,.01,-250); scene3d.add(finish);
  scene3d.userData.skiFinishZ=-250;
  spawnBots3D(S.opts.diff==='ultra'?4:2);
  bots3d.forEach((b,i)=>{ b.isSkier=true; b.z=-10-i*5; });
  player3d={x:0,y:1,z:-5,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0.1};
  addHudChat('Sistema','⛷ Esqui! Desça o morro desviando das balizas. Chegue ao fim!','sys');
}


// ═══════════════════════════════════════
// BATTLE ROYALE
// ═══════════════════════════════════════
let brZoneRadius=120, brZoneTimer=0, brZoneShrinking=false;
let brZoneMesh=null, brAlivePlayers=20;

function buildBattleRoyaleScene(){
  scene3d.background=new THREE.Color(0x5a8a3a);
  scene3d.fog=new THREE.Fog(0x7aaa5a,60,400);
  addLights(0x8888aa,1.4);
  brZoneRadius=120; brZoneTimer=0; brAlivePlayers=20;

  // Giant island terrain 400x400
  const geo=new THREE.PlaneGeometry(400,400,50,50);
  const pos=geo.attributes.position;
  for(let i=0;i<pos.count;i++){
    const x=pos.getX(i),y=pos.getY(i);
    const h2=Math.sin(x*.018)*8+Math.sin(y*.022)*6+Math.sin(x*.05+y*.04)*3+Math.random()*1.5;
    pos.setZ(i,h2);
  }
  geo.computeVertexNormals();
  const island=new THREE.Mesh(geo,new THREE.MeshStandardMaterial({color:0x4a7a28,roughness:1}));
  island.rotation.x=-Math.PI/2; island.receiveShadow=true; scene3d.add(island); groundMesh=island;

  // Ocean surrounding
  const ocean=new THREE.Mesh(new THREE.PlaneGeometry(800,800),
    new THREE.MeshStandardMaterial({color:0x1144aa,roughness:.05,metalness:.3,transparent:true,opacity:.85}));
  ocean.rotation.x=-Math.PI/2; ocean.position.y=-1; scene3d.add(ocean);

  // Admin mansion in center
  buildMansion(0,1,0);

  // Village buildings scattered
  
  [[-70,0,10],[40,0,40],[-50,0,30],[60,0,-45],[-40,0,-55],[20,0,-80]].forEach(([bx,by,bz])=>{
    const bldW=6+Math.random()*8, bldH=3+Math.random()*6, bldD=6+Math.random()*8;
    const bld=new THREE.Mesh(new THREE.BoxGeometry(bldW,bldH,bldD),
      new THREE.MeshStandardMaterial({color:new THREE.Color().setHSL(Math.random()*.1+.08,.4,.3),roughness:.8}));
    bld.position.set(bx,bldH/2+1,bz); scene3d.add(bld);
    // Roof
    const roof=new THREE.Mesh(new THREE.ConeGeometry(bldW*.75,2,4),
      new THREE.MeshStandardMaterial({color:0x8b2020,roughness:.9}));
    roof.position.set(bx,bldH+2,bz); scene3d.add(roof);
  });

  // Loot crates
  for(let i=0;i<25;i++){
    const crate=new THREE.Mesh(new THREE.BoxGeometry(.8,.8,.8),
      new THREE.MeshStandardMaterial({color:0xddaa00,emissive:0x332200,roughness:.5,metalness:.3}));
    crate.position.set((Math.random()-.5)*200,1,(Math.random()-.5)*200);
    crate.userData.isLoot=true; scene3d.add(crate);
    const cl=new THREE.PointLight(0xffaa00,2,4); cl.position.copy(crate.position); cl.position.y+=1; scene3d.add(cl);
  }

  // Trees everywhere
  for(let i=0;i<120;i++){
    const tx=(Math.random()-.5)*360, tz=(Math.random()-.5)*360;
    const th=3+Math.random()*6;
    const trunk=new THREE.Mesh(new THREE.CylinderGeometry(.2,.35,th,6),
      new THREE.MeshStandardMaterial({color:0x4a2200,roughness:1}));
    trunk.position.set(tx,th/2+.5,tz); scene3d.add(trunk);
    const leaves=new THREE.Mesh(new THREE.SphereGeometry(1.5+Math.random()*1.5,7,7),
      new THREE.MeshStandardMaterial({color:new THREE.Color().setHSL(.28+Math.random()*.05,.7,.25),roughness:1}));
    leaves.position.set(tx,th+1,tz); scene3d.add(leaves);
  }

  // Blue zone visual ring
  const zoneGeo=new THREE.RingGeometry(brZoneRadius-.5,brZoneRadius+.5,64);
  brZoneMesh=new THREE.Mesh(zoneGeo,new THREE.MeshBasicMaterial({color:0x0088ff,transparent:true,opacity:.6,side:THREE.DoubleSide}));
  brZoneMesh.rotation.x=-Math.PI/2; brZoneMesh.position.y=.5; scene3d.add(brZoneMesh);

  spawnBots3D(S.opts.diff==='ultra'?18:S.opts.diff==='insane'?12:S.opts.diff==='hard'?8:5);
  player3d={x:0,y:4,z:120,vx:0,vz:0,vy:0,onGround:false,yaw:Math.PI,pitch:0};
  player3d.vy=-0.05; // parachute fall
  ammo=30; document.getElementById('hud-ammo').textContent='AMMO: 30';
  document.getElementById('hud-kills').textContent='VIVOS: '+brAlivePlayers;
  addHudChat('Sistema','🪂 BATTLE ROYALE! A zona está encolhendo. Último vivo vence! Loot=dourado','sys');
  // Start zone shrink
  brZoneTimer=0;
  S.brActive=true;
}

function buildMansion(mx,my,mz){
  // Main mansion body
  const main=new THREE.Mesh(new THREE.BoxGeometry(20,8,14),
    new THREE.MeshStandardMaterial({color:0xf5e8d0,roughness:.4,metalness:.05}));
  main.position.set(mx,my+4,mz); scene3d.add(main);
  // Wings
  [-1,1].forEach(s=>{
    const wing=new THREE.Mesh(new THREE.BoxGeometry(8,6,10),
      new THREE.MeshStandardMaterial({color:0xf0e0c0,roughness:.4}));
    wing.position.set(mx+s*14,my+3,mz); scene3d.add(wing);
  });
  // Roof
  const roof=new THREE.Mesh(new THREE.BoxGeometry(22,2,16),
    new THREE.MeshStandardMaterial({color:0x8b1a1a,roughness:.8}));
  roof.position.set(mx,my+8.5,mz); scene3d.add(roof);
  // Columns
  for(let i=-8;i<=8;i+=4){
    const col=new THREE.Mesh(new THREE.CylinderGeometry(.35,.4,8,10),
      new THREE.MeshStandardMaterial({color:0xf8f0e0,roughness:.3,metalness:.1}));
    col.position.set(mx+i,my+4,mz+7); scene3d.add(col);
  }
  // Windows (glowing)
  for(let wx=-7;wx<=7;wx+=4){
    for(let wy=2;wy<=6;wy+=3){
      const win=new THREE.Mesh(new THREE.BoxGeometry(.1,1.2,1.8),
        new THREE.MeshStandardMaterial({color:0xffeeaa,emissive:0xffee44,emissiveIntensity:.4,roughness:.1}));
      win.position.set(mx-10,my+wy,mz+wx); scene3d.add(win);
      const wl=new THREE.PointLight(0xffee44,1.5,5); wl.position.set(mx-9,my+wy,mz+wx); scene3d.add(wl);
    }
  }
  // Pool
  const pool=new THREE.Mesh(new THREE.BoxGeometry(8,0.5,5),
    new THREE.MeshStandardMaterial({color:0x0088ff,roughness:.05,metalness:.2,transparent:true,opacity:.8}));
  pool.position.set(mx+20,my+.25,mz+8); scene3d.add(pool);
  const poolL=new THREE.PointLight(0x0088ff,3,8); poolL.position.set(mx+20,my+1,mz+8); scene3d.add(poolL);
  // Helipad on roof
  const helipad=new THREE.Mesh(new THREE.CylinderGeometry(3,3,.1,16),
    new THREE.MeshStandardMaterial({color:0x333333}));
  helipad.position.set(mx+12,my+9.5,mz); scene3d.add(helipad);
  const hH=new THREE.Mesh(new THREE.TorusGeometry(2.5,.1,6,16),
    new THREE.MeshBasicMaterial({color:0xffff00}));
  hH.position.set(mx+12,my+9.6,mz); scene3d.add(hH);
}

// Update BR zone in loop
function updateBattleRoyale(){
  if(!S.brActive||!S.running) return;
  brZoneTimer++;
  // Shrink every 600 frames (~10s)
  if(brZoneTimer%600===0&&brZoneRadius>15){
    brZoneRadius=Math.max(15,brZoneRadius-12);
    if(brZoneMesh){
      brZoneMesh.geometry.dispose();
      brZoneMesh.geometry=new THREE.RingGeometry(brZoneRadius-.5,brZoneRadius+.5,64);
    }
    addHudChat('Sistema','⚠ ZONA ENCOLHENDO! Raio: '+Math.round(brZoneRadius)+'m','sys');
  }
  // Zone damage if outside
  const pd=Math.sqrt(player3d.x**2+player3d.z**2);
  if(pd>brZoneRadius){
    if(brZoneTimer%60===0){
      S.hp=Math.max(0,S.hp-5);
      document.getElementById('hud-hfill').style.width=S.hp+'%';
      if(S.hp<=0){addHudChat('Sistema','💀 Zona te matou!','sys');endGame3D();}
      flashHit();
    }
  }
  // Bot kills update
  if(brZoneTimer%300===0&&brAlivePlayers>1){
    brAlivePlayers--;
    document.getElementById('hud-kills').textContent='VIVOS: '+brAlivePlayers;
    if(brAlivePlayers===1){
      showScorePopup('VITÓRIA ROYALE! 🏆');
      addHudChat('Sistema','🏆 VOCÊ VENCEU O BATTLE ROYALE!','sys');
      S.brActive=false;
      setTimeout(endGame3D,3000);
    }
  }
}

// ═══════════════════════════════════════
// AIMLAB PVP — vs Bot IA
// ═══════════════════════════════════════
let pvpBotScore=0, pvpBotCd=0, pvpBotTargetIdx=-1;

function buildAimlabPvpScene(){
  // Reuse aimlab base scene
  buildAimLabScene();
  pvpBotScore=0; pvpBotCd=0; pvpBotTargetIdx=-1;
  // Add a visible opponent bot
  spawnBots3D(1);
  bots3d[0].isPvpAimBot=true;
  document.getElementById('hud-kills').textContent='VOCÊ 0 × 0 BOT';
  addHudChat('Sistema','🎯 AIMLAB PVP! Você vs Bot de mira. Mais kills em 2min vence!','sys');
}

function updateAimlabPvpBot(){
  if(!S.running||!bots3d.length) return;
  const aBot=bots3d.find(b=>b.isPvpAimBot);
  if(!aBot) return;
  pvpBotCd--;
  if(pvpBotCd<=0&&targets3d.length>0){
    // Bot aims at random target — speed depends on difficulty
    const shootInterval=S.opts.diff==='ultra'?25:S.opts.diff==='hard'?55:S.opts.diff==='insane'?35:90;
    pvpBotCd=shootInterval+Math.floor(Math.random()*shootInterval);
    // Pick random living target
    const alive=targets3d.filter(t=>!t.hit);
    if(alive.length>0){
      const tgt=alive[Math.floor(Math.random()*alive.length)];
      // "Hit" it
      tgt.hit=true;
      scene3d.remove(tgt.mesh);
      const ti=targets3d.indexOf(tgt); if(ti>-1) targets3d.splice(ti,1);
      setTimeout(spawnOneTarget,600);
      pvpBotScore++;
      document.getElementById('hud-kills').textContent=`VOCÊ ${kills} × ${pvpBotScore} BOT`;
      addHudChat('Bot_IA','acertei! '+pvpBotScore+' pts 😤','o');
      // Bot flash on its position
      spawnHitParticles(aBot.x,1.1,aBot.z);
    }
  }
}

function buildHorrorScene(){
  scene3d.background=new THREE.Color(0x000005);
  scene3d.fog=new THREE.FogExp2(0x000005,.06);
  // Dark floor with cracks
  const fl=new THREE.Mesh(new THREE.PlaneGeometry(60,60),new THREE.MeshStandardMaterial({color:0x050008,roughness:1,metalness:0}));
  fl.rotation.x=-Math.PI/2; fl.receiveShadow=true; scene3d.add(fl); groundMesh=fl;
  // Ceiling
  const ceil=new THREE.Mesh(new THREE.PlaneGeometry(60,60),new THREE.MeshStandardMaterial({color:0x020003}));
  ceil.rotation.x=Math.PI/2; ceil.position.y=6; scene3d.add(ceil);
  // Walls maze
  const wallMat=new THREE.MeshStandardMaterial({color:0x0a000a,roughness:1});
  const walls=[[0,-25,60,.5,5],[0,25,60,.5,5],[-25,0,.5,50,5],[25,0,.5,50,5]];
  walls.forEach(([x,z,w,d,h])=>{
    const wl=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),wallMat);
    wl.position.set(x,h/2,z); wl.castShadow=true; wl.receiveShadow=true; scene3d.add(wl);
  });
  // Internal maze walls
  const mwalls=[[-10,0,20,.5,5],[5,-8,.5,10,5],[5,8,.5,10,5],[-5,5,10,.5,5],[10,12,.5,12,5],[15,-5,12,.5,5]];
  mwalls.forEach(([x,z,w,d,h])=>{
    const wl=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),wallMat);
    wl.position.set(x,h/2,z); wl.castShadow=true; scene3d.add(wl);
  });
  // Flickering red light (monster position)
  const ml=new THREE.PointLight(0x660000,3,20);
  ml.position.set(-10,2,-10); scene3d.add(ml); ml.userData.flick=true;
  // Weak ambient
  scene3d.add(new THREE.AmbientLight(0x110011,.5));
  // Player lantern
  const lantern=new THREE.SpotLight(0xffcc66,4,15,Math.PI/4,.5,.8);
  lantern.position.set(0,1.5,0); scene3d.add(lantern); lantern.userData.isLantern=true;
  // Monster
  spawnMonster();
  player3d={x:0,y:1,z:10,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
}

function buildAimLabScene(){
  scene3d.background=new THREE.Color(0x001020);
  scene3d.fog=new THREE.Fog(0x001020,20,80);
  addLights(0x002244,1.0);
  const fl=new THREE.Mesh(new THREE.PlaneGeometry(30,30),new THREE.MeshStandardMaterial({color:0x001528,roughness:.9}));
  fl.rotation.x=-Math.PI/2; scene3d.add(fl); groundMesh=fl;
  // Grid on floor
  const gh=new THREE.GridHelper(30,30,0x003366,0x001133);
  scene3d.add(gh);
  // Walls
  const wm=new THREE.MeshStandardMaterial({color:0x001122,roughness:.9});
  [[-15,0,1,30,4],[15,0,1,30,4],[0,-15,30,1,4],[0,15,30,1,4]].forEach(([x,z,w,d,h])=>{
    const wl=new THREE.Mesh(new THREE.BoxGeometry(w,h,d),wm); wl.position.set(x,h/2,z); scene3d.add(wl);
  });
  // Neon lights on walls
  [0,1,2,3].forEach(i=>{
    const neon=new THREE.PointLight(0x0044ff,2,12);
    neon.position.set(Math.cos(i*Math.PI/2)*13,3,Math.sin(i*Math.PI/2)*13);
    scene3d.add(neon);
  });
  targets3d=[];
  spawnTargets(S.opts.diff==='ultra'?12:S.opts.diff==='insane'?8:S.opts.diff==='hard'?5:3);
  // Spawn 1 moving aim bot NPC
  spawnBots3D(1);
  player3d={x:0,y:1,z:8,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  document.getElementById('hud-ammo').textContent='AMMO: 30';
}

function buildPVPScene(){
  scene3d.background=new THREE.Color(0x080018);
  scene3d.fog=new THREE.Fog(0x080018,20,80);
  addLights(0x220044,.9);
  const fl=new THREE.Mesh(new THREE.PlaneGeometry(40,40),new THREE.MeshStandardMaterial({color:0x100020,roughness:.8,metalness:.2}));
  fl.rotation.x=-Math.PI/2; fl.receiveShadow=true; scene3d.add(fl); groundMesh=fl;
  // Cover objects
  for(let i=0;i<12;i++){
    const cov=new THREE.Mesh(new THREE.BoxGeometry(Math.random()+.5,Math.random()+.5,Math.random()+.5),new THREE.MeshStandardMaterial({color:0x220033,roughness:.6,metalness:.4}));
    cov.position.set((Math.random()-.5)*30,cov.geometry.parameters.height/2,(Math.random()-.5)*30);
    cov.castShadow=true; scene3d.add(cov);
  }
  spawnBots3D(S.opts.diff==='ultra'?6:S.opts.diff==='insane'?4:S.opts.diff==='hard'?3:2);
  player3d={x:0,y:1,z:10,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  ammo=30; document.getElementById('hud-ammo').textContent='AMMO: 30';
}

function buildRaceScene(){
  scene3d.background=new THREE.Color(0x080015);
  scene3d.fog=new THREE.Fog(0x080015,25,120);
  addLights(0x220033,0.9);
  // Track surface — oval
  const trackMat=new THREE.MeshStandardMaterial({color:0x1a1a2a,roughness:1});
  const track=new THREE.Mesh(new THREE.PlaneGeometry(100,16),trackMat);
  track.rotation.x=-Math.PI/2; track.receiveShadow=true; scene3d.add(track); groundMesh=track;
  // Track lines
  for(let i=-48;i<50;i+=6){
    const line=new THREE.Mesh(new THREE.BoxGeometry(.15,.01,3.5),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.35}));
    line.position.set(i,.01,0); scene3d.add(line);
  }
  // Side lines
  [-7.5,7.5].forEach(z=>{
    const sl=new THREE.Mesh(new THREE.BoxGeometry(100,.01,.15),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.5}));
    sl.position.set(0,.01,z); scene3d.add(sl);
  });
  // Barriers (red/white)
  for(let i=-48;i<50;i+=4){
    [8.5,-8.5].forEach(z=>{
      const bar=new THREE.Mesh(new THREE.BoxGeometry(3.5,.8,.3),new THREE.MeshStandardMaterial({color:i%8===0?0xff1744:0xffffff,roughness:.6}));
      bar.position.set(i,.4,z); scene3d.add(bar);
    });
  }
  // Grandstands
  [-12,12].forEach(z=>{
    const gs=new THREE.Mesh(new THREE.BoxGeometry(80,4,.5),new THREE.MeshStandardMaterial({color:0x112233,roughness:.9}));
    gs.position.set(0,2,z); scene3d.add(gs);
    // Crowd dots
    for(let c=0;c<80;c++){
      const cr=new THREE.Mesh(new THREE.SphereGeometry(.18,4,4),new THREE.MeshBasicMaterial({color:PCOLORS[Math.floor(Math.random()*PCOLORS.length)]}));
      cr.position.set((Math.random()-0.5)*78,(Math.random()*2+.5),z+(z>0?-.4:.4)); scene3d.add(cr);
    }
  });
  // Start/finish line
  const sf=new THREE.Mesh(new THREE.BoxGeometry(.4,.01,16),new THREE.MeshBasicMaterial({color:0xffffff}));
  sf.position.set(-40,.01,0); scene3d.add(sf);
  // Spawn race car bots
  spawnRaceCars();
  player3d={x:-44,y:.6,z:-2,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI/2,pitch:0};
}

function spawnRaceCars(){
  bots3d=[]; botMeshes.forEach(m=>scene3d.remove(m)); botMeshes=[];
  const carColors=[0xff1744,0x2196f3,0x00e676,0xffd740,0xd500f9,0xff9100];
  const spd=S.opts.diff==='ultra'?.22:S.opts.diff==='insane'?.17:S.opts.diff==='hard'?.13:.09;
  const count=S.opts.diff==='ultra'?5:S.opts.diff==='insane'?4:3;
  for(let i=0;i<count;i++){
    const col=carColors[i%carColors.length];
    const car=new THREE.Group();
    // Body
    const body=new THREE.Mesh(new THREE.BoxGeometry(2.8,.5,1.4),new THREE.MeshStandardMaterial({color:col,roughness:.3,metalness:.5}));
    body.position.y=.45; car.add(body);
    // Roof/cockpit
    const roof=new THREE.Mesh(new THREE.BoxGeometry(1.2,.35,1.1),new THREE.MeshStandardMaterial({color:col,roughness:.3,metalness:.5}));
    roof.position.set(.1,.75,0); car.add(roof);
    // Windshield
    const wind=new THREE.Mesh(new THREE.BoxGeometry(.05,.3,.9),new THREE.MeshStandardMaterial({color:0x88ccff,transparent:true,opacity:.5,metalness:.8}));
    wind.position.set(.58,.67,0); car.add(wind);
    // Wheels (4)
    [[1,.15,.75],[-1,.15,.75],[1,.15,-.75],[-1,.15,-.75]].forEach(([x,y,z])=>{
      const wheel=new THREE.Mesh(new THREE.CylinderGeometry(.28,.28,.18,12),new THREE.MeshStandardMaterial({color:0x111111,roughness:.9}));
      wheel.rotation.z=Math.PI/2; wheel.position.set(x,y,z); car.add(wheel);
      const rim=new THREE.Mesh(new THREE.CylinderGeometry(.16,.16,.2,8),new THREE.MeshStandardMaterial({color:0xaaaaaa,metalness:.8}));
      rim.rotation.z=Math.PI/2; rim.position.set(x,y,z); car.add(rim);
    });
    // Headlights
    const hl1=new THREE.PointLight(0xffffaa,2,6); hl1.position.set(1.4,.5,.45); car.add(hl1);
    const hl2=new THREE.PointLight(0xffffaa,2,6); hl2.position.set(1.4,.5,-.45); car.add(hl2);
    // Tail lights
    const tl=new THREE.PointLight(0xff2222,1.5,4); tl.position.set(-1.4,.5,0); car.add(tl);
    car.position.set(-40,.3,-3+(i*1.5));
    car.rotation.y=Math.PI/2;
    const botData={x:-40,y:.3,z:-3+(i*1.5),vx:0,vz:0,hp:100,spd,team:0,walkT:i*.8,group:car,isCar:true,lapProgress:0};
    scene3d.add(car); botMeshes.push(car); bots3d.push(botData);
  }
}

function addLights(ambCol,ambInt){
  scene3d.add(new THREE.AmbientLight(ambCol,ambInt));
  const dl=new THREE.DirectionalLight(0xffffff,.8);
  dl.position.set(10,20,10); dl.castShadow=true; dl.shadow.mapSize.width=1024; dl.shadow.mapSize.height=1024;
  scene3d.add(dl);
}

function buildArena(floorCol,lineCol){
  const fl=new THREE.Mesh(new THREE.PlaneGeometry(50,50),new THREE.MeshStandardMaterial({color:floorCol,roughness:.9}));
  fl.rotation.x=-Math.PI/2; fl.receiveShadow=true; scene3d.add(fl); groundMesh=fl;
  const gh=new THREE.GridHelper(50,25,lineCol,lineCol);
  gh.material.transparent=true; gh.material.opacity=.3;
  scene3d.add(gh);
  for(let i=0;i<4;i++){
    const w=new THREE.Mesh(new THREE.BoxGeometry(i%2===0?50:.5,5,.5),new THREE.MeshStandardMaterial({color:0x112233,roughness:.9}));
    w.position.set(i===1?24.75:i===3?-24.75:0,2.5,i===0?24.75:i===2?-24.75:0);
    scene3d.add(w);
  }
}

function spawnBots3D(n){
  bots3d=[]; botMeshes.forEach(m=>scene3d.remove(m)); botMeshes=[];
  const spd=S.opts.diff==='ultra'?3.5:S.opts.diff==='insane'?2.5:S.opts.diff==='hard'?1.6:0.9;
  for(let i=0;i<n;i++){
    const bot={x:(Math.random()-.5)*20,y:0,z:(Math.random()-.5)*20,vx:0,vz:0,hp:100,spd,team:i%2,
      walkT:Math.random()*Math.PI*2, targetX:0, targetZ:0, shootCd:0};
    const bc=new THREE.Color(i%2===0?0xff3300:0x2244ff);
    const skinCol=new THREE.Color(0xffbb88);
    const darkCol=new THREE.Color(0x111122);
    // Build humanoid group
    const g=new THREE.Group();
    // Torso
    const torso=new THREE.Mesh(new THREE.CylinderGeometry(.18,.2,.55,8),new THREE.MeshStandardMaterial({color:bc,roughness:.6}));
    torso.position.y=1.1; g.add(torso);
    // Chest detail
    const chest=new THREE.Mesh(new THREE.BoxGeometry(.28,.22,.12),new THREE.MeshStandardMaterial({color:bc,roughness:.5}));
    chest.position.y=1.25; g.add(chest);
    // Head
    const head=new THREE.Mesh(new THREE.SphereGeometry(.16,10,10),new THREE.MeshStandardMaterial({color:skinCol,roughness:.8}));
    head.position.y=1.72; g.add(head);
    // Helmet
    const helm=new THREE.Mesh(new THREE.CylinderGeometry(.17,.16,.08,8),new THREE.MeshStandardMaterial({color:bc,roughness:.4,metalness:.3}));
    helm.position.y=1.83; g.add(helm);
    // Eyes
    const eyeM=new THREE.MeshBasicMaterial({color:0xffffff});
    const le=new THREE.Mesh(new THREE.SphereGeometry(.03,5,5),eyeM); le.position.set(-.06,1.74,.14); g.add(le);
    const re=new THREE.Mesh(new THREE.SphereGeometry(.03,5,5),eyeM); re.position.set(.06,1.74,.14); g.add(re);
    const pupilM=new THREE.MeshBasicMaterial({color:0x000000});
    const lp=new THREE.Mesh(new THREE.SphereGeometry(.015,4,4),pupilM); lp.position.set(-.06,1.74,.16); g.add(lp);
    const rp=new THREE.Mesh(new THREE.SphereGeometry(.015,4,4),pupilM); rp.position.set(.06,1.74,.16); g.add(rp);
    // Arms (groups for animation)
    const laG=new THREE.Group(); laG.position.set(-.28,1.2,0);
    const laM=new THREE.Mesh(new THREE.CylinderGeometry(.06,.07,.4,7),new THREE.MeshStandardMaterial({color:bc,roughness:.6}));
    laM.position.y=-.2; laG.add(laM);
    const lhM=new THREE.Mesh(new THREE.SphereGeometry(.065,6,6),new THREE.MeshStandardMaterial({color:skinCol,roughness:.8}));
    lhM.position.y=-.45; laG.add(lhM);
    g.add(laG);
    const raG=new THREE.Group(); raG.position.set(.28,1.2,0);
    const raM=new THREE.Mesh(new THREE.CylinderGeometry(.06,.07,.4,7),new THREE.MeshStandardMaterial({color:bc,roughness:.6}));
    raM.position.y=-.2; raG.add(raM);
    const rhM=new THREE.Mesh(new THREE.SphereGeometry(.065,6,6),new THREE.MeshStandardMaterial({color:skinCol,roughness:.8}));
    rhM.position.y=-.45; raG.add(rhM);
    g.add(raG);
    // Hips
    const hips=new THREE.Mesh(new THREE.BoxGeometry(.3,.12,.18),new THREE.MeshStandardMaterial({color:darkCol,roughness:.8}));
    hips.position.y=.78; g.add(hips);
    // Legs (groups)
    const llG=new THREE.Group(); llG.position.set(-.1,.75,0);
    const llM=new THREE.Mesh(new THREE.CylinderGeometry(.07,.065,.45,7),new THREE.MeshStandardMaterial({color:darkCol,roughness:.8}));
    llM.position.y=-.225; llG.add(llM);
    const lfM=new THREE.Mesh(new THREE.BoxGeometry(.1,.06,.18),new THREE.MeshStandardMaterial({color:0x111111}));
    lfM.position.set(0,-.48,.03); llG.add(lfM);
    g.add(llG);
    const rlG=new THREE.Group(); rlG.position.set(.1,.75,0);
    const rlM=new THREE.Mesh(new THREE.CylinderGeometry(.07,.065,.45,7),new THREE.MeshStandardMaterial({color:darkCol,roughness:.8}));
    rlM.position.y=-.225; rlG.add(rlM);
    const rfM=new THREE.Mesh(new THREE.BoxGeometry(.1,.06,.18),new THREE.MeshStandardMaterial({color:0x111111}));
    rfM.position.set(0,-.48,.03); rlG.add(rfM);
    g.add(rlG);
    // Weapon if pvp/fps
    const gId=S.game?.id;
    if(gId==='pvp'||gId==='aimlab'||gId==='escape'||gId==='labyrinth'){
      const gunM=new THREE.Mesh(new THREE.BoxGeometry(.05,.05,.35),new THREE.MeshStandardMaterial({color:0x222233,roughness:.5,metalness:.4}));
      gunM.position.set(.3,1.1,.2); g.add(gunM);
    }
    g.position.set(bot.x,0,bot.z); g.castShadow=true;
    scene3d.add(g);
    bot.group=g; bot.laG=laG; bot.raG=raG; bot.llG=llG; bot.rlG=rlG; bot.headRef=head;
    botMeshes.push(g);
    bots3d.push(bot);
  }
}

function spawnMonster(){
  const mon={x:-15,y:0,z:-15,hp:300,spd:S.opts.diff==='ultra'?4.5:S.opts.diff==='insane'?3:S.opts.diff==='hard'?1.8:.9,
    alert:false, walkT:0, isMonster:true};
  const g=new THREE.Group();
  const darkRed=new THREE.MeshStandardMaterial({color:0x440000,emissive:0x220000,roughness:.9});
  const veryDark=new THREE.MeshStandardMaterial({color:0x220000,roughness:1});
  // Body - larger than player
  const torso=new THREE.Mesh(new THREE.CylinderGeometry(.28,.32,.8,8),darkRed);
  torso.position.y=1.3; g.add(torso);
  // Chest bone plates
  for(let b=0;b<3;b++){
    const plate=new THREE.Mesh(new THREE.BoxGeometry(.3,.08,.08),new THREE.MeshStandardMaterial({color:0x330000,emissive:0x110000}));
    plate.position.set(0,1.1+b*.2,.2); g.add(plate);
  }
  // Head - elongated
  const head=new THREE.Mesh(new THREE.SphereGeometry(.22,10,10,0,Math.PI*2,0,Math.PI*.8),darkRed);
  head.position.y=2.1; g.add(head);
  // Eyes glow red
  const eyeM=new THREE.MeshBasicMaterial({color:0xff0000});
  const le=new THREE.Mesh(new THREE.SphereGeometry(.055,6,6),eyeM); le.position.set(-.08,2.18,.18); g.add(le);
  const re=new THREE.Mesh(new THREE.SphereGeometry(.055,6,6),eyeM); re.position.set(.08,2.18,.18); g.add(re);
  // Red point lights for eyes glow
  const eL=new THREE.PointLight(0xff0000,2,3); eL.position.set(0,2.15,.2); g.add(eL);
  // Claws/arms - bigger
  const laG=new THREE.Group(); laG.position.set(-.38,1.4,0);
  const laM=new THREE.Mesh(new THREE.CylinderGeometry(.09,.11,.55,7),darkRed);
  laM.position.y=-.28; laG.add(laM);
  const clawM=new THREE.MeshStandardMaterial({color:0x660000,metalness:.3});
  for(let c=0;c<3;c++){
    const claw=new THREE.Mesh(new THREE.ConeGeometry(.03,.12,4),clawM);
    claw.position.set((c-.1)*.07,-.62,.05); claw.rotation.x=-.3; laG.add(claw);
  }
  g.add(laG);
  const raG=new THREE.Group(); raG.position.set(.38,1.4,0);
  const raM=new THREE.Mesh(new THREE.CylinderGeometry(.09,.11,.55,7),darkRed);
  raM.position.y=-.28; raG.add(raM);
  for(let c=0;c<3;c++){
    const claw=new THREE.Mesh(new THREE.ConeGeometry(.03,.12,4),clawM);
    claw.position.set((c-.1)*.07,-.62,.05); claw.rotation.x=-.3; raG.add(claw);
  }
  g.add(raG);
  // Legs
  const llG=new THREE.Group(); llG.position.set(-.15,.85,0);
  const llM=new THREE.Mesh(new THREE.CylinderGeometry(.1,.09,.6,7),darkRed);
  llM.position.y=-.3; llG.add(llM);
  const lfM=new THREE.Mesh(new THREE.BoxGeometry(.14,.07,.22),veryDark);
  lfM.position.set(0,-.65,.04); llG.add(lfM);
  g.add(llG);
  const rlG=new THREE.Group(); rlG.position.set(.15,.85,0);
  const rlM=new THREE.Mesh(new THREE.CylinderGeometry(.1,.09,.6,7),darkRed);
  rlM.position.y=-.3; rlG.add(rlM);
  const rfM=new THREE.Mesh(new THREE.BoxGeometry(.14,.07,.22),veryDark);
  rfM.position.set(0,-.65,.04); rlG.add(rfM);
  g.add(rlG);
  // Ambient flicker light on monster
  const ml=new THREE.PointLight(0x660000,3,18); ml.position.y=1; g.add(ml); ml.userData.flick=true;
  g.position.set(mon.x,0,mon.z);
  scene3d.add(g);
  mon.group=g; mon.laG=laG; mon.raG=raG; mon.llG=llG; mon.rlG=rlG; mon.headRef=head; mon.eL=eL;
  botMeshes.push(g);
  bots3d.push(mon);
}

function spawnTargets(n){
  targets3d.forEach(t=>{if(t.mesh)scene3d.remove(t.mesh);}); targets3d=[];
  for(let i=0;i<n;i++) spawnOneTarget();
}

function spawnOneTarget(){
  const colors=[0xff1744,0xff9100,0xffd740,0x00e676,0x00b0ff,0xd500f9];
  const c=colors[Math.floor(Math.random()*colors.length)];
  const size=S.opts.diff==='ultra'?.1:S.opts.diff==='hard'?.18:.28;
  const mesh=new THREE.Mesh(new THREE.SphereGeometry(size,12,12),new THREE.MeshStandardMaterial({color:c,emissive:c,emissiveIntensity:.6,roughness:.3}));
  const startX=(Math.random()-.5)*20;
  const startZ=(Math.random()-.5)*14-5;
  mesh.position.set(startX,Math.random()*3+.8,startZ);
  mesh.userData.phase=Math.random()*Math.PI*2;
  // Point light for glow
  const pl=new THREE.PointLight(c,1.5,3);
  mesh.add(pl);
  scene3d.add(mesh);
  const spd=S.opts.diff==='ultra'?0.07:S.opts.diff==='insane'?0.05:S.opts.diff==='hard'?0.03:0.01;
  const t={mesh,hit:false,spd,dy:(Math.random()-.5)*spd*1.2};
  targets3d.push(t);
}

// ═══════════════════════════════════════
// NICKNAME SYSTEM
// ═══════════════════════════════════════
function updateNickLabels(){
  const layer=document.getElementById('nick-layer');
  if(!layer||!cam3d||!ren3d) return;
  layer.innerHTML='';
  const w=window.innerWidth, h=window.innerHeight;
  // Player nickname
  const playerNickPos=projectToScreen(player3d.x,player3d.y+2.2,player3d.z);
  if(playerNickPos){
    const d=document.createElement('div');
    d.className='overhead-nick player-nick';
    d.textContent=S.user||'Jogador';
    d.style.left=playerNickPos.x+'px'; d.style.top=playerNickPos.y+'px';
    layer.appendChild(d);
  }
  // Bot nicknames
  bots3d.forEach((bot,i)=>{
    if(!bot.group||bot.isMonster) return;
    const bpos=projectToScreen(bot.x,bot.y+2.4,bot.z);
    if(!bpos) return;
    const d=document.createElement('div');
    d.className='overhead-nick bot-nick';
    d.textContent='Bot#'+(i+1);
    d.style.left=bpos.x+'px'; d.style.top=bpos.y+'px';
    layer.appendChild(d);
  });
}
function projectToScreen(wx,wy,wz){
  if(!cam3d) return null;
  const v=new THREE.Vector3(wx,wy,wz);
  v.project(cam3d);
  if(v.z>1||v.z<-1) return null;
  return {x:(v.x*.5+.5)*window.innerWidth, y:(-.5*v.y+.5)*window.innerHeight};
}

// ═══════════════════════════════════════
// BALL IN HAND (BASKETBALL)
// ═══════════════════════════════════════
let ballHeld=false, ballHeldTimer=0, ballCooldown=0;
let kickCharging=false, kickPower=0, kickPowerDir=1;
const KICK_CHARGE_SPEED=0.022; // 0→1 per frame

function tryGrabBall(){
  if(!ballMesh||ballHeld||ballCooldown>0) return;
  const bdx=ball3d.x-player3d.x, bdz=ball3d.z-player3d.z;
  if(Math.sqrt(bdx*bdx+bdz*bdz)<1.5){
    ballHeld=true; ball3d.vx=0; ball3d.vy=0; ball3d.vz=0;
    const ind=document.getElementById('ball-held-ind');
    if(ind) ind.style.display='block';
    playSound('grab');
  }
}
// Called every frame when F is held down (charging)
function updateKickCharge(){
  if(!ballHeld||!kickCharging) return;
  kickPower=Math.min(1, kickPower+KICK_CHARGE_SPEED);
  const pm=document.getElementById('pm-bar');
  if(pm){
    pm.style.width=(kickPower*100)+'%';
    const r=Math.min(255,Math.floor(kickPower*2*255));
    const g2=Math.min(255,Math.floor((1-kickPower)*2*255));
    pm.style.background=`rgb(${r},${g2},0)`;
  }
  // Crosshair muda de cor conforme carrega
  const cx=document.getElementById('hud-cross');
  if(cx){
    cx.classList.add('sport-aim');
    if(kickPower>0.5) cx.classList.add('charged');
    else cx.classList.remove('charged');
    // Escala o crosshair com a força
    const sc=1+kickPower*0.5;
    cx.style.transform=`translate(-50%,-50%) scale(${sc})`;
  }
  if(kickPower>=1) releaseKick();
}
function releaseKick(){
  // Snapshot before clearing
  const wasHeld=ballHeld;
  const power=Math.max(0.12, kickPower);
  const g=S.game||GAMES_DATA[0];

  // Clear all state first — set cooldown so ball isn't re-grabbed instantly
  ballHeld=false; kickCharging=false; kickPower=0;
  ballCooldown=90; // ~1.5 segundos a 60fps
  const ind=document.getElementById('ball-held-ind'); if(ind) ind.style.display='none';
  const pw=document.getElementById('power-meter-wrap'); if(pw) pw.classList.remove('on');
  const pmb=document.getElementById('pm-bar'); if(pmb){pmb.style.width='0%'; pmb.style.background='';}
  // Reset crosshair
  const cx2=document.getElementById('hud-cross');
  if(cx2){cx2.classList.remove('charged'); cx2.style.transform='translate(-50%,-50%) scale(1)';}

  if(!wasHeld) return;

  // Use camera look direction (yaw + pitch) so ball goes where player is aiming
  const yaw=player3d.yaw, pitch=player3d.pitch;
  const lookX=Math.sin(yaw)*Math.cos(pitch);
  const lookZ=Math.cos(yaw)*Math.cos(pitch);
  const lookY=Math.sin(pitch);

  if(g.id==='basketball'){
    // Basketball: arremesso na direção do crosshair com arco
    // Quanto mais power, mais força. Sempre tem vy mínima para arco
    const spd=0.30+power*0.50;
    ball3d.vx=lookX*spd;
    ball3d.vz=lookZ*spd;
    // Ensure upward arc even if aiming straight
    ball3d.vy=Math.max(0.28, lookY*spd + 0.18 + power*0.20);
    playSound('throw');
  } else {
    // Futebol: chuta na direção do crosshair
    // Fraco=2, força total=10 — velocidade real por frame (60fps)
    const spd=2.0 + power*8.0;
    ball3d.vx=lookX*spd;
    ball3d.vz=lookZ*spd;
    ball3d.vy=Math.max(0.05, lookY*spd + 0.06 + power*0.4);
    playSound('kick');
  }
}

// Check basketball score each frame
function checkBasketScore(){
  if(!ballMesh||S.game?.id!=='basketball') return;
  // hoops: {x, z, team} — team=1 is player's scoring hoop (at x=17), team=0 is bot's (at x=-17)
  const hoops=[{x:17,z:0,team:1},{x:-17,z:0,team:0}];
  hoops.forEach(hoop=>{
    const dx=ball3d.x-hoop.x, dz=ball3d.z-hoop.z;
    const dy=ball3d.y-4.1; // hoop ring height
    const radialDist=Math.sqrt(dx*dx+dz*dz);
    // Ball must pass through the ring from above (downward arc)
    if(radialDist<0.55&&Math.abs(dy)<0.45&&ball3d.vy<0){
      if(hoop.team===1){
        // Player scored!
        const pts=2; scoreL+=pts;
        showScorePopup('+'+pts+' CESTA!');
        showGolOverlay('player'); spawnGoalParticles3D();
        addHudChat('Sistema','CESTA! +'+pts+' pontos!','sys');
        playSound('goal');
      } else {
        // Bot scored
        scoreR+=2; showScorePopup('Bot +2'); flashHit();
        addHudChat('Sistema','Bot marcou! Defenda!','sys');
      }
      ball3d={x:0,y:1.5,z:0,vx:0,vy:0.12,vz:0}; updateHUD();
    }
  });
}

// ═══════════════════════════════════════
// HACKER EVENT
// ═══════════════════════════════════════
let hackerEventDone=false;
function scheduleHackerEvent(){
  if(hackerEventDone) return;
  const delay=20000+Math.random()*30000; // 20-50 seconds in
  setTimeout(()=>{
    if(!S.running||hackerEventDone) return;
    hackerEventDone=true;
    runHackerEvent();
  }, delay);
}
function runHackerEvent(){
  const isDC=S.game?.id==='dreamcore';
  // Phase 1: hacker joins
  setTimeout(()=>{
    const hMsg=document.getElementById('hud-chatmsgs');
    if(!hMsg) return;
    addHudChatRaw('<span class="hacker-name">▶ xX_H4CK3R_Xx entrou na partida</span>','sys');
  }, 0);
  setTimeout(()=>addHudChatRaw('<span class="hacker-name">xX_H4CK3R_Xx</span><span style="color:#ff0032"> : eheheh sistema fraco detectado...</span>','hack'),1500);
  setTimeout(()=>addHudChatRaw('<span class="hacker-name">xX_H4CK3R_Xx</span><span style="color:#ff0032"> : iniciando bypass... ████░░░░ 50%</span>','hack'),3000);
  setTimeout(()=>addHudChatRaw('<span class="hacker-name">xX_H4CK3R_Xx</span><span style="color:#ff0032"> : ██████░░ 75%... quase lá</span>','hack'),5000);
  setTimeout(()=>addHudChatRaw('<span class="hacker-name">xX_H4CK3R_Xx</span><span style="color:#ff0032"> : ████████ 100% — KICK INICIADO</span>','hack'),7000);
  // Phase 2: screen glitch effect
  setTimeout(()=>{
    if(isDC){
      const ov=document.getElementById('dreamcore-overlay');
      if(ov) ov.style.filter='hue-rotate(180deg) saturate(3)';
    }
    // Glitch HUD
    const hud=document.getElementById('hud');
    if(hud){ hud.style.filter='hue-rotate(200deg)'; hud.style.animation='none'; }
    toast('⚠ CONEXÃO INSTÁVEL...','warn');
  }, 8000);
  setTimeout(()=>{
    addHudChatRaw('<span style="color:#ff0032;font-weight:700">▶ [SISTEMA] Você foi kickado por: xX_H4CK3R_Xx</span>','hack');
  }, 9500);
  // Phase 3: kick screen
  setTimeout(()=>{
    if(isDC){
      const banner=document.getElementById('dc-kick-banner');
      const msg=document.getElementById('dc-kick-msg');
      if(banner) banner.classList.add('on');
      if(msg) msg.textContent='Motivo: Sua Internet e fraca';
    } else {
      // Show full-screen kick overlay
      showKickScreen('Sua Internet e fraca');
    }
    S.running=false;
  }, 10500);
}
function addHudChatRaw(html,type){
  const msgs=document.getElementById('hud-chatmsgs');
  if(!msgs) return;
  const d=document.createElement('div');
  d.className='cmsg hacker-msg';
  d.innerHTML=html;
  msgs.appendChild(d);
  msgs.scrollTop=99999;
}
function showKickScreen(reason){
  const layer=document.getElementById('score-layer');
  if(!layer) return;
  const wrap=document.createElement('div');
  wrap.style.cssText='position:absolute;inset:0;background:rgba(0,0,0,.95);display:flex;flex-direction:column;align-items:center;justify-content:center;z-index:30';
  wrap.innerHTML=`
    <div style="font-family:var(--fm);font-size:2.2rem;color:#ff0032;text-shadow:0 0 20px #ff0032;margin-bottom:14px;animation:flick .3s infinite alternate">VOCÊ FOI KICKADO</div>
    <div style="font-family:var(--fm);font-size:1rem;color:#888;margin-bottom:30px">Motivo: <span style="color:#fff">${reason}</span></div>
    <button class="btn btn-r btn-lg" onclick="exitGame3d()">Voltar ao Lobby</button>`;
  layer.appendChild(wrap);
}

// ═══════════════════════════════════════
// DREAMCORE 16-BIT SCENE
// ═══════════════════════════════════════
function buildDreamCoreScene(){
  // Pixelated/16-bit 3D world
  scene3d.background=new THREE.Color(0x000820);
  scene3d.fog=new THREE.Fog(0x000820,12,60);
  // Pixelated ambient
  scene3d.add(new THREE.AmbientLight(0x002244,1.5));
  const dl=new THREE.DirectionalLight(0x44aaff,1.2);
  dl.position.set(5,10,5); scene3d.add(dl);
  // 16-bit style flat-color ground
  const palettes=[0x000820,0x001840,0x002060,0x0040a0];
  // Chunky pixel-like terrain
  for(let x=-8;x<=8;x++){
    for(let z=-8;z<=8;z++){
      const h=Math.round(Math.sin(x*.7)*Math.cos(z*.5)*.8+Math.random()*.3)*1;
      const col=palettes[Math.min(3,Math.floor((h+2)/1.2))];
      const block=new THREE.Mesh(
        new THREE.BoxGeometry(2,1+h*.5,2),
        new THREE.MeshLambertMaterial({color:col}) // MeshLambertMaterial = flat 16-bit look
      );
      block.position.set(x*2,h*.25,z*2); scene3d.add(block);
    }
  }
  // Pixel "trees" — just colored boxes
  const treeColors=[0x006600,0x004400,0x008800,0x00aa00];
  for(let i=0;i<12;i++){
    const a=Math.random()*Math.PI*2, r=6+Math.random()*8;
    const trunk=new THREE.Mesh(new THREE.BoxGeometry(.5,2,.5),new THREE.MeshLambertMaterial({color:0x442200}));
    trunk.position.set(Math.cos(a)*r,1,Math.sin(a)*r); scene3d.add(trunk);
    const top=new THREE.Mesh(new THREE.BoxGeometry(1.5,1.5,1.5),new THREE.MeshLambertMaterial({color:treeColors[i%4]}));
    top.position.set(Math.cos(a)*r,2.75,Math.sin(a)*r); scene3d.add(top);
  }
  // Pixel coins/items
  S.adventureItems=[];
  for(let i=0;i<10;i++){
    const a=Math.random()*Math.PI*2, r=3+Math.random()*8;
    const coin=new THREE.Mesh(new THREE.BoxGeometry(.5,.5,.5),new THREE.MeshLambertMaterial({color:0xffd700,emissive:0xffaa00}));
    coin.position.set(Math.cos(a)*r,1.5,Math.sin(a)*r);
    scene3d.add(coin);
    const il=new THREE.PointLight(0xffd700,2,3); il.position.copy(coin.position); scene3d.add(il);
    S.adventureItems.push({mesh:coin,light:il,collected:false});
  }
  // Pixel castle in distance
  [0,1,2].forEach(i=>{
    const tower=new THREE.Mesh(new THREE.BoxGeometry(3,8+i*2,3),new THREE.MeshLambertMaterial({color:0x334488}));
    tower.position.set(-12+i*2,4+i,-14); scene3d.add(tower);
    const top2=new THREE.Mesh(new THREE.BoxGeometry(3,2,3),new THREE.MeshLambertMaterial({color:0x5566aa}));
    top2.position.set(-12+i*2,9+i,-14); scene3d.add(top2);
  });
  // Pixel NPC bots with flat materials
  spawnDreamCoreBots(4);
  player3d={x:0,y:1.5,z:4,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI,pitch:0};
  // Enable DreamCore overlay
  const ov=document.getElementById('dreamcore-overlay');
  if(ov) ov.classList.add('on');
  addHudChat('Sistema','BEM-VINDO AO DREAMCORE 16-BIT! Colete os cubos dourados. F para pegar.','sys');
  document.getElementById('hud-kills').textContent='COINS: 0/10';
  // Schedule hacker event for DreamCore
  hackerEventDone=false;
  scheduleHackerEvent();
}

function spawnDreamCoreBots(n){
  bots3d=[]; botMeshes.forEach(m=>scene3d.remove(m)); botMeshes=[];
  const diffSpd=S.opts.diff==='ultra'?0.13:S.opts.diff==='insane'?0.09:S.opts.diff==='hard'?0.06:0.04;
  for(let i=0;i<n;i++){
    const bc=new THREE.Color([0xff2200,0x0088ff,0xff9900,0x00ff44][i%4]);
    const g=new THREE.Group();
    // Flat/blocky 16-bit humanoid
    const torso=new THREE.Mesh(new THREE.BoxGeometry(.6,.8,.4),new THREE.MeshLambertMaterial({color:bc}));
    torso.position.y=1.2; g.add(torso);
    const head=new THREE.Mesh(new THREE.BoxGeometry(.5,.5,.5),new THREE.MeshLambertMaterial({color:0xffcc88}));
    head.position.y=1.85; g.add(head);
    // Pixel eyes
    const eyeM=new THREE.MeshLambertMaterial({color:0x000000});
    const le=new THREE.Mesh(new THREE.BoxGeometry(.1,.1,.05),eyeM); le.position.set(-.12,1.9,.26); g.add(le);
    const re=new THREE.Mesh(new THREE.BoxGeometry(.1,.1,.05),eyeM); re.position.set(.12,1.9,.26); g.add(re);
    const laG=new THREE.Group(); laG.position.set(-.4,1.2,0);
    laG.add(new THREE.Mesh(new THREE.BoxGeometry(.2,.7,.2),new THREE.MeshLambertMaterial({color:bc}))); g.add(laG);
    const raG=new THREE.Group(); raG.position.set(.4,1.2,0);
    raG.add(new THREE.Mesh(new THREE.BoxGeometry(.2,.7,.2),new THREE.MeshLambertMaterial({color:bc}))); g.add(raG);
    const llG=new THREE.Group(); llG.position.set(-.15,.75,0);
    llG.add(new THREE.Mesh(new THREE.BoxGeometry(.22,.7,.22),new THREE.MeshLambertMaterial({color:0x001133}))); g.add(llG);
    const rlG=new THREE.Group(); rlG.position.set(.15,.75,0);
    rlG.add(new THREE.Mesh(new THREE.BoxGeometry(.22,.7,.22),new THREE.MeshLambertMaterial({color:0x001133}))); g.add(rlG);
    const ax=(Math.random()-.5)*12, az=(Math.random()-.5)*12;
    g.position.set(ax,0,az); scene3d.add(g);
    const botData={x:ax,y:0,z:az,vx:0,vz:0,hp:100,spd:diffSpd,team:i%2,walkT:Math.random()*6,
      targetX:0,targetZ:0,shootCd:0,group:g,laG,raG,llG,rlG,headRef:head,
      // Pro AI state
      state:'patrol', patrolTarget:{x:(Math.random()-.5)*14, z:(Math.random()-.5)*14},
      aggroRange:12, flankTimer:0, strafeDir:1, retreatHp:30, lastPlayerX:0, lastPlayerZ:0};
    bots3d.push(botData);
    botMeshes.push(g);
  }
}

// ═══════════════════════════════════════
// EXPANDED RACE TRACK
// ═══════════════════════════════════════
function buildRaceSceneExpanded(){
  scene3d.background=new THREE.Color(0x040010);
  scene3d.fog=new THREE.Fog(0x040010,30,200);
  addLights(0x220044,0.9);
  // Much larger track — 200 units long, 20 wide
  const trackMat=new THREE.MeshStandardMaterial({color:0x151525,roughness:1});
  const track=new THREE.Mesh(new THREE.PlaneGeometry(200,20),trackMat);
  track.rotation.x=-Math.PI/2; track.receiveShadow=true; scene3d.add(track); groundMesh=track;
  // Lane dividers
  for(let i=-48;i<100;i+=5){
    const line=new THREE.Mesh(new THREE.BoxGeometry(.15,.01,4),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.3}));
    line.position.set(i,.01,0); scene3d.add(line);
  }
  // Side lines
  [-9.5,9.5].forEach(z=>{
    const sl=new THREE.Mesh(new THREE.BoxGeometry(200,.01,.15),new THREE.MeshBasicMaterial({color:0xffffff,transparent:true,opacity:.5}));
    sl.position.set(0,.01,z); scene3d.add(sl);
  });
  // Red/white barriers
  for(let i=-98;i<100;i+=4){
    [10.5,-10.5].forEach(z=>{
      const bar=new THREE.Mesh(new THREE.BoxGeometry(3.5,.8,.3),new THREE.MeshStandardMaterial({color:Math.floor(i/4)%2===0?0xff1744:0xffffff,roughness:.6}));
      bar.position.set(i,.4,z); scene3d.add(bar);
    });
  }
  // Grandstands (both sides)
  [-14,14].forEach(z=>{
    const gs=new THREE.Mesh(new THREE.BoxGeometry(160,4,.5),new THREE.MeshStandardMaterial({color:0x112233,roughness:.9}));
    gs.position.set(0,2,z); scene3d.add(gs);
    for(let c=0;c<120;c++){
      const cr=new THREE.Mesh(new THREE.SphereGeometry(.18,4,4),new THREE.MeshBasicMaterial({color:PCOLORS[Math.floor(Math.random()*PCOLORS.length)]}));
      cr.position.set((Math.random()-.5)*158,(Math.random()*2+.5),z+(z>0?-.4:.4)); scene3d.add(cr);
    }
  });
  // Pit lane buildings
  for(let i=-3;i<=3;i++){
    const build=new THREE.Mesh(new THREE.BoxGeometry(6,4,4),new THREE.MeshStandardMaterial({color:0x0a0a20,roughness:.8}));
    build.position.set(i*12,2,-16); scene3d.add(build);
    const sign=new THREE.Mesh(new THREE.BoxGeometry(5,.8,.1),new THREE.MeshStandardMaterial({color:new THREE.Color(PCOLORS[Math.abs(i)%PCOLORS.length]),emissive:new THREE.Color(PCOLORS[Math.abs(i)%PCOLORS.length]),emissiveIntensity:.3}));
    sign.position.set(i*12,4.4,-14.1); scene3d.add(sign);
  }
  // Neon track lights
  for(let i=-48;i<100;i+=12){
    const nl=new THREE.PointLight(0x4400ff,2,20);
    nl.position.set(i,4,(i%24===0?-11:11)); scene3d.add(nl);
  }
  // Start/finish line
  const sf=new THREE.Mesh(new THREE.BoxGeometry(.4,.01,20),new THREE.MeshBasicMaterial({color:0xffffff}));
  sf.position.set(-90,.01,0); scene3d.add(sf);
  // Checkpoint markers
  [-30,20,70].forEach(x=>{
    const cp=new THREE.Mesh(new THREE.BoxGeometry(.2,.01,20),new THREE.MeshBasicMaterial({color:0xffd740,transparent:true,opacity:.6}));
    cp.position.set(x,.01,0); scene3d.add(cp);
    const cpl=new THREE.PointLight(0xffd740,2,10); cpl.position.set(x,3,0); scene3d.add(cpl);
  });
  spawnRaceCarsExpanded();
  player3d={x:-94,y:.6,z:-3,vx:0,vz:0,vy:0,onGround:true,yaw:Math.PI/2,pitch:0};
  addHudChat('Sistema','CORRIDA ABERTA! Pista de 200m com 3 checkpoints. Chega ao fim e volta!','sys');
}

function spawnRaceCarsExpanded(){
  bots3d=[]; botMeshes.forEach(m=>scene3d.remove(m)); botMeshes=[];
  const carColors=[0xff1744,0x2196f3,0x00e676,0xffd740,0xd500f9,0xff9100,0x00bcd4,0xf44336];
  const spd=S.opts.diff==='ultra'?.26:S.opts.diff==='insane'?.20:S.opts.diff==='hard'?.15:.10;
  const count=S.opts.diff==='ultra'?7:S.opts.diff==='insane'?5:4;
  for(let i=0;i<count;i++){
    const col=carColors[i%carColors.length];
    const car=new THREE.Group();
    const body=new THREE.Mesh(new THREE.BoxGeometry(2.8,.5,1.4),new THREE.MeshStandardMaterial({color:col,roughness:.3,metalness:.5}));
    body.position.y=.45; car.add(body);
    const roof=new THREE.Mesh(new THREE.BoxGeometry(1.2,.35,1.1),new THREE.MeshStandardMaterial({color:col,roughness:.3,metalness:.5}));
    roof.position.set(.1,.75,0); car.add(roof);
    [[1,.15,.7],[-1,.15,.7],[1,.15,-.7],[-1,.15,-.7]].forEach(([x,y,z])=>{
      const wheel=new THREE.Mesh(new THREE.CylinderGeometry(.28,.28,.18,12),new THREE.MeshStandardMaterial({color:0x111111,roughness:.9}));
      wheel.rotation.z=Math.PI/2; wheel.position.set(x,y,z); car.add(wheel);
    });
    const hl1=new THREE.PointLight(0xffffaa,2,6); hl1.position.set(1.4,.5,.45); car.add(hl1);
    const hl2=new THREE.PointLight(0xffffaa,2,6); hl2.position.set(1.4,.5,-.45); car.add(hl2);
    car.position.set(-90,.3,-4+(i*1.4));
    car.rotation.y=Math.PI/2;
    // Pro racing AI: variable speed, draft boost, avoid collisions
    const botData={x:-90,y:.3,z:-4+(i*1.4),vx:0,vz:0,hp:100,spd,team:0,walkT:i*.8,
      group:car,isCar:true,lapProgress:0,
      racingSpd: spd*(0.88+Math.random()*.24), // variation per car
      draftBoost:0, wobble:i*.5};
    scene3d.add(car); botMeshes.push(car); bots3d.push(botData);
  }
}

function botShootAtTarget(bot,tx,tz,spd){
  const dx=tx-bot.x, dy=player3d.y-bot.y-1, dz=tz-bot.z;
  const len=Math.sqrt(dx*dx+dy*dy+dz*dz);
  const bullet=new THREE.Mesh(new THREE.SphereGeometry(.05,4,4),new THREE.MeshBasicMaterial({color:0xff8800}));
  bullet.position.set(bot.x,1.1,bot.z);
  bullet.userData={vx:dx/len*spd,vy:dy/len*spd,vz:dz/len*spd,life:2,fromBot:true};
  scene3d.add(bullet); bullets3d.push(bullet);
}

function botTick3D(){
  if(!S.running||S.paused) return;
  const g=S.game||GAMES_DATA[0];
  const t=performance.now()*.001;
  // Per-frame delta speed (loop runs ~60fps)
  const frameSpd=S.opts.diff==='ultra'?0.07:S.opts.diff==='insane'?0.048:S.opts.diff==='hard'?0.030:0.016;

  bots3d.forEach((bot,idx)=>{
    if(!bot.group) return;
    const dx=player3d.x-bot.x, dz=player3d.z-bot.z;
    const dist=Math.sqrt(dx*dx+dz*dz);
    let targetX=bot.x, targetZ=bot.z;
    let isMoving=false;

    // ─── RACING BOT ───
    if(bot.isCar){
      bot.draftBoost=Math.max(0,(bot.draftBoost||0)-.001);
      bots3d.forEach(other=>{
        if(other===bot||!other.isCar) return;
        const od=other.x-bot.x;
        if(od>0&&od<4.5&&Math.abs(other.z-bot.z)<1.5) bot.draftBoost=0.022;
      });
      const curSpd=(bot.racingSpd||bot.spd)+bot.draftBoost;
      bot.x+=curSpd*(1+Math.sin((bot.wobble||0)*.12)*.08);
      if(bot.x>96){ bot.x=-92; showScorePopup('Bot Lap!'); }
      const avZ=bot.z-player3d.z;
      if(Math.abs(avZ)<2.2&&Math.abs(bot.x-player3d.x)<6) bot.z+=avZ>0?.07:-.07;
      bots3d.forEach(other=>{
        if(other===bot||!other.isCar) return;
        const oz=other.z-bot.z;
        if(Math.abs(oz)<1.6&&Math.abs(other.x-bot.x)<4) bot.z+=oz>0?-.05:.05;
      });
      const laneZ=-1+(idx%3)*1.8;
      bot.z+=(laneZ-bot.z)*.012;
      bot.z=Math.max(-8.5,Math.min(8.5,bot.z));
      bot.group.position.set(bot.x,bot.y,bot.z);
      bot.group.rotation.y=Math.PI/2;
      bot.group.children.forEach(c=>{ if(c.geometry?.type==='CylinderGeometry') c.rotation.x+=curSpd*1.5; });
      return;
    }

    // ─── MONSTER ───
    if(bot.isMonster){
      if(dist>20){
        if(!bot.wanderX||Math.random()<.005){ bot.wanderX=(Math.random()-.5)*20; bot.wanderZ=(Math.random()-.5)*20; }
        targetX=bot.wanderX; targetZ=bot.wanderZ;
      } else {
        targetX=player3d.x+player3d.vx*10;
        targetZ=player3d.z+player3d.vz*10;
      }
      if(dist<18&&!bot.alerted){ bot.alerted=true; addHudChat('Sistema','⚠ O MONSTRO TE DETECTOU!','sys'); }
      isMoving=true;
    }
    // ─── PARKOUR BOT ───
    else if(bot.isParkourBot){
      // Parkour bot follows course
      const platforms=bot.platforms||[];
      const nextIdx=Math.min((bot.platIdx||0)+1,platforms.length-1);
      const ptarget=platforms[nextIdx]||{x:0,y:0,z:0};
      const ptdx=ptarget.x-bot.x, ptdz=ptarget.z-bot.z;
      const ptdist=Math.sqrt(ptdx*ptdx+ptdz*ptdz);
      if(ptdist<.8){ bot.platIdx=nextIdx; }
      else { bot.x+=ptdx/ptdist*frameSpd*1.6; bot.z+=ptdz/ptdist*frameSpd*1.6; }
      bot.y=platforms[Math.min(bot.platIdx||0,platforms.length-1)].y+1;
      bot.group.position.set(bot.x,bot.y,bot.z);
      bot.group.rotation.y=Math.atan2(ptdx,ptdz);
      bot.walkT+=.15; isMoving=true;
      if(bot.laG) bot.laG.rotation.x=Math.sin(bot.walkT)*.4;
      if(bot.raG) bot.raG.rotation.x=-Math.sin(bot.walkT)*.4;
      return;
    }
    // ─── SURVIVAL ENEMY ───
    else if(bot.isSurvivalEnemy){
      bot.flankTimer=(bot.flankTimer||0)-1;
      if(bot.flankTimer<=0||!bot.flankTarget){
        const ang=Math.atan2(dx,dz)+(.5+Math.random()*.7)*(bot.flankSide||1);
        bot.flankTarget={x:player3d.x+Math.sin(ang)*3,z:player3d.z+Math.cos(ang)*3};
        bot.flankTimer=50+Math.floor(Math.random()*60);
        bot.flankSide=(bot.flankSide||1)*-1;
      }
      targetX=dist<5?bot.flankTarget.x:player3d.x;
      targetZ=dist<5?bot.flankTarget.z:player3d.z;
      isMoving=dist>1.2;
      bot.shootCd=(bot.shootCd||80)-1;
      if(bot.shootCd<=0&&dist<14){
        botShootAtPlayer(bot,S.opts.diff==='ultra'?1.8:1.2);
        bot.shootCd=S.opts.diff==='ultra'?30:S.opts.diff==='hard'?55:90;
      }
    }
    // ─── SPORTS BOT ───
    else if(g.id==='football'||g.id==='basketball'){
      const bdx=ball3d.x-bot.x, bdz=ball3d.z-bot.z;
      const bdist=Math.sqrt(bdx*bdx+bdz*bdz);
      const roleIdx=idx%3;
      if(bot.team===0){
        if(roleIdx===0){ targetX=ball3d.x; targetZ=ball3d.z; }
        else if(roleIdx===1){ targetX=ball3d.x*.6; targetZ=ball3d.z*.6; }
        else { targetX=14; targetZ=(Math.sin(t+idx))*4; }
      } else {
        if(roleIdx===0){ targetX=-16; targetZ=ball3d.z*.7; }
        else { if(bdist<8){targetX=ball3d.x;targetZ=ball3d.z;}else{targetX=-12;targetZ=(Math.random()-.5)*6;} }
      }
      isMoving=true;
      if(bdist<1.4&&!ballHeld){
        const goalDir=bot.team===0?1:-1;
        if(g.id==='basketball'){
          const hoopX=bot.team===0?17:-17;
          const hdx=hoopX-bot.x, hdz=-bot.z;
          const hd=Math.max(.1,Math.sqrt(hdx*hdx+hdz*hdz));
          ball3d.vx=hdx/hd*0.38; ball3d.vz=hdz/hd*0.38; ball3d.vy=0.58;
        } else {
          ball3d.vx=goalDir*(frameSpd*220+2.2);
          ball3d.vz=(Math.random()-.5)*2.5;
          ball3d.vy=.38;
          // Triple if player nearby
          if(dist<5&&S.opts.diff!=='easy'){
            const pz=player3d.z>bot.z?.5:-.5;
            ball3d.vz+=pz*3;
          }
        }
      }
    }
    // ─── COMBAT / PVP ───
    else if(g.id==='pvp'||g.id==='escape'||g.id==='labyrinth'){
      if(!bot.state) bot.state='patrol';
      if(dist>18){
        bot.state='patrol';
        if(!bot.wanderX||Math.random()<.007||Math.sqrt((bot.wanderX-bot.x)**2+(bot.wanderZ-bot.z)**2)<1.5){
          bot.wanderX=(Math.random()-.5)*22; bot.wanderZ=(Math.random()-.5)*22;
        }
        targetX=bot.wanderX; targetZ=bot.wanderZ;
      } else if((bot.hp||100)<(bot.retreatHp||30)&&dist>4){
        bot.state='retreat';
        targetX=bot.x-(dx/dist)*4;
        targetZ=bot.z-(dz/dist)*4;
        bot.hp=Math.min(100,(bot.hp||100)+.06);
      } else if(dist<5){
        bot.state='combat';
        bot.strafeTimer=(bot.strafeTimer||0)-1;
        if(bot.strafeTimer<=0){ bot.strafeDir=(bot.strafeDir||1)*-1; bot.strafeTimer=40+Math.floor(Math.random()*45); }
        const perpX=-dz/dist*bot.strafeDir, perpZ=dx/dist*bot.strafeDir;
        targetX=player3d.x+perpX*2.5; targetZ=player3d.z+perpZ*2.5;
      } else {
        bot.state='engage';
        const fla=Math.atan2(dx,dz)+((bot.team||0)===0?.6:-.6);
        targetX=player3d.x+Math.sin(fla)*2.5; targetZ=player3d.z+Math.cos(fla)*2.5;
      }
      isMoving=true;
      if(dist<14&&g.id==='pvp'){
        bot.shootCd=(bot.shootCd||0)-1;
        if(bot.shootCd<=0){
          const leadX=player3d.x+player3d.vx*7, leadZ=player3d.z+player3d.vz*7;
          botShootAtTarget(bot,leadX,leadZ,S.opts.diff==='ultra'?2.2:S.opts.diff==='hard'?1.6:1.1);
          bot.shootCd=S.opts.diff==='ultra'?25:S.opts.diff==='hard'?50:100;
        }
      }
    }
    // ─── DREAMCORE PRO AI ───
    else if(g.id==='dreamcore'){
      if(!bot.state) bot.state='patrol';
      if(dist>14){
        bot.state='patrol';
        if(!bot.patrolTarget||Math.sqrt((bot.patrolTarget.x-bot.x)**2+(bot.patrolTarget.z-bot.z)**2)<1.2){
          bot.patrolTarget={x:(Math.random()-.5)*14,z:(Math.random()-.5)*14};
        }
        targetX=bot.patrolTarget.x; targetZ=bot.patrolTarget.z;
      } else {
        bot.state='intercept';
        targetX=player3d.x+player3d.vx*12;
        targetZ=player3d.z+player3d.vz*12;
      }
      isMoving=true;
    }
    // ─── AIMLAB ───
    else if(g.id==='aimlab'){
      if(!bot.wanderX||Math.random()<.012){ bot.wanderX=(Math.random()-.5)*16; bot.wanderZ=(Math.random()-.5)*8; }
      targetX=bot.wanderX; targetZ=bot.wanderZ; isMoving=true;
    }
    // ─── DEFAULT ───
    else {
      if(dist<20){targetX=player3d.x;targetZ=player3d.z;isMoving=dist>2;}
      else{if(!bot.wanderX||Math.random()<.008){bot.wanderX=(Math.random()-.5)*20;bot.wanderZ=(Math.random()-.5)*20;}targetX=bot.wanderX;targetZ=bot.wanderZ;isMoving=true;}
    }

    // ─── SMOOTH MOVEMENT with velocity lerp ───
    if(isMoving){
      const tdx=targetX-bot.x, tdz=targetZ-bot.z;
      const tdist=Math.sqrt(tdx*tdx+tdz*tdz);
      if(tdist>.25){
        const desVx=tdx/tdist*frameSpd*bot.spd;
        const desVz=tdz/tdist*frameSpd*bot.spd;
        bot.vx=(bot.vx||0)*.72+desVx*.28;
        bot.vz=(bot.vz||0)*.72+desVz*.28;
        bot.x+=bot.vx; bot.z+=bot.vz;
        const targetRot=Math.atan2(bot.vx,bot.vz);
        bot.group.rotation.y=THREE.MathUtils.lerp(bot.group.rotation.y,targetRot,.14);
      } else { bot.vx=(bot.vx||0)*.8; bot.vz=(bot.vz||0)*.8; }
    } else { bot.vx=(bot.vx||0)*.75; bot.vz=(bot.vz||0)*.75; }

    bot.group.position.set(bot.x, isMoving?Math.abs(Math.sin(bot.walkT||0))*.04:0, bot.z);

    // Smooth limb animation — swim or walk
    bot.walkT=(bot.walkT||0)+(isMoving?.13:.025);
    const wt=bot.walkT, walkAmp=isMoving?.42:.05;
    if(bot.isSwimming){
      // Horizontal swimming pose
      if(bot.group) bot.group.rotation.z=Math.sin(wt*.5)*.1;
      if(bot.laG) bot.laG.rotation.z=Math.sin(wt)*1.1;
      if(bot.raG) bot.raG.rotation.z=-Math.sin(wt)*1.1;
      if(bot.llG) bot.llG.rotation.x=Math.sin(wt)*.8;
      if(bot.rlG) bot.rlG.rotation.x=-Math.sin(wt)*.8;
      // Float at water level
      bot.group.position.y=.1+Math.sin(wt*.3)*.08;
    } else {
      if(bot.laG) bot.laG.rotation.x=THREE.MathUtils.lerp(bot.laG.rotation.x,Math.sin(wt)*walkAmp,.25);
      if(bot.raG) bot.raG.rotation.x=THREE.MathUtils.lerp(bot.raG.rotation.x,-Math.sin(wt)*walkAmp,.25);
      if(bot.llG) bot.llG.rotation.x=THREE.MathUtils.lerp(bot.llG.rotation.x,-Math.sin(wt)*walkAmp*.8,.25);
      if(bot.rlG) bot.rlG.rotation.x=THREE.MathUtils.lerp(bot.rlG.rotation.x,Math.sin(wt)*walkAmp*.8,.25);
    }

    if(bot.headRef&&dist<12){
      const lookAngle=Math.atan2(dx,dz)-bot.group.rotation.y;
      bot.headRef.rotation.y=THREE.MathUtils.lerp(bot.headRef.rotation.y,THREE.MathUtils.clamp(lookAngle,-.7,.7),.1);
    }
    if(bot.isMonster&&bot.eL) bot.eL.intensity=2+Math.sin(t*8)*.5+Math.random()*.5;

    if(dist<1.4&&g.cat!=='Esportes'){
      S.hp=Math.max(0,S.hp-(.25+(S.opts.diff==='ultra'?.35:0)));
      document.getElementById('hud-hfill').style.width=S.hp+'%';
      if(S.hp<=0){endGame3D();return;}
      flashHit();
    }
  });

  // Ball physics (sports)
  if(ballCooldown>0) ballCooldown--;
  if(ballMesh&&!ballHeld){
    ball3d.vy-=.006; // gravity per frame (loop runs ~60fps)
    ball3d.x+=ball3d.vx; ball3d.y+=ball3d.vy; ball3d.z+=ball3d.vz;
    // Friction/air resistance
    ball3d.vx*=.982; ball3d.vy*=.999; ball3d.vz*=.982;
    // Ground bounce with realistic physics
    if(ball3d.y<.35){ball3d.y=.35; ball3d.vy*=-.48; ball3d.vx*=.86; ball3d.vz*=.86;}
    // Field boundaries — bigger field
    if(Math.abs(ball3d.x)>40){ball3d.vx*=-.6; ball3d.x=Math.sign(ball3d.x)*40;}
    if(Math.abs(ball3d.z)>26){ball3d.vz*=-.6; ball3d.z=Math.sign(ball3d.z)*26;}
    // Goal check — bigger goals at x=±38, width=7
    if(ball3d.x<-37&&Math.abs(ball3d.z)<3.5&&ball3d.y<3.5){
      scoreR++; addHudChat('Sistema','⚽ GOL do adversário! Cuidado na defesa!','sys');
      ball3d={x:0,y:.35,z:0,vx:0,vy:0,vz:0}; updateHUD();
      showGolOverlay('bot'); showScorePopup('GOOOL adversário!');
      flashHit(); playSound('goal');
    }
    if(ball3d.x>37&&Math.abs(ball3d.z)<3.5&&ball3d.y<3.5){
      scoreL++; addHudChat('Sistema','⚽ GOOOOOL! Você marcou!','sys');
      ball3d={x:0,y:.35,z:0,vx:0,vy:0,vz:0};
      showGolOverlay('player'); showScorePopup('GOOOOOL! ⚽');
      updateHUD(); spawnGoalParticles3D(); playSound('goal');
    }
    ballMesh.position.set(ball3d.x,ball3d.y,ball3d.z);
    // Realistic spinning based on velocity
    ballMesh.rotation.x+=ball3d.vz*.1;
    ballMesh.rotation.z-=ball3d.vx*.1;
  }

  // Aim lab targets animate
  targets3d.forEach(t=>{
    if(!t.mesh||t.hit) return;
    t.mesh.position.y+=t.dy;
    t.mesh.position.x+=Math.sin(performance.now()*.001*t.spd*3+t.mesh.userData.phase||0)*t.spd*.5;
    if(t.mesh.position.y>4.5||t.mesh.position.y<.4) t.dy*=-1;
    t.mesh.rotation.y+=.03; t.mesh.rotation.x+=.01;
  });

  // Survival: check wave cleared
  if(g.id==='survival'&&bots3d.length===0&&S.running){
    S.survivalWave=(S.survivalWave||1)+1;
    scoreL=S.survivalWave-1;
    showScorePopup(`ONDA ${S.survivalWave}!`);
    toast(`Onda ${S.survivalWave} começando!`,'ok');
    setTimeout(()=>{if(S.running) spawnSurvivalWave(S.survivalWave);},2500);
    updateHUD();
  }

  // Survival center pulse light
  if(g.id==='survival'){
    scene3d.children.forEach(c=>{if(c.userData.isPulse&&c.isLight) c.intensity=2+Math.sin(t*3)*1;});
  }

  // Adventure: animate items, check collection
  if(g.id==='adventure'&&S.adventureItems){
    let itemCount=0;
    S.adventureItems.forEach(item=>{
      if(item.collected) return;
      item.mesh.rotation.y+=.03; item.mesh.position.y=.5+Math.sin(t*2+item.mesh.position.x)*.2;
      if(item.light) item.light.position.copy(item.mesh.position);
      const dx=item.mesh.position.x-player3d.x, dz=item.mesh.position.z-player3d.z;
      const dist=Math.sqrt(dx*dx+dz*dz);
      if(dist<1.5||(keys3d['KeyF']&&dist<2.5)){
        item.collected=true; scene3d.remove(item.mesh); if(item.light) scene3d.remove(item.light);
        scoreL++; showScorePopup('+1 ITEM!'); spawnGoalParticles3D();
        document.getElementById('hud-kills').textContent=`ITENS: ${scoreL}/8`;
        if(scoreL>=8){addHudChat('Sistema','Todos os itens coletados! Vitória!','sys');endGame3D();}
        updateHUD();
      } else { itemCount++; }
    });
  }

  // Parkour: gravity + platform collision
  if(g.id==='parkour'){
    player3d.vy-=.012;
    player3d.y+=player3d.vy;
    let onPlat=false;
    const plats=scene3d.userData.platforms||[];
    plats.forEach(p=>{
      if(Math.abs(player3d.x-p.x)<p.w/2+.3&&Math.abs(player3d.z-p.z)<p.d/2+.3&&player3d.y>=p.y&&player3d.y<p.y+1.2){
        player3d.y=p.y+1; player3d.vy=0; player3d.onGround=true; onPlat=true;
      }
    });
    if(!onPlat&&player3d.y>1){ player3d.onGround=false; }
    if(player3d.y<-5){ // fell off
      S.hp=Math.max(0,S.hp-20); updateHUD(); flashHit();
      // Respawn at first platform
      if(plats.length>0){player3d.x=plats[0].x;player3d.y=plats[0].y+2;player3d.z=plats[0].z;player3d.vy=0;}
      if(S.hp<=0){endGame3D();return;}
      toast('Caiu! -20 HP','warn');
    }
    // Check finish
    const fd=scene3d.userData;
    if(fd.finishX&&Math.abs(player3d.x-fd.finishX)<3&&Math.abs(player3d.z-fd.finishZ)<3){
      scoreL++; showGolOverlay('player'); showScorePopup('CHEGOU! +1');
      addHudChat('Sistema','Você completou o parkour!','sys'); updateHUD();
      // Reset player to start
      if(plats.length>0){player3d.x=plats[0].x;player3d.y=plats[0].y+2;player3d.z=plats[0].z;player3d.vy=0;}
    }
  }

  // Horror flicker lights
  if(g.cat==='Terror'){
    scene3d.children.forEach(c=>{
      if(c.isLight&&c.userData.flick){
        c.intensity=Math.random()>0.05?(1.5+Math.random()*2.5):0;
      }
    });
  }
  updateHUD();
}

function botShootAtPlayer(bot,spd){
  const dx=player3d.x-bot.x, dy=player3d.y-bot.y-1, dz=player3d.z-bot.z;
  const len=Math.sqrt(dx*dx+dy*dy+dz*dz);
  // Spawn bullet
  const bullet=new THREE.Mesh(new THREE.SphereGeometry(.05,4,4),new THREE.MeshBasicMaterial({color:0xff8800,emissive:0xff4400}));
  bullet.position.set(bot.x,1.1,bot.z);
  bullet.userData={vx:dx/len*spd,vy:dy/len*spd,vz:dz/len*spd,life:2,fromBot:true};
  scene3d.add(bullet);
  bullets3d.push(bullet);
  // VFX flash on bot
  const fl=new THREE.PointLight(0xff8800,4,3);
  fl.position.set(bot.x,1.1,bot.z); scene3d.add(fl);
  setTimeout(()=>scene3d.remove(fl),80);
}

function loop3d(){
  raf=requestAnimationFrame(loop3d);
  if(!S.running||S.paused) return;
  movePlayer3D();
  updateCamera3D();
  updateParticles3D();
  updateBullets3D();
  updateMinimap();
  botTick3D();
  updateNickLabels();
  checkBasketScore();
  // DreamCore items
  const g2=S.game||GAMES_DATA[0];
  if((g2.id==='dreamcore'||g2.id==='adventure')&&S.adventureItems){
    const t2=performance.now()*.001;
    S.adventureItems.forEach(item=>{
      if(item.collected) return;
      item.mesh.rotation.y+=.04;
      item.mesh.position.y=1.2+Math.sin(t2*2+item.mesh.position.x)*.2;
      if(item.light) item.light.position.copy(item.mesh.position);
      const idx=item.mesh.position.x-player3d.x, idz=item.mesh.position.z-player3d.z;
      const idist=Math.sqrt(idx*idx+idz*idz);
      if(idist<1.8||(keys3d['KeyF']&&idist<2.8)){
        item.collected=true; scene3d.remove(item.mesh); if(item.light) scene3d.remove(item.light);
        scoreL++;
        const max=g2.id==='dreamcore'?10:8;
        showScorePopup(g2.id==='dreamcore'?'+1 COIN!':'+1 ITEM!'); spawnGoalParticles3D();
        document.getElementById('hud-kills').textContent=(g2.id==='dreamcore'?'COINS: ':'ITENS: ')+scoreL+'/'+max;
        if(scoreL>=max){addHudChat('Sistema',g2.id==='dreamcore'?'Todos os coins coletados! DREAMCORE COMPLETO!':'Todos os itens! Vitória!','sys');endGame3D();}
        updateHUD();
      }
    });
  }
  // Animate dance scene
  if(g2.id==='dance'&&scene3d){
    const t3=performance.now()*.001;
    scene3d.children.forEach(c=>{
      if(c.userData.isDisco) c.rotation.y+=0.02;
      if(c.userData.danceLight){ c.intensity=2+Math.sin(t3*3+c.userData.phase*1.5)*1.5; }
    });
  }
  // DreamCore overlay update
  if(g2.id==='dreamcore'){
    const dcH=document.getElementById('dc-hud-info');
    const dcS=document.getElementById('dc-score-info');
    if(dcH) dcH.innerHTML=`HP: ${Math.floor(S.hp)}<br>MODO: DREAMCORE<br>VID: 16BIT`;
    if(dcS) dcS.innerHTML=`SCORE<br>${scoreL} : ${scoreR}`;
  }
  // Mode-specific updates
  const _gn=S.game||GAMES_DATA[0];
  if(_gn.id==='nexusbots') updateNexusBots(performance.now()*.001);
  if(_gn.id==='battleroyale') updateBattleRoyale();
  if(_gn.id==='aimlabpvp') updateAimlabPvpBot();
  if(ren3d&&scene3d&&cam3d) ren3d.render(scene3d,cam3d);
}

function updateBullets3D(){
  for(let i=bullets3d.length-1;i>=0;i--){
    const b=bullets3d[i];
    if(!b.userData) continue;
    b.position.x+=b.userData.vx;
    b.position.y+=b.userData.vy;
    b.position.z+=b.userData.vz;
    b.userData.life-=.016;
    if(b.userData.life<=0){scene3d.remove(b);bullets3d.splice(i,1);continue;}
    // Bot bullets hit player
    if(b.userData.fromBot){
      const dx=b.position.x-player3d.x, dy=b.position.y-player3d.y, dz=b.position.z-player3d.z;
      if(Math.sqrt(dx*dx+dy*dy+dz*dz)<1){
        scene3d.remove(b); bullets3d.splice(i,1);
        const dmg=S.opts.diff==='ultra'?20:S.opts.diff==='hard'?12:8;
        S.hp=Math.max(0,S.hp-dmg);
        document.getElementById('hud-hfill').style.width=S.hp+'%';
        flashHit();
        if(S.hp<=0){endGame3D();return;}
      }
    }
  }
}

function movePlayer3D(){
  const g=S.game||GAMES_DATA[0];
  const isRace=g.id==='racing';

  if(isRace){
    // Racing physics — car steers with A/D, accelerates W, brakes S
    const accel=.018, steer=.04, drag=.985, brakeForce=.92;
    if(keys3d['KeyW']||keys3d['ArrowUp'])  { player3d.vx+=Math.sin(player3d.yaw)*accel; player3d.vz+=Math.cos(player3d.yaw)*accel; }
    if(keys3d['KeyS']||keys3d['ArrowDown']){ player3d.vx*=brakeForce; player3d.vz*=brakeForce; }
    if(keys3d['KeyA']||keys3d['ArrowLeft']) player3d.yaw+=steer*(Math.abs(player3d.vx)+Math.abs(player3d.vz))*.3;
    if(keys3d['KeyD']||keys3d['ArrowRight'])player3d.yaw-=steer*(Math.abs(player3d.vx)+Math.abs(player3d.vz))*.3;
    player3d.vx*=drag; player3d.vz*=drag;
    player3d.x+=player3d.vx; player3d.z+=player3d.vz;
    player3d.y=.6; player3d.onGround=true;
    // Track bounds
    // pista livre — sem clamp lateral forçado
    // Lap detection
    if(player3d.x>96){player3d.x=-92;scoreL++;updateHUD();showScorePopup('VOLTA! +1');addHudChat('Sistema','Volta completada!','sys');}
    return;
  }

  const speed=(.042)*(S.isAdmin&&adminPowers.speed?2.8:1), friction=.84;
  const yaw=player3d.yaw;
  // fwd = direction player faces
  const fwdX=Math.sin(yaw), fwdZ=Math.cos(yaw);
  // right perpendicular to fwd — camera uses yaw-=mouseX so right = (-cos(yaw), sin(yaw))
  const rightX=-Math.cos(yaw), rightZ=Math.sin(yaw);
  if(keys3d['KeyW']||keys3d['ArrowUp'])   {player3d.vx+=fwdX*speed;   player3d.vz+=fwdZ*speed;}
  if(keys3d['KeyS']||keys3d['ArrowDown']) {player3d.vx-=fwdX*speed;   player3d.vz-=fwdZ*speed;}
  if(keys3d['KeyA']||keys3d['ArrowLeft']) {player3d.vx-=rightX*speed;  player3d.vz-=rightZ*speed;}
  if(keys3d['KeyD']||keys3d['ArrowRight']){player3d.vx+=rightX*speed;  player3d.vz+=rightZ*speed;}
  if((keys3d['Space']||keys3d['KeyE'])&&player3d.onGround){player3d.vy=.18;player3d.onGround=false;}
  // ── BALL / KICK logic ──────────────────────────────────────────────────
  const gameNow=S.game||GAMES_DATA[0];
  const isSport=(gameNow.id==='football'||gameNow.id==='basketball');
  if(isSport&&ballMesh){
    // Auto-grab when close (both modes)
    if(!ballHeld){
      const bdx=ball3d.x-player3d.x, bdz=ball3d.z-player3d.z;
      if(Math.sqrt(bdx*bdx+bdz*bdz)<1.8) tryGrabBall();
    }
    if(ballHeld){
      // Keep ball visually in front of player
      ball3d.x=player3d.x+Math.sin(player3d.yaw)*.85;
      ball3d.y=player3d.y+.35;
      ball3d.z=player3d.z+Math.cos(player3d.yaw)*.85;
      ballMesh.position.set(ball3d.x,ball3d.y,ball3d.z);
      ballMesh.rotation.y+=.07;
      // F held → charge power meter
      if(keys3d['KeyF']){
        if(!kickCharging){
          kickCharging=true; kickPower=0;
          const pw=document.getElementById('power-meter-wrap');
          if(pw) pw.classList.add('on');
          const pmb=document.getElementById('pm-bar');
          if(pmb){pmb.style.width='0%';}
          playSound('grab');
        }
        updateKickCharge();
      } else if(kickCharging && ballHeld){
        // F was released between frames — trigger release
        releaseKick();
      }
    }
  }
  player3d.vx*=friction; player3d.vz*=friction;
  // Admin fly mode
  if(S.isAdmin&&adminPowers.fly){
    player3d.vy=0;
    if(keys3d['Space']) player3d.y+=.15;
    if(keys3d['ShiftLeft']||keys3d['KeyC']) player3d.y-=.15;
  } else {
    player3d.vy-=.008;
  }
  player3d.x+=player3d.vx; player3d.z+=player3d.vz; player3d.y+=player3d.vy;
  if(player3d.y<1){player3d.y=1;player3d.vy=0;player3d.onGround=true;}
  // Sem barreiras — mapa livre (queda só por y)
  // player3d.x e z sem limite
  // Animate player mesh (3rd person walk)
  if(playerMesh&&playerMesh.userData&&!playerMesh.userData.isCar){
    playerMesh.position.set(player3d.x,player3d.y-1,player3d.z);
    playerMesh.rotation.y=player3d.yaw+Math.PI;
    const isWalking=Math.abs(player3d.vx)>.005||Math.abs(player3d.vz)>.005;
    playerMesh.userData.walkT+=(isWalking?.14:.03);
    const wt=playerMesh.userData.walkT;
    const amp=isWalking?.45:.06;
    const {laG,raG,llG,rlG}=playerMesh.userData;
    if(laG) laG.rotation.x=Math.sin(wt)*amp;
    if(raG) raG.rotation.x=-Math.sin(wt)*amp;
    if(llG) llG.rotation.x=-Math.sin(wt)*amp*.8;
    if(rlG) rlG.rotation.x=Math.sin(wt)*amp*.8;
    if(isWalking) playerMesh.position.y+=Math.abs(Math.sin(wt))*.03-1;
  }
  // Update lantern
  scene3d.children.forEach(c=>{if(c.userData.isLantern){c.position.set(player3d.x,1.5,player3d.z);c.target.position.set(player3d.x+Math.sin(player3d.yaw),1,player3d.z+Math.cos(player3d.yaw));c.target.updateMatrixWorld&&c.target.updateMatrixWorld();}});
}

function updateCamera3D(){
  const g=S.game||GAMES_DATA[0];
  if(g.id==='racing'){
    // Behind-car camera for racing
    const behindDist=7, camH=3;
    const camX=player3d.x - Math.sin(player3d.yaw)*behindDist;
    const camZ=player3d.z - Math.cos(player3d.yaw)*behindDist;
    cam3d.position.set(camX, player3d.y+camH, camZ);
    cam3d.lookAt(player3d.x + Math.sin(player3d.yaw)*3, player3d.y+1, player3d.z + Math.cos(player3d.yaw)*3);
    // Update car mesh
    if(playerMesh&&playerMesh.userData.isCar){
      playerMesh.position.set(player3d.x, player3d.y-.3, player3d.z);
      playerMesh.rotation.y=player3d.yaw+Math.PI/2;
      // Wheel spin
      playerMesh.children.forEach(c=>{
        if(c.geometry&&c.geometry.type==='CylinderGeometry'&&c.geometry.parameters?.radiusTop<.3){
          c.rotation.x+=(Math.abs(player3d.vx)+.002)*.8;
        }
      });
    }
  } else {
    cam3d.position.set(player3d.x,player3d.y+.6,player3d.z);
    const lookX=player3d.x+Math.sin(player3d.yaw)*Math.cos(player3d.pitch);
    const lookY=player3d.y+.6+Math.sin(player3d.pitch);
    const lookZ=player3d.z+Math.cos(player3d.yaw)*Math.cos(player3d.pitch);
    cam3d.lookAt(lookX,lookY,lookZ);
  }
}

function updateParticles3D(){
  particles3d=particles3d.filter(p=>{
    p.life-=.02;
    p.mesh.position.x+=p.vx; p.mesh.position.y+=p.vy; p.mesh.position.z+=p.vz;
    p.vy-=.003;
    p.mesh.material.opacity=p.life;
    if(p.life<=0){scene3d.remove(p.mesh);return false;}
    return true;
  });
}

function shoot3d(){
  const g=S.game||GAMES_DATA[0];
  const isFPS=g.id==='pvp'||g.id==='aimlab'||g.id==='escape'||g.id==='labyrinth'||g.id==='nexusbots'||g.id==='archery'||g.id==='battleroyale'||g.id==='aimlabpvp';
  if(!isFPS) return;
  if(ammo<=0&&g.id!=='aimlab'){toast('Sem municao! R para recarregar.','warn');return;}
  if(g.id!=='aimlab'){ammo--;}
  const yaw=player3d.yaw, pitch=player3d.pitch;
  const dir={x:Math.sin(yaw)*Math.cos(pitch),y:Math.sin(pitch),z:Math.cos(yaw)*Math.cos(pitch)};
  const origin=new THREE.Vector3(player3d.x,player3d.y+.6,player3d.z);
  const direction=new THREE.Vector3(dir.x,dir.y,dir.z).normalize();
  const ray=new THREE.Raycaster(origin,direction,0,80);
  // Collect all hittable meshes
  const allHittable=[];
  targets3d.filter(t=>t.mesh&&!t.hit).forEach(t=>allHittable.push(t.mesh));
  // NexusBots sprites são hittable diretamente
  bots3d.filter(b=>b.isNexusBot&&b.group).forEach(b=>allHittable.push(b.group));
  bots3d.filter(b=>b.group&&!b.isNexusBot).forEach(b=>{
    b.group.traverse(child=>{if(child.isMesh) allHittable.push(child);});
  });
  const hits=ray.intersectObjects(allHittable,false);
  if(hits.length>0){
    const hit=hits[0];
    spawnHitParticles(hit.point.x,hit.point.y,hit.point.z);
    // Check target hit
    const tHit=targets3d.find(t=>t.mesh===hit.object);
    if(tHit&&!tHit.hit){
      tHit.hit=true;
      scene3d.remove(tHit.mesh);
      const idx=targets3d.indexOf(tHit); if(idx>-1) targets3d.splice(idx,1);
      setTimeout(spawnOneTarget,800);
      scoreL+=100; kills++;
      showScorePopup('+100 PTS');
      addHudChat('Sistema','Alvo atingido! +100 pts','sys');
    }
    // Check bot hit
    // Check sprite bots (NexusBots)
    const g2=S.game||GAMES_DATA[0];
    if(g2.id==='nexusbots'){
      const nbHit=bots3d.find(b=>b.isNexusBot&&b.group&&b.group===hit.object);
      if(nbHit){
        nbHit.hp-=S.opts.diff==='ultra'?50:S.opts.diff==='hard'?35:25;
        if(nbHit.hp<=0){
          scene3d.remove(nbHit.group);
          const bi=bots3d.indexOf(nbHit); if(bi>-1) bots3d.splice(bi,1);
          kills++; scoreL+=300;
          showScorePopup('NEXUSBOT KILL! +300');
          addHudChat('Sistema',`${kills} kills! ${bots3d.filter(b=>b.isNexusBot).length} restantes`,'sys');
          document.getElementById('hud-kills').textContent='KILLS: '+kills;
          updateHUD();
          // Respawn new bot after 5s
          setTimeout(()=>{ if(S.running&&S.game?.id==='nexusbots') spawnNexusBots(1); },5000);
          if(bots3d.filter(b=>b.isNexusBot).length===0){
            showScorePopup('SOBREVIVEU! 🏆'); endGame3D();
          }
        } else {
          // Hit flash — tint sprite red briefly
          nbHit.group.material.color.setHex(0xff0000);
          setTimeout(()=>{ if(nbHit.group) nbHit.group.material.color.setHex(0xffffff); },150);
        }
      }
    } else {
    const botHit=bots3d.find(b=>b.group&&(()=>{let found=false;b.group.traverse(c=>{if(c===hit.object)found=true;});return found;})());
    if(botHit){
      const dmg=S.opts.diff==='ultra'?40:S.opts.diff==='hard'?25:18;
      botHit.hp-=dmg;
      if(botHit.hp<=0){
        scene3d.remove(botHit.group);
        const bi=bots3d.indexOf(botHit); if(bi>-1) bots3d.splice(bi,1);
        kills++; scoreL+=200;
        showScorePopup('KILL! +200');
        addHudChat('Sistema',`${kills} kills!`,'sys');
        setTimeout(()=>{ if(S.running&&bots3d.length<3) spawnBots3D(1); },3500);
      }
    }
    }
    flashHit();
  }
  spawnBulletTracer(dir);
  // Update ammo display
  const ammoEl=document.getElementById('hud-ammo');
  if(ammoEl) ammoEl.textContent='AMMO: '+(g.id==='aimlab'?'INF':ammo);
  const killEl=document.getElementById('hud-kills');
  if(killEl) killEl.textContent='KILLS: '+kills;
  updateHUD();
}

function spawnHitParticles(x,y,z){
  for(let i=0;i<8;i++){
    const p=new THREE.Mesh(new THREE.SphereGeometry(.05,4,4),new THREE.MeshBasicMaterial({color:0xff4422,transparent:true,opacity:1}));
    p.position.set(x,y,z); scene3d.add(p);
    particles3d.push({mesh:p,vx:(Math.random()-.5)*.1,vy:Math.random()*.1,vz:(Math.random()-.5)*.1,life:1});
  }
}

function spawnBulletTracer(dir){
  const mesh=new THREE.Mesh(new THREE.BoxGeometry(.02,.02,.4),new THREE.MeshBasicMaterial({color:0xffff00,transparent:true,opacity:.8}));
  mesh.position.set(player3d.x+dir.x,player3d.y+.4+dir.y,player3d.z+dir.z);
  mesh.lookAt(player3d.x+dir.x*5,player3d.y+.4+dir.y*5,player3d.z+dir.z*5);
  scene3d.add(mesh);
  particles3d.push({mesh,vx:dir.x*.3,vy:dir.y*.3,vz:dir.z*.3,life:.5});
}

function spawnGoalParticles3D(){
  if(!scene3d) return;
  const colors=[0xffd740,0xff6b00,0x00f5ff,0xffffff,0x00e676];
  for(let i=0;i<30;i++){
    const col=colors[Math.floor(Math.random()*colors.length)];
    const p=new THREE.Mesh(
      new THREE.SphereGeometry(.08+Math.random()*.12,4,4),
      new THREE.MeshBasicMaterial({color:col,transparent:true,opacity:1})
    );
    p.position.set(18.5,1+Math.random()*2,(Math.random()-.5)*3);
    const angle=Math.random()*Math.PI*2;
    const spd=0.12+Math.random()*.25;
    particles3d.push({mesh:p,vx:Math.cos(angle)*spd,vy:.15+Math.random()*.2,vz:Math.sin(angle)*spd,life:1.2});
    scene3d.add(p);
  }
  // Flash light at goal
  const flash=new THREE.PointLight(0xffd740,8,15);
  flash.position.set(19,2,0); scene3d.add(flash);
  setTimeout(()=>scene3d.remove(flash),300);
}

function vfxFlash(intensity=0.25){
  const hh=document.getElementById('hud-hit');
  if(!hh) return;
  hh.style.background=`rgba(255,215,64,${intensity})`;
  hh.style.transition='none';
  setTimeout(()=>{hh.style.background='rgba(255,23,68,0)';hh.style.transition='background .2s';},120);
}
function flashHit(){
  const hh=document.getElementById('hud-hit');
  if(!hh) return;
  hh.style.background='rgba(255,23,68,.32)';
  hh.style.transition='none';
  setTimeout(()=>{hh.style.background='rgba(255,23,68,0)';hh.style.transition='background .25s';},200);
}


function showScorePopup(txt){
  const layer=document.getElementById('score-layer');
  if(!layer) return;
  const d=document.createElement('div');
  d.className='score-popup';
  d.style.cssText=`left:${48+Math.random()*8}%;top:${30+Math.random()*25}%`;
  d.textContent=txt; layer.appendChild(d);
  setTimeout(()=>d.remove(),1900);
}

function showGolOverlay(team){
  const layer=document.getElementById('score-layer');
  if(!layer) return;
  const wrap=document.createElement('div'); wrap.className='gol-overlay';
  const txt=document.createElement('div'); txt.className='gol-text';
  txt.textContent=team==='player'?'GOL!':'GOOOOL!';
  wrap.style.background=team==='player'?'radial-gradient(ellipse at center,rgba(255,215,0,.15) 0%,transparent 70%)':'radial-gradient(ellipse at center,rgba(255,30,0,.12) 0%,transparent 70%)';
  wrap.appendChild(txt); layer.appendChild(wrap);
  if(team==='player'){
    // Particle burst
    for(let i=0;i<20;i++){
      const p=document.createElement('div');
      const angle=Math.random()*360, dist=60+Math.random()*120;
      p.style.cssText=`position:absolute;width:8px;height:8px;border-radius:50%;background:${['#ffd740','#ff6b00','#00f5ff','#fff'][Math.floor(Math.random()*4)]};left:50%;top:50%;transform:translate(-50%,-50%);animation:pflyOut_${i} 1s ease forwards`;
      const style=document.createElement('style');
      style.textContent=`@keyframes pflyOut_${i}{to{transform:translate(${Math.cos(angle/57)*dist}px,${Math.sin(angle/57)*dist}px);opacity:0}}`;
      document.head.appendChild(style);
      wrap.appendChild(p);
      setTimeout(()=>style.remove(),1200);
    }
  }
  setTimeout(()=>wrap.remove(),2200);
}

function updateMinimap(){
  const cv=document.getElementById('mm-canvas');
  if(!cv) return;
  cv.width=120; cv.height=90;
  const c=cv.getContext('2d');
  c.fillStyle='rgba(0,0,0,.7)'; c.fillRect(0,0,120,90);
  // Grid
  c.strokeStyle='rgba(0,245,255,.15)'; c.lineWidth=.5;
  for(let i=0;i<120;i+=12){c.beginPath();c.moveTo(i,0);c.lineTo(i,90);c.stroke();}
  for(let i=0;i<90;i+=12){c.beginPath();c.moveTo(0,i);c.lineTo(120,i);c.stroke();}
  // Bots
  bots3d.forEach(b=>{
    const mx=(b.x+25)/50*120, my=(b.z+25)/50*90;
    c.fillStyle=b.hp<0?'rgba(255,0,0,.5)':'rgba(255,80,0,.8)';
    c.fillRect(mx-3,my-3,6,6);
  });
  // Ball
  if(ballMesh){
    const bx=(ball3d.x+25)/50*120, bz=(ball3d.z+25)/50*90;
    c.fillStyle='white'; c.beginPath(); c.arc(bx,bz,3,0,Math.PI*2); c.fill();
  }
  // Player
  const px=(player3d.x+25)/50*120, pz=(player3d.z+25)/50*90;
  c.fillStyle='#00f5ff'; c.beginPath(); c.arc(px,pz,4,0,Math.PI*2); c.fill();
  // Direction
  c.strokeStyle='#00f5ff'; c.lineWidth=1.5;
  c.beginPath(); c.moveTo(px,pz);
  c.lineTo(px+Math.sin(player3d.yaw)*10,pz+Math.cos(player3d.yaw)*10);
  c.stroke();
}

function updateHUD(){
  const g=S.game||GAMES_DATA[0];
  document.getElementById('hud-sl').textContent=scoreL;
  document.getElementById('hud-sr').textContent=scoreR;
  const m=Math.floor(gameTime/60).toString().padStart(2,'0');
  const s=(gameTime%60).toString().padStart(2,'0');
  document.getElementById('hud-timer').textContent=m+':'+s;
  document.getElementById('hud-hfill').style.width=S.hp+'%';
  const hpEl=document.getElementById('hud-hfill');
  if(hpEl){
    hpEl.style.background=S.hp>60?'linear-gradient(90deg,#00e676,#00b050)':S.hp>30?'linear-gradient(90deg,#ffd740,#ff9100)':'linear-gradient(90deg,#ff1744,#aa0020)';
  }
  const ptsEl=document.getElementById('hud-points');
  if(ptsEl){
    if(g.id==='aimlab'||g.id==='pvp') ptsEl.textContent=`PONTOS: ${scoreL*100 + kills*200}`;
    else if(g.id==='racing') ptsEl.textContent=`VOLTAS: ${scoreL}`;
    else ptsEl.textContent='';
  }
}

function togglePause(){
  S.paused=!S.paused;
  const btn=document.getElementById('hud-pause');
  if(btn) btn.textContent=S.paused?'Continuar':'Pausar';
  if(S.paused&&document.pointerLockElement) document.exitPointerLock();
}

function exitGame3d(){
  S.running=false;
  clearInterval(gTimer);
  cancelAnimationFrame(raf);
  if(ren3d){ren3d.dispose(); ren3d=null;}
  scene3d=null;
  document.getElementById('game3d').classList.remove('on');
  document.getElementById('hud').classList.remove('on');
  document.removeEventListener('mousemove',onMM);
  document.removeEventListener('keydown',onKD);
  document.removeEventListener('keyup',onKU);
  document.removeEventListener('mousedown',onMD);
  if(document.pointerLockElement) document.exitPointerLock();
  keys3d={};
  bots3d=[]; botMeshes=[]; targets3d=[]; bullets3d=[]; particles3d=[];
  ballMesh=null; playerMesh=null; groundMesh=null;
  ballHeld=false; kickCharging=false; kickPower=0; hackerEventDone=false;
  // Clean overlays
  const dcOv=document.getElementById('dreamcore-overlay');
  if(dcOv){dcOv.classList.remove('on');dcOv.style.filter='';const kb=document.getElementById('dc-kick-banner');if(kb)kb.classList.remove('on');}
  const nickL=document.getElementById('nick-layer'); if(nickL) nickL.innerHTML='';
  const hud3=document.getElementById('hud'); if(hud3) hud3.style.filter='';
  const bhi=document.getElementById('ball-held-ind'); if(bhi) bhi.style.display='none';
  clearInterval(fakeHudInt);
  goPage('games');
}

function buildPlayerMesh3D(g){
  // Only build visible body for 3rd-person games (not FPS)
  const isFPS = g.id==='pvp'||g.id==='aimlab'||g.id==='escape'||g.id==='labyrinth';
  if(isFPS) return;

  if(g.id==='racing'){
    // Build player car
    const car=new THREE.Group();
    const col=new THREE.Color(S.char?.color||'#00f5ff');
    const body=new THREE.Mesh(new THREE.BoxGeometry(2.8,.5,1.4),new THREE.MeshStandardMaterial({color:col,roughness:.3,metalness:.6}));
    body.position.y=.45; car.add(body);
    const roof=new THREE.Mesh(new THREE.BoxGeometry(1.2,.35,1.1),new THREE.MeshStandardMaterial({color:col,roughness:.3,metalness:.6}));
    roof.position.set(.1,.75,0); car.add(roof);
    [[1,.15,.75],[-1,.15,.75],[1,.15,-.75],[-1,.15,-.75]].forEach(([x,y,z])=>{
      const w=new THREE.Mesh(new THREE.CylinderGeometry(.28,.28,.18,12),new THREE.MeshStandardMaterial({color:0x111111,roughness:.9}));
      w.rotation.z=Math.PI/2; w.position.set(x,y,z); car.add(w);
    });
    const hl=new THREE.PointLight(col,3,8); hl.position.set(1.5,.5,0); car.add(hl);
    car.position.set(player3d.x,player3d.y-.4,player3d.z);
    car.rotation.y=player3d.yaw+Math.PI/2;
    car.castShadow=true;
    car.userData={isPlayerMesh:true,isCar:true,laG:null,raG:null,llG:null,rlG:null,walkT:0};
    scene3d.add(car); playerMesh=car;
    return;
  }

  const c = S.char || CHARS[0];
  const col = new THREE.Color(c.color||'#00f5ff');
  const skin = new THREE.Color(0xffbb88);
  const dark = new THREE.Color(0x111122);
  const pm = new THREE.Group();
  // Torso
  const torso=new THREE.Mesh(new THREE.CylinderGeometry(.18,.2,.55,8),new THREE.MeshStandardMaterial({color:col,roughness:.5}));
  torso.position.y=1.1; pm.add(torso);
  // Head
  const head=new THREE.Mesh(new THREE.SphereGeometry(.15,10,10),new THREE.MeshStandardMaterial({color:skin,roughness:.8}));
  head.position.y=1.72; pm.add(head);
  // Helmet
  const helm=new THREE.Mesh(new THREE.CylinderGeometry(.16,.15,.07,8),new THREE.MeshStandardMaterial({color:col,roughness:.4,metalness:.3}));
  helm.position.y=1.82; pm.add(helm);
  // Eyes
  [-.055,.055].forEach(x=>{
    const eye=new THREE.Mesh(new THREE.SphereGeometry(.025,5,5),new THREE.MeshBasicMaterial({color:0xffffff}));
    eye.position.set(x,1.73,.13); pm.add(eye);
    const pupil=new THREE.Mesh(new THREE.SphereGeometry(.013,4,4),new THREE.MeshBasicMaterial({color:0x000000}));
    pupil.position.set(x,1.73,.155); pm.add(pupil);
  });
  // Arms
  const laG=new THREE.Group(); laG.position.set(-.27,1.2,0);
  laG.add(new THREE.Mesh(new THREE.CylinderGeometry(.055,.065,.38,7),new THREE.MeshStandardMaterial({color:col})));
  const lh=new THREE.Mesh(new THREE.SphereGeometry(.06,6,6),new THREE.MeshStandardMaterial({color:skin})); lh.position.y=-.22; laG.add(lh);
  pm.add(laG);
  const raG=new THREE.Group(); raG.position.set(.27,1.2,0);
  raG.add(new THREE.Mesh(new THREE.CylinderGeometry(.055,.065,.38,7),new THREE.MeshStandardMaterial({color:col})));
  const rh2=new THREE.Mesh(new THREE.SphereGeometry(.06,6,6),new THREE.MeshStandardMaterial({color:skin})); rh2.position.y=-.22; raG.add(rh2);
  pm.add(raG);
  // Hips
  const hipsM=new THREE.Mesh(new THREE.BoxGeometry(.28,.1,.16),new THREE.MeshStandardMaterial({color:dark}));
  hipsM.position.set(0,.78,0); pm.add(hipsM);
  // Legs
  const llG=new THREE.Group(); llG.position.set(-.1,.75,0);
  llG.add(new THREE.Mesh(new THREE.CylinderGeometry(.065,.06,.42,7),new THREE.MeshStandardMaterial({color:dark})));
  const lfM=new THREE.Mesh(new THREE.BoxGeometry(.1,.06,.18),new THREE.MeshStandardMaterial({color:0x0a0a0a})); lfM.position.set(0,-.24,.03); llG.add(lfM);
  pm.add(llG);
  const rlG=new THREE.Group(); rlG.position.set(.1,.75,0);
  rlG.add(new THREE.Mesh(new THREE.CylinderGeometry(.065,.06,.42,7),new THREE.MeshStandardMaterial({color:dark})));
  const rfM=new THREE.Mesh(new THREE.BoxGeometry(.1,.06,.18),new THREE.MeshStandardMaterial({color:0x0a0a0a})); rfM.position.set(0,-.24,.03); rlG.add(rfM);
  pm.add(rlG);
  pm.castShadow=true;
  pm.userData={isPlayerMesh:true,laG,raG,llG,rlG,walkT:0};
  scene3d.add(pm);
  playerMesh=pm;
}

function endGame3D(){
  S.running=false; clearInterval(gTimer);
  cancelAnimationFrame(raf);
  // Show end screen overlay
  const win=scoreL>scoreR, tie=scoreL===scoreR;
  const layer=document.getElementById('score-layer');
  if(layer){
    const endDiv=document.createElement('div');
    endDiv.style.cssText='position:absolute;inset:0;background:rgba(0,0,0,.75);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:18px;z-index:50;animation:fa .4s ease';
    const title=document.createElement('div');
    title.style.cssText=`font-family:var(--fm);font-size:3.5rem;font-weight:900;color:${win?'var(--y)':tie?'var(--c)':'var(--r)'};text-shadow:0 0 40px currentColor;letter-spacing:4px`;
    title.textContent=win?'VITÓRIA!':tie?'EMPATE!':'DERROTA';
    const score=document.createElement('div');
    score.style.cssText='font-family:var(--fm);font-size:1.8rem;color:var(--w)';
    score.textContent=`${scoreL}  :  ${scoreR}`;
    const sub=document.createElement('div');
    sub.style.cssText='font-size:.9rem;color:var(--mu);margin-top:-8px';
    sub.textContent=`${win?'Excelente jogo!':tie?'Foi por pouco!':'Tente novamente!'} — Voltando em 4s...`;
    const btn=document.createElement('button');
    btn.className='btn btn-c btn-lg'; btn.textContent='Jogar Novamente';
    btn.onclick=()=>{endDiv.remove();exitGame3d();};
    endDiv.append(title,score,sub,btn); layer.appendChild(endDiv);
  }
  addHudChat('Sistema',`Fim de jogo! ${win?'VITÓRIA':'DERROTA'} ${scoreL}:${scoreR}`,'sys');
  toast(`${win?'VITÓRIA':'Derrota'} ${scoreL}:${scoreR}`, win?'ok':'err');
  setTimeout(exitGame3d, 5000);
}

// ═══════════════════════════════════════
// HUD CHAT
// ═══════════════════════════════════════
function addHudChat(user,text,cls){
  const el=document.getElementById('hud-chatmsgs');
  if(!el) return;
  const d=document.createElement('div');
  d.className='cmsg';
  d.innerHTML=`<span class="cmu cmu-${cls}">${user}</span><div class="cmt">${text}</div>`;
  el.appendChild(d); el.scrollTop=el.scrollHeight;
}
function sendHudChat(){
  const inp=document.getElementById('hud-ci-inp');
  if(!inp||!inp.value.trim()) return;
  addHudChat(S.user||'Você',inp.value,'me');
  inp.value='';
  const replies=['boa!','ggwp!','quase!','haha','boa defesa!','nice!','gg'];
  if(Math.random()>.4) setTimeout(()=>addHudChat(rp(),replies[Math.floor(Math.random()*replies.length)],'o'),600+Math.random()*800);
}
function toggleHudChat(){
  const inp=document.getElementById('hud-ci-inp');
  if(!inp) return;
  if(inp.style.display==='none'||!inp.style.display){
    inp.style.display='block'; inp.focus(); if(plock) document.exitPointerLock();
  } else {
    inp.style.display='none';
    const cv=document.getElementById('c3d'); if(cv) cv.requestPointerLock();
  }
}
let fakeHudInt=null;
function startFakeHudChat(){
  clearInterval(fakeHudInt);
  const msgs=['vai nessa!','que jogada!','caramba!','gg wp','cuidado pelo lado!','boa defesa','haha'];
  fakeHudInt=setInterval(()=>{
    if(!S.running){clearInterval(fakeHudInt);return;}
    if(Math.random()>.5) addHudChat(rp(),msgs[Math.floor(Math.random()*msgs.length)],'o');
  },4000);
}

// ═══════════════════════════════════════
// ROOMS
// ═══════════════════════════════════════
function renderRooms(){
  const fr=document.getElementById('rooms-filters');
  if(fr) fr.innerHTML=['Todos','Esportes','Terror','Ação','Fácil','Difícil','Ultra','Com vagas'].map(f=>`<span class="fch" onclick="this.parentElement.querySelectorAll('.fch').forEach(c=>c.classList.remove('on'));this.classList.add('on')">${f}</span>`).join('');
  const grid=document.getElementById('rooms-grid');
  if(grid) grid.innerHTML=ROOMS_DATA.map(r=>rcHTML(r)).join('');
}
function openRoom(name,game,diff){
  document.getElementById('rm-title').textContent=name;
  document.getElementById('rm-gm').textContent=game;
  document.getElementById('rm-df').textContent=diff;
  const rl=document.getElementById('rm-lob');
  const ps=[S.user,rp(),rp()];
  rl.innerHTML=`<div class="lc"><h4>JOGADORES</h4>
    ${ps.map((p,i)=>`<div class="ps"><div class="pav" style="background:${PCOLORS[i%PCOLORS.length]}">${p[0]}</div><span class="pn">${p}</span><span class="${i===0?'pr':'pw'}">${i===0?'Pronto':'Aguardando'}</span></div>`).join('')}
  </div>
  <div class="lc"><h4>INFO</h4>
    <div style="font-size:.78rem;color:var(--mu);display:flex;flex-direction:column;gap:5px">
      <span>Mapa padrão</span><span>Bots: Sim</span><span>Max: 8</span><span>Diff: ${diff}</span>
    </div>
  </div>`;
  const rc=document.getElementById('rm-chat'); rc.innerHTML='';
  rmChatAdd('Sistema','Sala aberta. Aguardando jogadores...','sys');
  rmChatAdd(ps[1],'Pronto pra ganhar!','o');
  openM('rm-modal');
}
function rmChatAdd(u,t,c){
  const el=document.getElementById('rm-chat');
  if(!el) return;
  const d=document.createElement('div'); d.className='cmsg';
  d.innerHTML=`<span class="cmu cmu-${c}">${u}</span><div class="cmt">${t}</div>`;
  el.appendChild(d); el.scrollTop=el.scrollHeight;
}
function rmChat(){
  const i=document.getElementById('rm-ci');
  if(!i||!i.value.trim()) return;
  rmChatAdd(S.user||'Você',i.value,'me'); i.value='';
  if(Math.random()>.3) setTimeout(()=>rmChatAdd(rp(),['pronto!','vai logo!','gg'][Math.floor(Math.random()*3)],'o'),700);
}
function enterRm(){
  closeM('rm-modal');
  if(!S.game) S.game=GAMES_DATA[0];
  goCharSelect();
}
function createRoom(){
  const nm=document.getElementById('cr-nm').value||'Nova Sala';
  const gm=document.getElementById('cr-gm').value;
  ROOMS_DATA.unshift({name:nm,game:gm,players:1,max:parseInt(S.opts.rmx||4),diff:S.opts.rd||'med',priv:S.opts.rp==='prv',host:S.user});
  closeM('cr-modal'); renderRooms();
  toast(`Sala "${nm}" criada!`,'ok');
}
function playMap(n){ S.game=GAMES_DATA[0]; toast(`Carregando: ${n}...`); setTimeout(goCharSelect,400); }

// ═══════════════════════════════════════
// MAP EDITOR
// ═══════════════════════════════════════
const TILES=[{t:'🟩',l:'Grama'},{t:'⬛',l:'Parede'},{t:'🟦',l:'Água'},{t:'🟧',l:'Areia'},{t:'⬜',l:'Chão'},{t:'🔲',l:'Pedra'}];
const OBJS=[{t:'🚧',l:'Obstáculo'},{t:'🚪',l:'Porta'},{t:'⭐',l:'Item'},{t:'🔥',l:'Armadilha'},{t:'💎',l:'Coletar'},{t:'🌿',l:'Deco'}];
const ME_COLS=20, ME_ROWS=14;
let painting=false;

function initME(){
  const tp=document.getElementById('tile-pal');
  const op=document.getElementById('obj-pal');
  if(tp&&!tp.children.length){
    tp.innerHTML=TILES.map(t=>`<button class="tile${t.t===S.tile?' on':''}" onclick="setTile('${t.t}')" title="${t.l}">${t.t}</button>`).join('');
    op.innerHTML=OBJS.map(t=>`<button class="tile" onclick="setTile('${t.t}')" title="${t.l}">${t.t}</button>`).join('');
  }
  buildMEGrid();
}
function setTile(t){S.tile=t;document.querySelectorAll('.tile').forEach(b=>b.classList.toggle('on',b.textContent===t));}
function setDim(d){S.dim=d;document.getElementById('d2btn').classList.toggle('sel',d==='2d');document.getElementById('d3btn').classList.toggle('sel',d==='3d');}
function buildMEGrid(){
  const grid=document.getElementById('me-grid');
  if(!grid) return;
  grid.style.gridTemplateColumns=`repeat(${ME_COLS},32px)`;
  grid.innerHTML='';
  for(let r=0;r<ME_ROWS;r++) for(let c=0;c<ME_COLS;c++){
    const k=`${r}-${c}`, cell=document.createElement('div');
    cell.className='mc'; cell.textContent=S.mapData[k]||'';
    cell.onmousedown=()=>{painting=true;paint(cell,k);};
    cell.onmouseenter=()=>{if(painting)paint(cell,k);};
    cell.onmouseup=()=>painting=false;
    grid.appendChild(cell);
  }
  document.addEventListener('mouseup',()=>painting=false);
}
function paint(cell,k){cell.textContent=S.tile;S.mapData[k]=S.tile;}
function clearME(){S.mapData={};buildMEGrid();}
function fillME(){for(let r=0;r<ME_ROWS;r++)for(let c=0;c<ME_COLS;c++)S.mapData[`${r}-${c}`]=S.tile;buildMEGrid();}
function fillGrass(){const prev=S.tile;S.tile='🟩';fillME();S.tile=prev;}
function pubMap(){
  const n=document.getElementById('mn')?.value||'Mapa';
  const cat=document.getElementById('mc')?.value||'Custom';
  COMM_MAPS.unshift({name:n,author:S.user||'Você',tile:S.tile,cat,likes:0,plays:0,r:5.0,isNew:true});
  toast(`Mapa "${n}" publicado!`,'ok');
  aiSayMsg(`Mapa "${n}" publicado com sucesso! Outros jogadores já podem encontrá-lo na aba Comunidade.`);
}
function saveLocal(){toast('Mapa salvo localmente!','ok');}
function dupMap(){toast('Mapa duplicado!','ok');}
function testME(){S.game=GAMES_DATA[0];goCharSelect();}

// ═══════════════════════════════════════
// COMMUNITY
// ═══════════════════════════════════════
let commFilt='all';
function renderComm(){
  const grid=document.getElementById('comm-grid');
  if(!grid) return;
  const fl=commFilt==='all'?COMM_MAPS:COMM_MAPS.filter(m=>m.cat===commFilt);
  grid.innerHTML=fl.map(m=>mccHTML(m)).join('');
}
function filtComm(el,f){
  commFilt=f;
  el.closest('.frow').querySelectorAll('.fch').forEach(c=>c.classList.remove('on'));
  el.classList.add('on'); renderComm();
}

// ═══════════════════════════════════════
// PROFILE
// ═══════════════════════════════════════
function renderProfile(){
  const stats=[{v:'247',l:'Vitórias'},{v:'89',l:'Derrotas'},{v:'73%',l:'Win Rate'},{v:'Lv42',l:'Nível'},{v:'6.7K',l:'XP'},{v:'3',l:'Mapas'},{v:'128h',l:'Tempo'},{v:'1,450',l:'Partidas'}];
  const sg=document.getElementById('p-stats');
  if(sg) sg.innerHTML=stats.map(s=>`<div class="si2"><div class="sv">${s.v}</div><div class="slbl">${s.l}</div></div>`).join('');
  const pm=document.getElementById('p-maps');
  if(pm) pm.innerHTML=COMM_MAPS.slice(0,3).map(m=>mccHTML(m)).join('');
  const ph=document.getElementById('p-hist');
  const matches=[{g:'Futebol 3D',r:'VITÓRIA',s:'3-1',m:'PvP',t:'2h atrás'},{g:'Terror Escape',r:'DERROTA',s:'—',m:'Solo',t:'4h atrás'},{g:'Aim Lab',r:'VITÓRIA',s:'9840',m:'Bot',t:'ontem'},{g:'PvP Arena',r:'VITÓRIA',s:'15-8',m:'Bot Difícil',t:'ontem'}];
  if(ph) ph.innerHTML=matches.map(m=>`<div style="display:flex;align-items:center;gap:12px;padding:10px 0;border-bottom:1px solid var(--bd)">
    <span style="font-weight:700;font-size:.82rem;color:${m.r==='VITÓRIA'?'var(--g)':'var(--r)'};font-family:var(--fm);min-width:65px">${m.r}</span>
    <span style="font-size:.82rem">${m.g}</span>
    <span style="font-family:var(--fm);color:var(--c);font-size:.82rem">${m.s}</span>
    <span style="color:var(--mu);font-size:.78rem;margin-left:auto">${m.m} · ${m.t}</span>
  </div>`).join('');
}

// ═══════════════════════════════════════
// SEARCH
// ═══════════════════════════════════════
function initSearch(){
  const sf=document.getElementById('s-filters');
  if(sf&&!sf.children.length) sf.innerHTML=['Jogos','Mapas','Salas','Esportes','Terror','3D','Bot','Multi'].map(f=>`<span class="fch" onclick="this.parentElement.querySelectorAll('.fch').forEach(c=>c.classList.remove('on'));this.classList.add('on')">${f}</span>`).join('');
  doSearch('');
}
function doSearch(q){
  const res=document.getElementById('s-results');
  if(!res) return;
  q=q.toLowerCase();
  const games=GAMES_DATA.filter(g=>!q||g.name.toLowerCase().includes(q)||g.cat.toLowerCase().includes(q)||g.desc.toLowerCase().includes(q));
  const maps=COMM_MAPS.filter(m=>!q||m.name.toLowerCase().includes(q)||m.cat.toLowerCase().includes(q));
  if(!q) res.innerHTML=games.slice(0,6).map(g=>gcHTML(g)).join('');
  else res.innerHTML=[...games.map(g=>gcHTML(g)),...maps.map(m=>mccHTML(m))].join('')||'<div style="color:var(--mu);text-align:center;padding:40px;grid-column:1/-1">Nenhum resultado.</div>';
  setTimeout(()=>games.forEach(g=>{const cv=document.getElementById('gc3d-'+g.id);if(cv&&!cv._init){cv._init=true;renderCardPreview(cv,g);}}),200);
}

// ═══════════════════════════════════════
// ADMIN
// ═══════════════════════════════════════
// 10 admin accounts pre-generated
const ADM_ACCOUNTS=[
  {u:'Admin_FG',pass:'nx1234',role:'Super Admin',since:'2023-01-01'},
  {u:'ModeratorX',pass:'mod001',role:'Moderador',since:'2023-03-15'},
  {u:'DevTeam01',pass:'dev999',role:'Desenvolvedor',since:'2023-06-01'},
  {u:'SupportPro',pass:'sup123',role:'Suporte',since:'2023-08-20'},
  {u:'HeadMod',pass:'hm456',role:'Moderador-Chefe',since:'2023-09-01'},
  {u:'SysAdmin2',pass:'sys789',role:'Admin Sistema',since:'2024-01-10'},
  {u:'ContentMgr',pass:'cnt321',role:'Conteúdo',since:'2024-02-14'},
  {u:'AntiCheat1',pass:'ac888',role:'Anti-Cheat',since:'2024-04-01'},
  {u:'AnalystPro',pass:'anl555',role:'Analista',since:'2024-05-20'},
  {u:'MapApprove',pass:'map111',role:'Aprovador Mapas',since:'2024-07-01'},
];

function renderAdmin(){adTab(S.adminTab||'ov');}
function adTab(tab){
  S.adminTab=tab;
  document.querySelectorAll('.adm-ni').forEach(i=>i.classList.remove('on'));
  const tabs={ov:0,pl:1,rm:2,mp:3,rp:4,lg:5,bc:6,st:7};
  const items=document.querySelectorAll('.adm-ni');
  if(items[tabs[tab]]) items[tabs[tab]].classList.add('on');
  const m=document.getElementById('adm-main');
  if(!m) return;
  if(tab==='ov'){
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Visão Geral</h2>
    <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:10px;margin-bottom:20px">
      ${[['3,241','Online'],['52','Salas'],['16','Jogos'],['1.4K','Mapas'],['28','Denúncias'],['99ms','Latência'],['10','Admins'],['47K','Usuários']].map(([v,l])=>`<div style="background:var(--s1);border:1px solid var(--bd);border-radius:9px;padding:14px;text-align:center"><div style="font-family:var(--fm);font-size:1.5rem;color:var(--o)">${v}</div><div style="font-size:.7rem;color:var(--mu);margin-top:3px">${l}</div></div>`).join('')}
    </div>
    <div class="adm-card"><h3>Atividade Recente</h3>
      ${[['KingSlayer criou sala Terror Extreme','2min','sala'],['NovaStar publicou mapa Arena Neon','5min','mapa'],['3 jogadores entraram em Futebol Pros','8min','sala'],['Denúncia de spam recebida','12min','alerta'],['Servidor atualizado v3.1.0','1h','sistema']].map(([msg,t,type])=>`<div style="display:flex;align-items:center;gap:10px;padding:7px 0;border-bottom:1px solid rgba(255,255,255,.03)"><span style="font-size:.68rem;padding:2px 7px;border-radius:3px;background:rgba(255,107,0,.1);color:var(--o);white-space:nowrap">${type}</span><span style="flex:1;font-size:.82rem">${msg}</span><span style="font-size:.7rem;color:var(--mu)">${t}</span></div>`).join('')}
    </div>
    <div class="adm-card"><h3>Contas Admin (${ADM_ACCOUNTS.length})</h3>
      <table class="adt"><thead><tr><th>Usuário</th><th>Papel</th><th>Desde</th><th>Status</th></tr></thead>
      <tbody>${ADM_ACCOUNTS.map(a=>`<tr><td style="font-weight:700;font-family:var(--fm)">${a.u}</td><td style="font-size:.78rem;color:var(--o)">${a.role}</td><td style="font-size:.75rem;color:var(--mu)">${a.since}</td><td><span style="color:var(--g);font-size:.72rem">Ativo</span></td></tr>`).join('')}</tbody>
      </table>
    </div>`;
  } else if(tab==='pl'){
    const pls=PLAYERS.slice(0,12).map(p=>({n:p,st:Math.random()>.3?'online':'offline',room:Math.random()>.5?ROOMS_DATA[Math.floor(Math.random()*ROOMS_DATA.length)].name:'—',warns:Math.floor(Math.random()*3)}));
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Jogadores</h2>
    <div class="adm-card"><table class="adt">
      <thead><tr><th>Jogador</th><th>Status</th><th>Sala</th><th>Avisos</th><th>Ações</th></tr></thead>
      <tbody>${pls.map(p=>`<tr>
        <td style="font-weight:700">${p.n}</td>
        <td><span style="color:${p.st==='online'?'var(--g)':'var(--mu)'};font-size:.78rem">${p.st==='online'?'● online':'○ offline'}</span></td>
        <td style="font-size:.78rem;color:var(--mu)">${p.room}</td>
        <td><span style="color:${p.warns>1?'var(--r)':'var(--mu)'};font-size:.75rem">${p.warns}</span></td>
        <td><div class="aa">
          <button class="aab aak" onclick="adAct('kick','${p.n}')">Kick</button>
          <button class="aab aam" onclick="adAct('mute','${p.n}')">Mute</button>
          <button class="aab aaban" onclick="adAct('ban','${p.n}')">Ban</button>
          <button class="aab aams" onclick="adAct('msg','${p.n}')">Msg</button>
        </div></td>
      </tr>`).join('')}
      </tbody></table></div>`;
  } else if(tab==='bc'){
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Broadcast Global</h2>
    <div class="adm-card">
      <h3>Enviar para todos</h3>
      <div class="osec"><div class="olbl">Tipo</div>
        <div class="ogrp">
          <button class="ob sel" onclick="setOpt(this,'bc-t','aviso')">Aviso</button>
          <button class="ob" onclick="setOpt(this,'bc-t','evento')">Evento</button>
          <button class="ob" onclick="setOpt(this,'bc-t','manut')">Manutenção</button>
          <button class="ob" onclick="setOpt(this,'bc-t','alerta')">Alerta</button>
        </div>
      </div>
      <div style="display:flex;gap:8px">
        <input id="bc-inp" style="flex:1;background:var(--s3);border:1px solid var(--bd);color:var(--w);padding:9px 12px;border-radius:7px;font-family:var(--f);font-size:.88rem;outline:none" placeholder="Mensagem para todos...">
        <button class="btn btn-o btn-md" onclick="sendBC()">Enviar</button>
      </div>
    </div>
    <div class="adm-card"><h3>Histórico</h3>
      ${[['Evento Terror este fim de semana!','2h'],['Manutenção amanhã 2h','1 dia'],['Novo mapa Labirinto Maldito!','3 dias']].map(([mg,t])=>`<div style="display:flex;justify-content:space-between;padding:7px 0;border-bottom:1px solid rgba(255,255,255,.03);font-size:.82rem"><span>${mg}</span><span style="color:var(--mu)">${t}</span></div>`).join('')}
    </div>`;
  } else if(tab==='mp'){
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Mapas</h2>
    <div class="adm-card"><table class="adt">
      <thead><tr><th>Mapa</th><th>Autor</th><th>Cat</th><th>Stars</th><th>Plays</th><th>Ações</th></tr></thead>
      <tbody>${COMM_MAPS.map(mp=>`<tr>
        <td style="font-weight:700">${mp.name}</td>
        <td style="font-size:.78rem;color:var(--mu)">${mp.author}</td>
        <td style="font-size:.75rem">${mp.cat}</td>
        <td style="font-size:.78rem;color:var(--y)">${mp.r}</td>
        <td style="font-size:.78rem">${mp.plays.toLocaleString()}</td>
        <td><div class="aa">
          <button class="aab aams" onclick="toast('Aprovado!','ok')">Aprovar</button>
          <button class="aab aaban" onclick="toast('Removido.','err')">Remover</button>
        </div></td>
      </tr>`).join('')}</tbody>
    </table></div>`;
  } else if(tab==='rp'){
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Denúncias</h2>
    <div class="adm-card"><table class="adt">
      <thead><tr><th>De</th><th>Contra</th><th>Motivo</th><th>Status</th><th>Ações</th></tr></thead>
      <tbody>${[
        [rp(),rp(),'Spam','Pendente'],[rp(),rp(),'Tóxico','Pendente'],
        [rp(),rp(),'Trapaça','Analisando'],[rp(),rp(),'Mapa impróprio','Resolvido'],
      ].map(([f,c,mo,s])=>`<tr>
        <td style="font-size:.78rem">${f}</td>
        <td style="color:var(--r);font-size:.78rem">${c}</td>
        <td style="font-size:.78rem">${mo}</td>
        <td><span style="font-size:.68rem;padding:2px 7px;border-radius:3px;background:${s==='Resolvido'?'rgba(0,230,118,.1)':'rgba(255,215,64,.1)'};color:${s==='Resolvido'?'var(--g)':'var(--y)'}">${s}</span></td>
        <td><div class="aa">
          <button class="aab aaban" onclick="toast('Punição aplicada','ok')">Punir</button>
          <button class="aab aams" onclick="toast('Arquivado.')">Arquivar</button>
        </div></td>
      </tr>`).join('')}</tbody>
    </table></div>`;
  } else if(tab==='lg'){
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Logs</h2>
    <div class="adm-card"><div style="font-family:var(--fm);font-size:.75rem;display:flex;flex-direction:column;gap:5px">
      ${[['INFO','Servidor reiniciado','1h'],['WARN','Latência alta >200ms','3h'],['INFO','Backup realizado','6h'],['ERROR','3 conexões perdidas','8h'],['INFO','Mapa aprovado: Arena Neon','10h'],['WARN','Spam detectado — mute auto','12h'],['INFO','Atualização v3.1.0','1 dia'],['INFO','Pico 3.800 jogadores simultâneos','2 dias']].map(([l,msg,t])=>`<div style="display:flex;gap:10px;padding:5px 0;border-bottom:1px solid rgba(255,255,255,.03)">
        <span style="color:${l==='ERROR'?'var(--r)':l==='WARN'?'var(--y)':'var(--mu)'};min-width:45px">[${l}]</span>
        <span style="flex:1">${msg}</span>
        <span style="color:var(--mu)">${t}</span>
      </div>`).join('')}
    </div></div>`;
  } else if(tab==='st'){
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Configurações</h2>
    <div class="adm-card"><h3>Servidor</h3>
      ${[['Max por Sala','16'],['Cooldown Chat (s)','2'],['Max Avisos Ban','3'],['Anti-Spam','Ativo'],['Modo Manutenção','Desativado'],['Max Bots por Jogo','6']].map(([k,v])=>`<div style="display:flex;align-items:center;justify-content:space-between;padding:9px 0;border-bottom:1px solid rgba(255,255,255,.03)">
        <span style="font-size:.85rem">${k}</span>
        <span style="font-family:var(--fm);font-size:.78rem;color:var(--c);background:rgba(0,245,255,.06);padding:3px 10px;border-radius:5px">${v}</span>
      </div>`).join('')}
      <button class="btn btn-o btn-md" style="margin-top:12px" onclick="toast('Salvo!','ok')">Salvar</button>
    </div>`;
  } else if(tab==='rm'){
    m.innerHTML=`<h2 style="font-family:var(--fm);color:var(--o);margin-bottom:16px">Salas Ativas</h2>
    <div class="adm-card"><table class="adt">
      <thead><tr><th>Sala</th><th>Jogo</th><th>Host</th><th>Jogadores</th><th>Ações</th></tr></thead>
      <tbody>${ROOMS_DATA.map(r=>`<tr>
        <td style="font-weight:700;font-family:var(--fm)">${r.name}</td>
        <td style="font-size:.78rem">${r.game}</td>
        <td style="color:var(--mu);font-size:.78rem">${r.host}</td>
        <td style="font-size:.78rem">${r.players}/${r.max}</td>
        <td><div class="aa">
          <button class="aab aak" onclick="toast('Admin entrou na sala','ok')">Entrar</button>
          <button class="aab aaban" onclick="toast('Sala fechada.','err')">Fechar</button>
          <button class="aab aam" onclick="toast('Partida reiniciada.')">Reiniciar</button>
        </div></td>
      </tr>`).join('')}</tbody>
    </table></div>`;
  }
}

function adAct(a,p){
  const m={kick:`${p} removido.`,mute:`${p} silenciado por 10min.`,ban:`${p} banido.`,msg:`Msg enviada para ${p}.`};
  toast(m[a]||'Feito.',a==='ban'?'err':'warn');
}
function sendBC(){
  const i=document.getElementById('bc-inp');
  if(!i||!i.value.trim()) return;
  document.getElementById('ga-txt').textContent='ADMIN: '+i.value;
  document.getElementById('galert').classList.add('on');
  i.value=''; toast('Broadcast enviado!','ok');
}


// ═══════════════════════════════════════
// SOUND ENGINE (Web Audio API)
// ═══════════════════════════════════════
let audioCtx=null;
let audioUnlocked=false;

function getAudioCtx(){
  if(!audioCtx){
    try{ audioCtx=new(window.AudioContext||window.webkitAudioContext)(); }catch(e){ return null; }
  }
  // Resume if suspended (browser autoplay policy)
  if(audioCtx.state==='suspended') audioCtx.resume();
  return audioCtx;
}

// Unlock audio on first user interaction
function unlockAudio(){
  if(audioUnlocked) return;
  audioUnlocked=true;
  try{
    const ctx=getAudioCtx();
    if(!ctx) return;
    // Play silent buffer to unlock
    const buf=ctx.createBuffer(1,1,22050);
    const src=ctx.createBufferSource();
    src.buffer=buf; src.connect(ctx.destination); src.start(0);
    if(ctx.state==='suspended') ctx.resume();
  }catch(e){}
}
document.addEventListener('click', unlockAudio, {once:false});
document.addEventListener('keydown', unlockAudio, {once:false});
document.addEventListener('touchstart', unlockAudio, {once:false});

function playSound(type){
  try{
    const ctx=getAudioCtx();
    const o=ctx.createOscillator();
    const g=ctx.createGain();
    o.connect(g); g.connect(ctx.destination);
    const now=ctx.currentTime;
    if(type==='kick'){
      // Thump
      o.type='sine'; o.frequency.setValueAtTime(180,now); o.frequency.exponentialRampToValueAtTime(40,now+0.15);
      g.gain.setValueAtTime(0.5,now); g.gain.exponentialRampToValueAtTime(0.001,now+0.18);
      o.start(now); o.stop(now+0.2);
    } else if(type==='throw'){
      o.type='triangle'; o.frequency.setValueAtTime(520,now); o.frequency.linearRampToValueAtTime(280,now+0.12);
      g.gain.setValueAtTime(0.3,now); g.gain.exponentialRampToValueAtTime(0.001,now+0.14);
      o.start(now); o.stop(now+0.15);
    } else if(type==='grab'){
      o.type='square'; o.frequency.setValueAtTime(800,now); o.frequency.linearRampToValueAtTime(1200,now+0.06);
      g.gain.setValueAtTime(0.15,now); g.gain.exponentialRampToValueAtTime(0.001,now+0.08);
      o.start(now); o.stop(now+0.1);
    } else if(type==='goal'){
      // Fanfare
      [523,659,784,1047].forEach((freq,i)=>{
        const oo=ctx.createOscillator(), gg=ctx.createGain();
        oo.connect(gg); gg.connect(ctx.destination);
        oo.type='triangle'; oo.frequency.value=freq;
        const t=now+i*0.1;
        gg.gain.setValueAtTime(0,t); gg.gain.linearRampToValueAtTime(0.3,t+0.02);
        gg.gain.exponentialRampToValueAtTime(0.001,t+0.25);
        oo.start(t); oo.stop(t+0.3);
      });
    } else if(type==='type'){
      // Typing blip
      o.type='square'; o.frequency.value=600+Math.random()*400;
      g.gain.setValueAtTime(0.06,now); g.gain.exponentialRampToValueAtTime(0.001,now+0.05);
      o.start(now); o.stop(now+0.055);
    } else if(type==='click'){
      o.type='square'; o.frequency.setValueAtTime(900,now);
      g.gain.setValueAtTime(0.07,now); g.gain.exponentialRampToValueAtTime(0.001,now+0.04);
      o.start(now); o.stop(now+0.05);
    } else if(type==='nav'){
      o.type='sine'; o.frequency.setValueAtTime(440,now); o.frequency.linearRampToValueAtTime(660,now+0.07);
      g.gain.setValueAtTime(0.08,now); g.gain.exponentialRampToValueAtTime(0.001,now+0.1);
      o.start(now); o.stop(now+0.12);
    }
  }catch(e){}
}

// Background ambient music (generative — relaxing pads)
let bgMusicNode=null, bgMusicPlaying=false;
function startBgMusic(){
  if(bgMusicPlaying) return;
  try{
    const ctx=getAudioCtx();
    bgMusicPlaying=true;
    const master=ctx.createGain(); master.gain.value=0.12; master.connect(ctx.destination);
    // Chord progression: Am - F - C - G in loop
    const chords=[[220,277,330],[175,220,262],[131,165,196],[147,185,220]];
    let ci=0;
    function playChord(){
      if(!bgMusicPlaying) return;
      const chord=chords[ci%chords.length]; ci++;
      chord.forEach(freq=>{
        const o=ctx.createOscillator(), g2=ctx.createGain();
        o.type='sine'; o.frequency.value=freq;
        o.connect(g2); g2.connect(master);
        const now=ctx.currentTime;
        g2.gain.setValueAtTime(0,now);
        g2.gain.linearRampToValueAtTime(0.25,now+0.4);
        g2.gain.linearRampToValueAtTime(0.18,now+1.5);
        g2.gain.linearRampToValueAtTime(0,now+2.8);
        o.start(now); o.stop(now+3.0);
      });
      // Sub bass
      const bass=ctx.createOscillator(), bg=ctx.createGain();
      bass.type='sine'; bass.frequency.value=chord[0]/2;
      bass.connect(bg); bg.connect(master);
      const now=ctx.currentTime;
      bg.gain.setValueAtTime(0,now); bg.gain.linearRampToValueAtTime(0.3,now+0.2);
      bg.gain.linearRampToValueAtTime(0,now+2.5);
      bass.start(now); bass.stop(now+2.8);
      setTimeout(playChord, 2800);
    }
    playChord();
    bgMusicNode=master;
  }catch(e){}
}
function stopBgMusic(){
  bgMusicPlaying=false;
  try{ if(bgMusicNode) bgMusicNode.gain.linearRampToValueAtTime(0, getAudioCtx().currentTime+1); }catch(e){}
}
function toggleBgMusic(){
  if(bgMusicPlaying){ stopBgMusic(); }
  else{ startBgMusic(); }
  document.getElementById('mus-btn').textContent=bgMusicPlaying?'♫':'♪';
}

// Typing sound on all inputs
document.addEventListener('keypress', e=>{
  // Only on text inputs, not game
  if(!S.running && e.target && (e.target.tagName==='INPUT'||e.target.tagName==='TEXTAREA')){
    playSound('type');
  }
});
// Nav click sounds
document.addEventListener('click', e=>{
  const btn=e.target.closest('button,.btn,.tnb,.ob,.fch,.gcplay,.aiq');
  if(btn&&!S.running) playSound('click');
});



// ═══════════════════════════════════════
// PROFILE SYSTEM — NeBux, Wardrobe, Groups
// ═══════════════════════════════════════
const PROFILE = {
  name:'Jogador', bio:'Sem bio ainda.',
  nebux:6000, xp:100, level:1,
  favGames:[], profileColor:'#00f5ff',
  myGroups:[], equipped:{},
  owned:['hair_default','shirt_white','pants_black','shoes_white']
};

const RARITY_COLORS={common:'#aaaaaa',rare:'#4488ff',epic:'#cc44ff',legendary:'#ffcc00'};

const WARDROBE_ITEMS=[
  // HAIR
  {id:'hair_default',cat:'hair',name:'Cabelo Padrão',emoji:'💇',price:0,rarity:'common'},
  {id:'hair_afro',cat:'hair',name:'Afro',emoji:'🌟',price:200,rarity:'rare'},
  {id:'hair_spiky',cat:'hair',name:'Espetado',emoji:'⚡',price:350,rarity:'rare'},
  {id:'hair_rainbow',cat:'hair',name:'Arco-íris',emoji:'🌈',price:1200,rarity:'epic'},
  {id:'hair_golden',cat:'hair',name:'Dourado Lendário',emoji:'👑',price:4500,rarity:'legendary'},
  {id:'hair_dreadlocks',cat:'hair',name:'Dreadlocks',emoji:'🎵',price:400,rarity:'rare'},
  // SHIRT
  {id:'shirt_white',cat:'shirt',name:'Camiseta Branca',emoji:'👕',price:0,rarity:'common'},
  {id:'shirt_striped',cat:'shirt',name:'Listrada Vermelha',emoji:'🎽',price:150,rarity:'common'},
  {id:'shirt_hoodie',cat:'shirt',name:'Moletom',emoji:'🧥',price:300,rarity:'rare'},
  {id:'shirt_neon',cat:'shirt',name:'Neon Glow',emoji:'💡',price:800,rarity:'epic'},
  {id:'shirt_dragon',cat:'shirt',name:'Dragão Lendário',emoji:'🐉',price:5000,rarity:'legendary'},
  {id:'shirt_galaxy',cat:'shirt',name:'Galáxia',emoji:'🌌',price:2200,rarity:'epic'},
  // PANTS
  {id:'pants_black',cat:'pants',name:'Calça Preta',emoji:'👖',price:0,rarity:'common'},
  {id:'pants_jeans',cat:'pants',name:'Jeans',emoji:'🔵',price:120,rarity:'common'},
  {id:'pants_camo',cat:'pants',name:'Camuflado',emoji:'🌿',price:280,rarity:'rare'},
  {id:'pants_plaid',cat:'pants',name:'Xadrez',emoji:'🟦',price:200,rarity:'common'},
  {id:'pants_cyber',cat:'pants',name:'Cyberpunk',emoji:'⚡',price:900,rarity:'epic'},
  {id:'pants_lava',cat:'pants',name:'Lava Lendária',emoji:'🔥',price:3800,rarity:'legendary'},
  // SHOES
  {id:'shoes_white',cat:'shoes',name:'Tênis Branco',emoji:'👟',price:0,rarity:'common'},
  {id:'shoes_red',cat:'shoes',name:'All-Star Vermelho',emoji:'🔴',price:180,rarity:'common'},
  {id:'shoes_gold',cat:'shoes',name:'Ouro Puro',emoji:'🥇',price:2000,rarity:'rare'},
  {id:'shoes_air',cat:'shoes',name:'Air Nexus',emoji:'💨',price:1500,rarity:'rare'},
  {id:'shoes_neon',cat:'shoes',name:'Neon Flash',emoji:'🌟',price:1800,rarity:'epic'},
  {id:'shoes_dragon',cat:'shoes',name:'Garras do Dragão',emoji:'🐉',price:6000,rarity:'legendary'},
  // HAT
  {id:'hat_cap',cat:'hat',name:'Boné',emoji:'🧢',price:100,rarity:'common'},
  {id:'hat_top',cat:'hat',name:'Cartola',emoji:'🎩',price:400,rarity:'rare'},
  {id:'hat_crown',cat:'hat',name:'Coroa Real',emoji:'👑',price:8000,rarity:'legendary'},
  {id:'hat_beanie',cat:'hat',name:'Touca',emoji:'🔵',price:150,rarity:'common'},
  {id:'hat_cowboy',cat:'hat',name:'Cowboy',emoji:'🤠',price:350,rarity:'rare'},
  // ACCESSORIES
  {id:'acc_glasses',cat:'acc',name:'Óculos',emoji:'🕶️',price:250,rarity:'common'},
  {id:'acc_scarf',cat:'acc',name:'Cachecol',emoji:'🧣',price:200,rarity:'common'},
  {id:'acc_wings',cat:'acc',name:'Asas de Anjo',emoji:'👼',price:3500,rarity:'epic'},
  {id:'acc_halo',cat:'acc',name:'Auréola Divina',emoji:'😇',price:7500,rarity:'legendary'},
  {id:'acc_chains',cat:'acc',name:'Correntes',emoji:'⛓️',price:600,rarity:'rare'},
  {id:'acc_glitch',cat:'acc',name:'Glitch Épico',emoji:'👾',price:2500,rarity:'epic'},
];

// Generate 840 groups
const GROUP_ICONS=['⚽','🏀','🎮','🎯','🏆','🎵','🎨','🔥','💎','🚀','🦁','🐲','⚡','🌟','🏹','🎭','🌈','🤖','🦊','🏋️'];
const GROUP_NAMES=['Elite Squad','Pro Players','Casuals','Terror Masters','Speed Runners','Top Aimers','Builders Guild','Night Owls','Champions','Legends','Rookies','Vets','Free Style','Dark Matter','Solar Wind','Iron Fist','Crystal','Nova','Phoenix','Thunder'];
const ALL_GROUPS=[];
for(let i=0;i<840;i++){
  ALL_GROUPS.push({
    id:i,
    name:GROUP_NAMES[i%GROUP_NAMES.length]+' '+(Math.floor(i/GROUP_NAMES.length)+1),
    icon:GROUP_ICONS[i%GROUP_ICONS.length],
    members:Math.floor(Math.random()*5000)+50,
    tag:['Esportes','Ação','Terror','Casual','Competitivo','Social'][i%6],
    joined:false
  });
}

let wdCurrentFilter='all', shopCurrentFilter='all';
let wardrobeScene=null, wardrobeCamera=null, wardrobeRenderer=null, wardrobeBotGroup=null;

// ── PROFILE TABS ──────────────────────────────────────────────────────
function profTab(tab, btn){
  ['overview','wardrobe','shop','groups','edit'].forEach(t=>{
    const el=document.getElementById('prof-'+t);
    if(el) el.style.display='none';
  });
  document.querySelectorAll('#page-profile .ctab').forEach(b=>b.classList.remove('on'));
  const el=document.getElementById('prof-'+tab);
  if(el) el.style.display='';
  if(btn) btn.classList.add('on');
  else {
    // Find tab button by label
    document.querySelectorAll('#page-profile .ctab').forEach(b=>{
      if(b.textContent.toLowerCase().includes(tab.slice(0,4))) b.classList.add('on');
    });
  }
  if(tab==='wardrobe') initWardrobeView();
  if(tab==='shop') renderShop();
  if(tab==='groups') renderGroups();
  if(tab==='edit') initEditProfile();
  if(tab==='overview') renderProfileOverview();
}

// ── WARDROBE 3D ───────────────────────────────────────────────────────
function initWardrobeView(){
  const cv=document.getElementById('wardrobe-canvas');
  if(!cv||cv._init) return; cv._init=true;
  try{
    const sc=new THREE.Scene();
    sc.background=new THREE.Color(0x080018);
    sc.add(new THREE.AmbientLight(0x334466,1.2));
    const dl=new THREE.DirectionalLight(0xffffff,1.2);
    dl.position.set(3,6,4); sc.add(dl);
    const pl=new THREE.PointLight(0x00f5ff,2,8);
    pl.position.set(-2,3,2); sc.add(pl);

    const cam=new THREE.PerspectiveCamera(45,cv.width/cv.height,.1,50);
    cam.position.set(0,1.5,3.5);

    const ren=new THREE.WebGLRenderer({canvas:cv,antialias:true,alpha:true});
    ren.setSize(cv.width,cv.height); ren.shadowMap.enabled=true;

    // Build avatar body matching equipped items
    wardrobeBotGroup=buildWardrobeFigure(PROFILE.equipped);
    sc.add(wardrobeBotGroup);

    // Rotating platform
    const platform=new THREE.Mesh(new THREE.CylinderGeometry(1,.9,.1,24),
      new THREE.MeshStandardMaterial({color:0x1a1a2e,roughness:.3,metalness:.5}));
    platform.position.y=-.05; sc.add(platform);
    const pGlow=new THREE.PointLight(0x00f5ff,1.5,3);
    pGlow.position.y=.2; sc.add(pGlow);

    wardrobeScene=sc; wardrobeCamera=cam; wardrobeRenderer=ren;
    let t2=0;
    function loop(){
      requestAnimationFrame(loop);
      t2+=0.012;
      if(wardrobeBotGroup) wardrobeBotGroup.rotation.y=t2;
      ren.render(sc,cam);
    }
    loop();
  }catch(e){console.warn('Wardrobe 3D error:',e);}
  renderWardrobeItems();
}

function buildWardrobeFigure(equipped){
  const g=new THREE.Group();
  // Skin color
  const skinCol=0xffcc99;
  // Body colors from equipped items
  const shirtCol=equipped.shirt?getItemColor(equipped.shirt):0xffffff;
  const pantsCol=equipped.pants?getItemColor(equipped.pants):0x111111;
  // Head
  const head=new THREE.Mesh(new THREE.SphereGeometry(.35,12,12),
    new THREE.MeshStandardMaterial({color:skinCol,roughness:.7}));
  head.position.y=1.75; g.add(head);
  // Hair
  if(equipped.hair&&equipped.hair!=='hair_default'){
    const hairCol=getItemColor(equipped.hair);
    const hair=new THREE.Mesh(new THREE.SphereGeometry(.38,.38,.25,12),
      new THREE.MeshStandardMaterial({color:hairCol,roughness:.8}));
    hair.position.y=2.0; g.add(hair);
  }
  // Hat
  if(equipped.hat){
    const hatCol=getItemColor(equipped.hat);
    const hat=new THREE.Mesh(new THREE.CylinderGeometry(.42,.4,.22,10),
      new THREE.MeshStandardMaterial({color:hatCol,roughness:.5,metalness:.2}));
    hat.position.y=2.15; g.add(hat);
  }
  // Eyes
  [-.12,.12].forEach(ex=>{
    const eye=new THREE.Mesh(new THREE.SphereGeometry(.06,6,6),
      new THREE.MeshBasicMaterial({color:0x111111}));
    eye.position.set(ex,1.8,.32); g.add(eye);
  });
  // Torso
  const torso=new THREE.Mesh(new THREE.BoxGeometry(.6,.65,.3),
    new THREE.MeshStandardMaterial({color:shirtCol,roughness:.6}));
  torso.position.y=1.15; g.add(torso);
  // Arms
  [-.42,.42].forEach(ax=>{
    const arm=new THREE.Mesh(new THREE.CylinderGeometry(.11,.1,.5,8),
      new THREE.MeshStandardMaterial({color:shirtCol,roughness:.6}));
    arm.position.set(ax,1.1,0); g.add(arm);
    const hand=new THREE.Mesh(new THREE.SphereGeometry(.11,6,6),
      new THREE.MeshStandardMaterial({color:skinCol,roughness:.7}));
    hand.position.set(ax,.82,0); g.add(hand);
  });
  // Legs
  [-.16,.16].forEach((lx,li)=>{
    const leg=new THREE.Mesh(new THREE.CylinderGeometry(.11,.1,.5,8),
      new THREE.MeshStandardMaterial({color:pantsCol,roughness:.7}));
    leg.position.set(lx,.5,0); g.add(leg);
    // Shoes
    const shoeCol=equipped.shoes?getItemColor(equipped.shoes):0xffffff;
    const shoe=new THREE.Mesh(new THREE.BoxGeometry(.18,.1,.28),
      new THREE.MeshStandardMaterial({color:shoeCol,roughness:.5}));
    shoe.position.set(lx,.22,.04); g.add(shoe);
  });
  // Accessories overlay
  if(equipped.acc){
    const accMesh=new THREE.Mesh(new THREE.TorusGeometry(.2,.04,6,12),
      new THREE.MeshStandardMaterial({color:getItemColor(equipped.acc),roughness:.3,metalness:.6}));
    accMesh.position.set(.35,1.5,.1); g.add(accMesh);
  }
  return g;
}

function getItemColor(id){
  const colors={
    hair_afro:0x1a0a00,hair_spiky:0xffdd00,hair_rainbow:0xff4488,hair_golden:0xffcc00,hair_dreadlocks:0x3a1800,
    shirt_striped:0xcc2222,shirt_hoodie:0x334466,shirt_neon:0x00ffaa,shirt_dragon:0xff4400,shirt_galaxy:0x220055,
    pants_jeans:0x224488,pants_camo:0x4a6a2a,pants_plaid:0x223388,pants_cyber:0x00ccff,pants_lava:0xff3300,
    shoes_red:0xcc2222,shoes_gold:0xddaa00,shoes_air:0x4488ff,shoes_neon:0x00ffcc,shoes_dragon:0x441100,
    hat_cap:0x224488,hat_top:0x111111,hat_crown:0xffcc00,hat_beanie:0x2244aa,hat_cowboy:0x6b3a0a,
    acc_glasses:0x002244,acc_scarf:0xcc2222,acc_wings:0xf0f0ff,acc_halo:0xffee00,acc_chains:0x888888,acc_glitch:0xff00ff
  };
  return colors[id]||0xaaaaaa;
}

function refreshWardrobeAvatar(){
  if(!wardrobeScene||!wardrobeBotGroup) return;
  wardrobeScene.remove(wardrobeBotGroup);
  wardrobeBotGroup=buildWardrobeFigure(PROFILE.equipped);
  wardrobeScene.add(wardrobeBotGroup);
  // Update equipped icons
  const ic=document.getElementById('wd-equipped-icons');
  if(ic) ic.innerHTML=Object.values(PROFILE.equipped).map(id=>{
    const item=WARDROBE_ITEMS.find(i=>i.id===id);
    return item?`<span title="${item.name}" style="font-size:1.2rem">${item.emoji}</span>`:'';
  }).join('');
}

function renderWardrobeItems(filter){
  const f=filter||wdCurrentFilter;
  const grid=document.getElementById('wardrobe-grid');
  if(!grid) return;
  const items=WARDROBE_ITEMS.filter(i=>f==='all'||i.cat===f);
  grid.innerHTML=items.map(item=>{
    const owned=PROFILE.owned.includes(item.id);
    const equipped=Object.values(PROFILE.equipped).includes(item.id);
    const rc=RARITY_COLORS[item.rarity];
    return `<div class="prof-item ${equipped?'equipped':''} rarity-${item.rarity}" 
      style="border-color:${rc}33;opacity:${owned?1:.55}"
      onclick="wdClickItem('${item.id}','${item.cat}')">
      <span class="item-emoji">${item.emoji}</span>
      <div class="item-name" style="color:${rc}">${item.name}</div>
      <div class="item-rarity-tag" style="background:${rc}22;color:${rc}">${item.rarity.toUpperCase()}</div>
      ${!owned?`<div class="item-price">💰 ${item.price} NB</div>`:'<div style="font-size:.65rem;color:var(--g)">✓ Possuído</div>'}
    </div>`;
  }).join('');
}

function wdFilter(f,btn){
  wdCurrentFilter=f;
  document.querySelectorAll('#prof-wardrobe .fch').forEach(b=>b.classList.remove('on'));
  if(btn) btn.classList.add('on');
  renderWardrobeItems(f);
}

function wdClickItem(id,cat){
  const item=WARDROBE_ITEMS.find(i=>i.id===id);
  if(!item) return;
  if(!PROFILE.owned.includes(id)){
    toast(`Compre na loja por 💰 ${item.price} NeBux!`,'warn'); return;
  }
  // Toggle equip
  if(PROFILE.equipped[cat]===id) delete PROFILE.equipped[cat];
  else PROFILE.equipped[cat]=id;
  renderWardrobeItems(); refreshWardrobeAvatar();
  renderProfileAvatarMini();
}

function randomOutfit(){
  const cats=['hair','shirt','pants','shoes','hat','acc'];
  cats.forEach(cat=>{
    const owned=WARDROBE_ITEMS.filter(i=>i.cat===cat&&PROFILE.owned.includes(i.id));
    if(owned.length>0) PROFILE.equipped[cat]=owned[Math.floor(Math.random()*owned.length)].id;
  });
  renderWardrobeItems(); refreshWardrobeAvatar();
}

function saveOutfit(){
  toast('Outfit salvo! 💾','ok'); playSound('nav');
}

// ── SHOP ──────────────────────────────────────────────────────────────
function renderShop(filter){
  const f=filter||shopCurrentFilter;
  const grid=document.getElementById('shop-grid');
  const nb=document.getElementById('shop-nebux-disp');
  if(nb) nb.textContent=PROFILE.nebux.toLocaleString();
  if(!grid) return;
  const items=WARDROBE_ITEMS.filter(i=>{
    if(f==='all') return !PROFILE.owned.includes(i.id);
    if(f==='rare') return i.rarity==='rare'&&!PROFILE.owned.includes(i.id);
    if(f==='epic') return i.rarity==='epic'&&!PROFILE.owned.includes(i.id);
    if(f==='legendary') return i.rarity==='legendary'&&!PROFILE.owned.includes(i.id);
    if(f==='common') return i.rarity==='common'&&!PROFILE.owned.includes(i.id);
    return true;
  });
  const rc_map={common:'#aaaaaa',rare:'#4488ff',epic:'#cc44ff',legendary:'#ffcc00'};
  grid.innerHTML=items.map(item=>{
    const rc=rc_map[item.rarity];
    const canAfford=PROFILE.nebux>=item.price;
    return `<div class="prof-item rarity-${item.rarity}" style="border-color:${rc}44;opacity:${canAfford?1:.6}" onclick="buyItem('${item.id}')">
      <span class="item-emoji">${item.emoji}</span>
      <div class="item-name" style="color:${rc};font-size:.75rem">${item.name}</div>
      <div class="item-rarity-tag" style="background:${rc}22;color:${rc};margin-bottom:5px">${item.rarity.toUpperCase()}</div>
      <div class="item-price" style="font-size:.75rem">💰 ${item.price.toLocaleString()} NeBux</div>
      <button class="btn btn-sm ${canAfford?'btn-c':'btn-g'}" style="width:100%;margin-top:6px;font-size:.65rem" onclick="event.stopPropagation();buyItem('${item.id}')">
        ${canAfford?'Comprar':'Sem NeBux'}
      </button>
    </div>`;
  }).join('')||'<div style="color:var(--mu);padding:20px;text-align:center">Todos os itens desta raridade já foram comprados! 🎉</div>';
}

function shopFilter(f,btn){
  shopCurrentFilter=f;
  document.querySelectorAll('#prof-shop .fch').forEach(b=>b.classList.remove('on'));
  if(btn) btn.classList.add('on');
  renderShop(f);
}

function buyItem(id){
  const item=WARDROBE_ITEMS.find(i=>i.id===id);
  if(!item) return;
  if(PROFILE.owned.includes(id)){ toast('Você já tem este item!','warn'); return; }
  if(PROFILE.nebux<item.price){ toast('NeBux insuficiente! 💸','warn'); return; }
  PROFILE.nebux-=item.price;
  PROFILE.owned.push(id);
  toast(`✅ ${item.emoji} ${item.name} comprado!`,'ok');
  playSound('goal');
  renderShop();
  const nb=document.getElementById('shop-nebux-disp');
  if(nb) nb.textContent=PROFILE.nebux.toLocaleString();
  const nb2=document.getElementById('p-nebux-disp');
  if(nb2) nb2.textContent=PROFILE.nebux.toLocaleString();
}

// ── GROUPS ────────────────────────────────────────────────────────────
let groupsOffset=0;
function renderGroups(searchTerm){
  const myGr=document.getElementById('my-groups');
  const grid=document.getElementById('groups-grid');
  if(myGr) myGr.innerHTML=PROFILE.myGroups.length>0
    ? PROFILE.myGroups.map(id=>{
        const gr=ALL_GROUPS.find(g=>g.id===id);
        return gr?`<div style="background:rgba(0,230,118,.08);border:1px solid rgba(0,230,118,.2);color:var(--g);padding:5px 12px;border-radius:20px;font-size:.75rem;display:flex;align-items:center;gap:5px;cursor:pointer" onclick="leaveGroup(${id})">
          ${gr.icon} ${gr.name} <span style="color:var(--mu);font-size:.65rem">✕</span></div>`:'';
      }).join('')
    : '<div style="color:var(--mu);font-size:.8rem">Nenhum grupo ainda. Entre em um!</div>';

  if(!grid) return;
  const term=(searchTerm||'').toLowerCase();
  const filtered=ALL_GROUPS.filter(g=>!PROFILE.myGroups.includes(g.id)&&
    (g.name.toLowerCase().includes(term)||g.tag.toLowerCase().includes(term)));
  grid.innerHTML=filtered.slice(0,60).map(g=>`
    <div class="group-card ${PROFILE.myGroups.includes(g.id)?'joined':''}">
      <div class="group-icon">${g.icon}</div>
      <div class="group-name">${g.name}</div>
      <div class="group-meta">${g.members.toLocaleString()} membros · ${g.tag}</div>
      <button class="btn btn-sm ${PROFILE.myGroups.includes(g.id)?'btn-g':'btn-c'}" 
        style="margin-top:8px;width:100%" onclick="toggleGroup(${g.id})">
        ${PROFILE.myGroups.includes(g.id)?'✓ Saír':'+ Entrar'}
      </button>
    </div>`).join('');
}

function filterGroups(val){ renderGroups(val); }
function toggleGroup(id){
  const idx=PROFILE.myGroups.indexOf(id);
  if(idx>-1){ PROFILE.myGroups.splice(idx,1); toast('Saiu do grupo','warn'); }
  else if(PROFILE.myGroups.length>=10){ toast('Máximo 10 grupos!','warn'); return; }
  else { PROFILE.myGroups.push(id); toast('Grupo entrado! 👥','ok'); }
  renderGroups(document.getElementById('group-search')?.value||'');
  updateProfileGroupsMini();
}
function leaveGroup(id){ toggleGroup(id); }

// ── EDIT PROFILE ──────────────────────────────────────────────────────
function initEditProfile(){
  const nameInp=document.getElementById('edit-name');
  const bioInp=document.getElementById('edit-bio');
  if(nameInp) nameInp.value=PROFILE.name;
  if(bioInp) bioInp.value=PROFILE.bio;
  // Restore gender buttons
  document.querySelectorAll('.gender-btn').forEach(b=>{
    b.classList.remove('on','on-f');
    const g=b.dataset.g||b.getAttribute('data-g');
    if(g===PROFILE.gender) b.classList.add(g==='f'?'on-f':'on');
  });
  // Fav games picker
  const picker=document.getElementById('fav-games-picker');
  if(picker) picker.innerHTML=GAMES_DATA.slice(0,16).map(g=>`
    <span onclick="toggleFavGame('${g.id}',this)" 
      style="background:${PROFILE.favGames.includes(g.id)?'rgba(0,245,255,.12)':'var(--s2)'};
      border:1px solid ${PROFILE.favGames.includes(g.id)?'var(--c)':'var(--bd)'};
      color:${PROFILE.favGames.includes(g.id)?'var(--c)':'var(--mu)'};
      padding:4px 10px;border-radius:20px;font-size:.72rem;cursor:pointer;transition:all .2s;
      display:inline-flex;align-items:center;gap:4px">
      ${GAME_ICONS[g.id]||'🎮'} ${g.name}
    </span>`).join('');
  // Color picker
  const colPicker=document.getElementById('profile-color-picker');
  const cols=['#00f5ff','#ff6b00','#ff1744','#ffd740','#d500f9','#00e676','#ff006e','#4488ff'];
  if(colPicker) colPicker.innerHTML=cols.map(c=>`
    <div onclick="setProfileColor('${c}')" style="width:28px;height:28px;border-radius:50%;background:${c};cursor:pointer;
      border:3px solid ${PROFILE.profileColor===c?'#fff':'transparent'};transition:all .2s"></div>`).join('');
}
function toggleFavGame(id,el){
  const idx=PROFILE.favGames.indexOf(id);
  if(idx>-1) PROFILE.favGames.splice(idx,1); else if(PROFILE.favGames.length<5) PROFILE.favGames.push(id);
  el.style.background=PROFILE.favGames.includes(id)?'rgba(0,245,255,.12)':'var(--s2)';
  el.style.borderColor=PROFILE.favGames.includes(id)?'var(--c)':'var(--bd)';
  el.style.color=PROFILE.favGames.includes(id)?'var(--c)':'var(--mu)';
}
function setProfileColor(c){ PROFILE.profileColor=c; initEditProfile(); }
function saveProfile(){
  PROFILE.name=document.getElementById('edit-name')?.value||PROFILE.name;
  PROFILE.bio=document.getElementById('edit-bio')?.value||PROFILE.bio;
  S.user=PROFILE.name;
  // Update all displays
  document.getElementById('av-btn').textContent=PROFILE.name[0].toUpperCase();
  document.getElementById('topbar-nebux').textContent=PROFILE.nebux.toLocaleString();
  renderProfileOverview();
  saveProfileLS();
  toast('Perfil salvo! ✅','ok'); playSound('nav');
}

// ── OVERVIEW RENDER ───────────────────────────────────────────────────
function renderProfileOverview(){
  document.getElementById('p-name-disp').textContent=PROFILE.name;
  document.getElementById('p-bio-disp').textContent=PROFILE.bio;
  document.getElementById('p-nebux-disp').textContent=PROFILE.nebux.toLocaleString();
  const xpForLevel=PROFILE.level*1000;
  const xpPct=Math.min(100,(PROFILE.xp%xpForLevel)/xpForLevel*100);
  document.getElementById('p-xpfill').style.width=xpPct+'%';
  document.getElementById('p-level-disp').textContent='Nível '+PROFILE.level;
  document.getElementById('p-xp-disp').textContent=(PROFILE.xp%xpForLevel)+'/'+xpForLevel+' XP';
  // Fav games
  const fg=document.getElementById('p-fav-games-disp');
  if(fg) fg.innerHTML=PROFILE.favGames.map(id=>{
    const g=GAMES_DATA.find(g=>g.id===id);
    return g?`<span style="font-size:1.1rem" title="${g.name}">${GAME_ICONS[id]||'🎮'}</span>`:'';
  }).join('');
  updateProfileGroupsMini();
  renderProfileAvatarMini();
}

function renderProfileAvatarMini(){
  const cv=document.getElementById('avatar-canvas-profile');
  if(!cv) return;
  try{
    const sc=new THREE.Scene();
    sc.background=new THREE.Color(0x080018);
    sc.add(new THREE.AmbientLight(0x334466,1.4));
    const dl=new THREE.DirectionalLight(0xffffff,1.4); dl.position.set(2,5,3); sc.add(dl);
    const cam2=new THREE.PerspectiveCamera(45,cv.width/cv.height,.1,20);
    cam2.position.set(0,1.2,2.8);
    const ren2=new THREE.WebGLRenderer({canvas:cv,antialias:true});
    ren2.setSize(cv.width,cv.height);
    const fig=buildWardrobeFigure(PROFILE.equipped);
    sc.add(fig);
    ren2.render(sc,cam2);
    // Update rarity badge
    const equippedItems=Object.values(PROFILE.equipped).map(id=>WARDROBE_ITEMS.find(i=>i.id===id)).filter(Boolean);
    const topRarity=equippedItems.reduce((acc,i)=>{
      const order={common:0,rare:1,epic:2,legendary:3};
      return order[i.rarity]>order[acc]?i.rarity:acc;
    },'common');
    const badge=document.getElementById('p-rarity-badge');
    if(badge){
      const rc=RARITY_COLORS[topRarity];
      badge.textContent=topRarity.toUpperCase();
      badge.style.background=rc+'22'; badge.style.color=rc; badge.style.border='1px solid '+rc+'44';
    }
  }catch(e){}
}

function updateProfileGroupsMini(){
  const el=document.getElementById('p-groups-mini');
  if(!el) return;
  el.innerHTML=PROFILE.myGroups.slice(0,6).map(id=>{
    const gr=ALL_GROUPS.find(g=>g.id===id);
    return gr?`<span style="background:rgba(0,245,255,.07);border:1px solid var(--bd);padding:4px 10px;border-radius:20px;font-size:.72rem">${gr.icon} ${gr.name}</span>`:'';
  }).join('')||'<span style="color:var(--mu);font-size:.78rem">Sem grupos ainda</span>';
}

// Hook renderProfile to use our new system
function renderProfile(){ renderProfileOverview(); }

// Give player initial NeBux on login
function initPlayerProfile(username){
  PROFILE.name=username;
  PROFILE.nebux=6000;
  PROFILE.xp=Math.floor(Math.random()*500)+100;
  PROFILE.level=Math.floor(PROFILE.xp/1000)+1;
  // Start with some items equipped
  PROFILE.equipped={hair:'hair_default',shirt:'shirt_white',pants:'pants_black',shoes:'shoes_white'};
}

// ═══════════════════════════════════════
// MUSIC PLAYER (YouTube IFrame API)
// ═══════════════════════════════════════
const PLAYLIST = [
  { title:'Lofi Hip Hop Radio', artist:'Chillhop Music', vid:'5qap5aO4i9A', dur:'LIVE', emoji:'🎵' },
  { title:'Chill Study Beats', artist:'Lo-fi Girl', vid:'jfKfPfyJRdk', dur:'LIVE', emoji:'📚' },
  { title:'Relaxing Game Music', artist:'GameChops', vid:'S_MOd40zlYU', dur:'3:42', emoji:'🎮' },
  { title:'Synthwave Nights', artist:'Neon Drive', vid:'4xDzrJKXOOY', dur:'1:02:20', emoji:'🌙' },
  { title:'Chill Lofi Beats', artist:'Lofi Geek', vid:'7NOSDKb0HlU', dur:'2:00:00', emoji:'☕' },
  { title:'Study & Relax Music', artist:'Ambient Music', vid:'1ZYbU82GVz4', dur:'3:00:00', emoji:'🌿' },
  { title:'Night City Lofi', artist:'Lofi Dreamer', vid:'DVguk15ijKI', dur:'1:00:00', emoji:'🌆' },
  { title:'Pixel Perfect Beats', artist:'Chiptune Lofi', vid:'Dx5qFachd3A', dur:'1:30:00', emoji:'👾' },
  { title:'Rainy Day Chill', artist:'Monsoon Lofi', vid:'mPZkdNFkNps', dur:'2:30:00', emoji:'🌧️' },
  { title:'Jazz Hop Cafe', artist:'Cafe Music', vid:'Xm0A1TWTNSE', dur:'LIVE', emoji:'🎷' },
  { title:'Ocean Waves Lofi', artist:'Lofi Coast', vid:'q76bMs-NwRk', dur:'2:00:00', emoji:'🌊' },
  { title:'Tokyo Night Lofi', artist:'Japanese Lofi', vid:'4oStw0r33so', dur:'1:30:00', emoji:'🗼' },
];

let ytPlayer=null, ytReady=false;
let curTrack=0, isPlaying=false, isShuffle=false, isRepeat=false;
let musicBarOpen=false, musicVolume=60;
let progInterval=null;

// Load YouTube IFrame API
function loadYTAPI(){
  if(window.YT) return;
  const tag=document.createElement('script');
  tag.src='https://www.youtube.com/iframe_api';
  document.head.appendChild(tag);
}

window.onYouTubeIframeAPIReady=function(){
  ytReady=true;
  ytPlayer=new YT.Player('yt-player',{
    height:'1', width:'1',
    playerVars:{autoplay:0,controls:0},
    events:{
      onReady: ()=>{ setVolume(musicVolume); },
      onStateChange: (e)=>{
        if(e.data===YT.PlayerState.ENDED){
          if(isRepeat) ytPlayer.playVideo();
          else nextTrack();
        }
        if(e.data===YT.PlayerState.PLAYING){
          isPlaying=true;
          document.getElementById('mb-play').textContent='⏸';
          startProgBar();
        }
        if(e.data===YT.PlayerState.PAUSED){
          isPlaying=false;
          document.getElementById('mb-play').textContent='▶';
        }
      }
    }
  });
};

function openMusicBar(){
  if(!musicBarOpen){
    musicBarOpen=true;
    document.getElementById('music-bar').classList.add('on');
    loadYTAPI();
    renderPlaylist();
    // Auto-play first track
    setTimeout(()=>{ if(!isPlaying) loadTrack(curTrack, true); }, 1000);
  }
}
function closeMusicBar(){
  musicBarOpen=false;
  document.getElementById('music-bar').classList.remove('on');
  document.getElementById('pl-popup').classList.remove('on');
  if(ytPlayer&&isPlaying) ytPlayer.pauseVideo();
}
function togglePlaylist(){
  document.getElementById('pl-popup').classList.toggle('on');
}
function renderPlaylist(){
  const list=document.getElementById('pl-list');
  const cnt=document.getElementById('pl-count');
  if(cnt) cnt.textContent=PLAYLIST.length+' músicas';
  if(!list) return;
  list.innerHTML=PLAYLIST.map((t,i)=>`
    <div class="pl-item${i===curTrack?' on':''}" onclick="loadTrack(${i},true)">
      <div class="pl-num">${i===curTrack?'▶':i+1}</div>
      <div style="font-size:1.2rem">${t.emoji}</div>
      <div class="pl-info">
        <div class="pl-name">${t.title}</div>
        <div class="pl-dur">${t.artist} · ${t.dur}</div>
      </div>
    </div>`).join('');
}
function loadTrack(idx, autoplay=false){
  curTrack=idx;
  const t=PLAYLIST[idx];
  document.getElementById('mb-title').textContent=t.title;
  document.getElementById('mb-artist').textContent=t.artist+' · '+t.dur;
  document.getElementById('mb-art').textContent=t.emoji;
  document.getElementById('mb-prog-fill').style.width='0%';
  renderPlaylist();
  if(autoplay&&ytPlayer&&ytReady){
    ytPlayer.loadVideoById(t.vid);
    ytPlayer.playVideo();
  } else if(ytPlayer&&ytReady){
    ytPlayer.cueVideoById(t.vid);
  }
}
function togglePlay(){
  if(!ytReady||!ytPlayer){ openMusicBar(); return; }
  if(isPlaying){ ytPlayer.pauseVideo(); isPlaying=false; }
  else { ytPlayer.playVideo(); isPlaying=true; }
}
function nextTrack(){
  stopProgBar();
  const next = isShuffle
    ? Math.floor(Math.random()*PLAYLIST.length)
    : (curTrack+1)%PLAYLIST.length;
  loadTrack(next, true);
}
function prevTrack(){
  stopProgBar();
  const prev=(curTrack-1+PLAYLIST.length)%PLAYLIST.length;
  loadTrack(prev, true);
}
function toggleShuffle(){
  isShuffle=!isShuffle;
  document.getElementById('mb-shuffle').classList.toggle('on',isShuffle);
}
function toggleRepeat(){
  isRepeat=!isRepeat;
  document.getElementById('mb-repeat').classList.toggle('on',isRepeat);
}
function setVolume(v){
  musicVolume=parseInt(v);
  if(ytPlayer&&ytReady) ytPlayer.setVolume(musicVolume);
  const inp=document.getElementById('mb-vol-inp');
  if(inp) inp.value=musicVolume;
}
function startProgBar(){
  stopProgBar();
  progInterval=setInterval(()=>{
    if(!ytPlayer||!ytReady) return;
    try{
      const dur=ytPlayer.getDuration()||1;
      const cur=ytPlayer.getCurrentTime()||0;
      const pct=Math.min(100,(cur/dur)*100);
      const fill=document.getElementById('mb-prog-fill');
      if(fill) fill.style.width=pct+'%';
    }catch(e){}
  }, 1000);
}
function stopProgBar(){ clearInterval(progInterval); }
function seekMusic(e){
  if(!ytPlayer||!ytReady) return;
  try{
    const bar=e.currentTarget;
    const pct=e.offsetX/bar.offsetWidth;
    const dur=ytPlayer.getDuration()||1;
    ytPlayer.seekTo(pct*dur, true);
  }catch(e){}
}

// Botão ♪ na topbar abre o player
function toggleMusic(){ openMusicBar(); }

// ═══════════════════════════════════════
// AI WIDGET — Real API
// ═══════════════════════════════════════
let aiConv=[], aiDone=false;
const AI_SYS=`Você é a IA de suporte do Free Games, uma plataforma de jogos online 3D. 
Responda em português, de forma direta, amigável e concisa (máximo 2-3 frases).
Sobre a plataforma: tem 12 jogos (futebol 3D, basquete 3D, aim lab, PvP arena, terror escape, etc), 
modo 2D e 3D com THREE.js, pointer lock para câmera FPS, seleção de personagem (6 chars únicos), 
bots com IA configurável (fácil a Ultra Insano), multiplayer com salas, modo criativo de mapas, 
perfil de jogador com XP, chat em tempo real, e painel admin completo.
Se o tema for fora dos jogos, redirecione gentilmente.`;

function aiInit(){
  if(aiDone) return; aiDone=true;
  aiSayMsg(`Olá, ${S.user}! Sou a IA do Free Games. Posso te ajudar a escolher um jogo, explicar os modos 3D, os personagens, ou qualquer dúvida sobre a plataforma!`);
  setTimeout(()=>aiSayMsg('Use os atalhos rápidos abaixo ou me pergunte qualquer coisa. Experimente o Aim Lab ou o Terror — estão excelentes no 3D!'),3000);
}

async function aiCallAPI(userMsg){
  aiConv.push({role:'user',content:userMsg});
  const typEl=document.createElement('div'); typEl.className='aitdots';
  typEl.innerHTML='<div class="td"></div><div class="td"></div><div class="td"></div>';
  document.getElementById('ai-msgs').appendChild(typEl);
  document.getElementById('ai-msgs').scrollTop=99999;
  try{
    const resp=await fetch('https://api.anthropic.com/v1/messages',{
      method:'POST',
      headers:{
        'Content-Type':'application/json',
        'anthropic-version':'2023-06-01',
        'anthropic-dangerous-direct-browser-access':'true'
      },
      body:JSON.stringify({
        model:'claude-sonnet-4-6',
        max_tokens:1000,
        system:AI_SYS,
        messages:aiConv
      })
    });
    const data=await resp.json();
    typEl.remove();
    const reply=data.content?.[0]?.text||'Desculpe, não consegui responder agora.';
    aiConv.push({role:'assistant',content:reply});
    aiSayMsg(reply);
  }catch(e){
    typEl.remove();
    aiSayMsg(localAIReply(userMsg));
  }
}

function localAIReply(q){
  q=q.toLowerCase();
  if(q.includes('terror')||q.includes('horror')) return 'O modo Terror tem ambiente 3D escuro com lanterna que você controla com o mouse! A criatura tem IA que aprende seu padrão. Jogue no Difícil para o susto total!';
  if(q.includes('3d')||q.includes('câmera')) return 'No modo 3D usamos Three.js com pointer lock — o mouse fica preso na tela e você controla a câmera livremente. Clique no jogo para ativar, ESC para soltar.';
  if(q.includes('personagem')||q.includes('char')) return 'Temos 6 personagens únicos: Apex (velocidade), Titan (tanque), Shade (furtivo), Hawkeye (sniper), Voltex (tecnologia) e Feral (força bruta). Você tem 10 segundos para escolher!';
  if(q.includes('aim')||q.includes('mira')) return 'O Aim Lab é perfeito para treinar mira! Alvos 3D aparecem em velocidades diferentes conforme a dificuldade. No Ultra Insano os alvos são minúsculos e super rápidos.';
  if(q.includes('bot')) return 'Os bots têm 5 dificuldades: Fácil, Médio, Difícil, Insano e Ultra Insano. No Ultra, a IA é extremamente agressiva e rápida. Você também configura o comportamento: agressivo, defensivo, aleatório ou inteligente.';
  if(q.includes('admin')) return 'O painel admin tem 10 contas pré-criadas. Como admin você pode kick, mute, ban, enviar mensagens globais, aprovar mapas, ver logs e gerenciar todas as salas.';
  if(q.includes('mapa')||q.includes('criativo')) return 'No Modo Criativo você pinta um grid de 20x14 com tiles, objetos e armadilhas. Configure nome, categoria, max jogadores e visibilidade. Publique e aparece na Comunidade!';
  return 'Posso ajudar com jogos, modos 3D, personagens, bots ou qualquer coisa da plataforma Free Games! Tente uma das perguntas rápidas abaixo.';
}

function aiSayMsg(txt){
  const msgs=document.getElementById('ai-msgs');
  if(!msgs) return;
  const d=document.createElement('div'); d.className='aimsg'; d.textContent=txt;
  msgs.appendChild(d); msgs.scrollTop=99999;
}

function aiAsk(q){
  const questions={
    'como jogar':'Como jogar no Free Games?',
    '3d':'Como funciona o modo 3D e pointer lock?',
    'criar mapa':'Como criar e publicar um mapa?',
    'terror':'Como é o modo Terror 3D?',
    'bots':'Como funcionam os bots e dificuldades?',
    'regras':'Quais são as regras da plataforma?',
    'denunciar':'Como denunciar um jogador?',
    'admin':'Como funciona o painel de admin?',
  };
  const qText=questions[q]||q;
  document.getElementById('aiw').classList.remove('minimized');
  aiCallAPI(qText);
}

function aiSendMsg(){
  const inp=document.getElementById('ai-inp');
  if(!inp||!inp.value.trim()) return;
  const msg=inp.value; inp.value='';
  aiCallAPI(msg);
}

function toggleAI(){
  document.getElementById('aiw').classList.toggle('minimized');
}

// ═══════════════════════════════════════
// UTILS
// ═══════════════════════════════════════
function openM(id){document.getElementById(id)?.classList.add('on');}
function closeM(id){document.getElementById(id)?.classList.remove('on');}
document.addEventListener('click',e=>{if(e.target.classList.contains('mbg'))e.target.classList.remove('on');});
function toast(msg,type=''){
  const a=document.getElementById('toasts');
  const d=document.createElement('div'); d.className=`toast ${type}`; d.textContent=msg;
  a.appendChild(d); setTimeout(()=>{d.style.opacity='0';d.style.transition='opacity .4s';},3000); setTimeout(()=>d.remove(),3500);
}
function gax(){document.getElementById('galert').classList.remove('on');}
function rp(){return PLAYERS[Math.floor(Math.random()*PLAYERS.length)];}
// toggleMusic redefined in music player above

// Live counters
setInterval(()=>{
  const n=(3000+Math.floor(Math.random()*400)).toLocaleString();
  const e1=document.getElementById('onl-cnt'), e2=document.getElementById('s-onl');
  if(e1) e1.textContent=n; if(e2) e2.textContent=n;
},5000);

// Bot count slider
document.addEventListener('input',e=>{
  if(e.target.id==='bot-count')
    document.getElementById('bot-count-lbl').textContent=e.target.value+' bot'+(e.target.value>1?'s':'')+' por time';
});

// ═══════════════════════════════════════
// LOCALSTORAGE SAVE SYSTEM
// ═══════════════════════════════════════
function saveProfileLS(){
  try{
    localStorage.setItem('freegames_profile', JSON.stringify({
      name: PROFILE.name,
      bio: PROFILE.bio,
      nebux: PROFILE.nebux,
      xp: PROFILE.xp,
      level: PROFILE.level,
      favGames: PROFILE.favGames,
      profileColor: PROFILE.profileColor,
      myGroups: PROFILE.myGroups,
      equipped: PROFILE.equipped,
      owned: PROFILE.owned,
      gender: PROFILE.gender||'m',
      username: S.user,
      isAdmin: S.isAdmin
    }));
    const ind=document.getElementById('save-ind');
    if(ind){ind.classList.add('show');setTimeout(()=>ind.classList.remove('show'),2200);}
  }catch(e){}
}

// Auto-save every 30s while logged in
setInterval(()=>{if(S.user) saveProfileLS();}, 30000);

// Patch saveProfile to also persist
const _origSaveProfile=window.saveProfile;
window.saveProfile=function(){
  if(_origSaveProfile) _origSaveProfile();
  saveProfileLS();
};

// Patch buyItem to persist
const _origBuyItem=window.buyItem;
window.buyItem=function(id){
  if(_origBuyItem) _origBuyItem(id);
  else {
    const item=WARDROBE_ITEMS.find(i=>i.id===id);
    if(!item||PROFILE.owned.includes(id)){toast('Você já possui este item!','warn');return;}
    if(PROFILE.nebux<item.price){toast('NeBux insuficiente!','err');return;}
    PROFILE.nebux-=item.price; PROFILE.owned.push(id);
    document.getElementById('shop-nebux-disp').textContent=PROFILE.nebux.toLocaleString();
    document.getElementById('topbar-nebux').textContent=PROFILE.nebux.toLocaleString();
    document.getElementById('p-nebux-disp').textContent=PROFILE.nebux.toLocaleString();
    toast(`${item.emoji} ${item.name} comprado!`,'ok');
  }
  saveProfileLS();
};

// Patch joinGroup
const _origJoinGroup=window.joinGroup;
window.joinGroup=function(id){
  if(_origJoinGroup) _origJoinGroup(id);
  saveProfileLS();
};

// ═══════════════════════════════════════
// PATCHED doLogin — restore data + admin powers
// ═══════════════════════════════════════
const _origDoLogin=window.doLogin;
window.doLogin=function(){
  const u=document.getElementById('lu').value||'Jogador';
  const pw=document.getElementById('lp').value;
  S.isAdmin=(loginRole==='a')||(pw==='admin123');
  S.user=u;

  // Try to restore saved profile for this user
  try{
    const saved=localStorage.getItem('freegames_profile');
    if(saved){
      const d=JSON.parse(saved);
      if(d.username===u||!d.username){
        Object.assign(PROFILE,d);
        PROFILE.name=d.name||u;
      } else {
        initPlayerProfile(u);
      }
    } else {
      initPlayerProfile(u);
    }
  }catch(e){ initPlayerProfile(u); }

  PROFILE.name=PROFILE.name||u;
  document.getElementById('av-btn').textContent=u[0].toUpperCase();
  try{document.getElementById('p-av').textContent=u[0].toUpperCase();}catch(e){}
  try{document.getElementById('p-name').textContent=PROFILE.name;}catch(e){}
  document.getElementById('adm-btn').style.display=S.isAdmin?'':'none';
  document.getElementById('adm-pwr-btn').style.display=S.isAdmin?'':'none';
  document.getElementById('topbar-nebux').textContent=PROFILE.nebux.toLocaleString();
  toast(`Bem-vindo, ${PROFILE.name}! ${S.isAdmin?'⚡ Admin ativado.':'Bom jogo!'}`, 'ok');
  goPage('home');
  setTimeout(()=>aiInit(),1200);
  saveProfileLS();
};

// ═══════════════════════════════════════
// GENDER SYSTEM
// ═══════════════════════════════════════
function selectGender(g){
  PROFILE.gender=g;
  document.querySelectorAll('.gender-btn').forEach(b=>{
    b.classList.remove('on','on-f');
    if(b.dataset.g===g) b.classList.add(g==='f'?'on-f':'on');
  });
  saveProfileLS();
}

// ═══════════════════════════════════════
// MINI BROWSER
// ═══════════════════════════════════════
const MB_WHITELIST=['youtube.com','wikipedia.org','scratch.mit.edu','google.com','roblox.com','github.com'];
function openMB(){
  document.getElementById('mini-browser').classList.add('on');
  mbLoadUrl('https://www.youtube.com');
}
function closeMB(){
  document.getElementById('mini-browser').classList.remove('on');
  document.getElementById('mb-frame').src='about:blank';
}
function mbGo(){
  let url=document.getElementById('mb-url').value.trim();
  if(!url.startsWith('http')) url='https://'+url;
  mbLoadUrl(url);
}
function mbLoadUrl(url){
  document.getElementById('mb-url').value=url;
  // Check whitelist
  const allowed=MB_WHITELIST.some(d=>url.includes(d));
  const frame=document.getElementById('mb-frame');
  if(allowed){
    frame.src=url;
    frame.style.display='';
    document.querySelector('.mb-blocked')?.remove();
    document.querySelectorAll('.mb-tab').forEach(t=>t.classList.remove('on'));
    document.querySelectorAll('.mb-tab').forEach(t=>{if(url.includes(t.textContent.toLowerCase().split(' ')[1]||''))t.classList.add('on');});
  } else {
    frame.src='about:blank';
    frame.style.display='none';
    const existing=document.querySelector('.mb-blocked');
    if(!existing){
      const d=document.createElement('div'); d.className='mb-blocked';
      d.innerHTML=`<div style="font-size:2rem">🔒</div><div>Site bloqueado por segurança</div><div style="font-size:.72rem;color:#555">Sites permitidos: YouTube, Wikipedia, Scratch</div>`;
      document.getElementById('mini-browser').appendChild(d);
    }
  }
}
function mbBack(){try{document.getElementById('mb-frame').contentWindow.history.back();}catch(e){}}
function mbFwd(){try{document.getElementById('mb-frame').contentWindow.history.forward();}catch(e){}}
function mbReload(){try{document.getElementById('mb-frame').contentWindow.location.reload();}catch(e){mbLoadUrl(document.getElementById('mb-url').value);}}
function showMbBlocked(name){toast(`${name} — em breve!`,'warn');}

// ═══════════════════════════════════════
// ADMIN POWERS
// ═══════════════════════════════════════
const adminPowers={fly:false,speed:false,invis:false,noclip:false};
function adpToggle(power){
  adminPowers[power]=!adminPowers[power];
  const btn=document.getElementById('adp-'+power);
  const labels={fly:'✈️ Voar',speed:'⚡ Speed',invis:'👻 Invisível',noclip:'🌀 Noclip'};
  if(btn){
    const on=adminPowers[power];
    btn.textContent=`${labels[power]}: ${on?'ON':'OFF'}`;
    btn.classList.toggle('on',on);
  }
  // Apply in game
  if(S.running){
    if(power==='speed') {
      const spd=adminPowers.speed?3:1;
      toast(`Admin Speed: ${adminPowers.speed?'ATIVO':'OFF'}`,'ok');
    }
    if(power==='fly') toast(`Admin Fly: ${adminPowers.fly?'ATIVO — ESPAÇO=subir, C=descer':'OFF'}`,'ok');
    if(power==='invis') toast(`Invisível: ${adminPowers.invis?'Bots não te vêem!':'OFF'}`,'ok');
    if(power==='noclip') toast(`Noclip: ${adminPowers.noclip?'Atravessa paredes!':'OFF'}`,'ok');
  } else {
    toast(`${labels[power]}: ${adminPowers[power]?'ATIVO':'OFF'}`,'ok');
  }
}
function adpGiveNebux(){
  PROFILE.nebux+=5000;
  document.getElementById('topbar-nebux').textContent=PROFILE.nebux.toLocaleString();
  document.getElementById('p-nebux-disp').textContent=PROFILE.nebux.toLocaleString();
  try{document.getElementById('shop-nebux-disp').textContent=PROFILE.nebux.toLocaleString();}catch(e){}
  toast('💰 +5000 NeBux adicionados!','ok');
  saveProfileLS();
}
function adpOpenSecret(){
  document.getElementById('admin-powers').classList.remove('on');
  openSecret();
}

// Apply admin speed/fly overrides in game loop (hook)
const _origLoop3d=window.loop3d;

// ═══════════════════════════════════════
// SECRET AREA: 7 A E MELHOR
// ═══════════════════════════════════════
let secretCanvasInit=false;
function openSecret(){
  document.getElementById('secret-overlay').classList.add('on');
  if(!secretCanvasInit){ initSecretCanvas(); secretCanvasInit=true; }
  document.getElementById('secret-msg').textContent='';
}
function closeSecret(){ document.getElementById('secret-overlay').classList.remove('on'); }
function collectSecretReward(){
  if(PROFILE.owned.includes('secret_7ae')){
    document.getElementById('secret-msg').textContent='✓ Você já coletou esta recompensa!';
    return;
  }
  PROFILE.owned.push('secret_7ae');
  PROFILE.nebux+=10000;
  PROFILE.xp+=5000;
  document.getElementById('topbar-nebux').textContent=PROFILE.nebux.toLocaleString();
  document.getElementById('p-nebux-disp').textContent=PROFILE.nebux.toLocaleString();
  document.getElementById('secret-msg').textContent='🏆 +10.000 NeBux e +5000 XP coletados! Item lendário desbloqueado!';
  toast('⭐ Recompensa Lendária coletada!','ok');
  saveProfileLS();
  // Add legendary item
  WARDROBE_ITEMS.push({id:'secret_7ae',cat:'acc',name:'Emblema 7 A E MELHOR',emoji:'⭐',price:0,rarity:'legendary'});
}

function initSecretCanvas(){
  const cv=document.getElementById('secret-canvas');
  if(!cv) return;
  try{
    const scene=new THREE.Scene();
    scene.background=new THREE.Color(0x000000);
    const cam=new THREE.PerspectiveCamera(60,cv.width/cv.height,.1,500);
    cam.position.set(0,8,20);
    cam.lookAt(0,2,0);
    const ren=new THREE.WebGLRenderer({canvas:cv,antialias:true});
    ren.setSize(cv.width,cv.height);
    ren.shadowMap.enabled=true;

    // Ambient gold light
    scene.add(new THREE.AmbientLight(0x332200,.8));
    const goldLight=new THREE.PointLight(0xffd740,4,40); goldLight.position.set(0,10,0); scene.add(goldLight);
    const purpleLight=new THREE.PointLight(0xd500f9,3,30); purpleLight.position.set(-10,5,0); scene.add(purpleLight);
    const cyanLight=new THREE.PointLight(0x00f5ff,3,30); cyanLight.position.set(10,5,0); scene.add(cyanLight);

    // Ground — dark glowing tiles
    for(let x=-8;x<=8;x+=2) for(let z=-8;z<=8;z+=2){
      const col=[0x1a0a00,0x0a001a,0x001a0a][Math.abs(x+z)%3];
      const tile=new THREE.Mesh(new THREE.BoxGeometry(1.95,.1,1.95),
        new THREE.MeshStandardMaterial({color:col,emissive:new THREE.Color(col),emissiveIntensity:.5,roughness:.3,metalness:.6}));
      tile.position.set(x,0,z); scene.add(tile);
    }

    // Central temple structure
    const templeBase=new THREE.Mesh(new THREE.CylinderGeometry(4,5,1,8),
      new THREE.MeshStandardMaterial({color:0x2a1500,roughness:.3,metalness:.7}));
    templeBase.position.y=.5; scene.add(templeBase);

    const pillarMat=new THREE.MeshStandardMaterial({color:0xffd740,roughness:.2,metalness:.9,emissive:0x332200,emissiveIntensity:.3});
    for(let i=0;i<6;i++){
      const a=i/6*Math.PI*2;
      const pillar=new THREE.Mesh(new THREE.CylinderGeometry(.2,.25,5,8),pillarMat);
      pillar.position.set(Math.cos(a)*3,3.5,Math.sin(a)*3); scene.add(pillar);
    }

    // Floating "7" text approximation — glowing orb cluster
    const secretOrb=new THREE.Mesh(new THREE.SphereGeometry(1.5,16,16),
      new THREE.MeshStandardMaterial({color:0xffd740,emissive:0xffd740,emissiveIntensity:1,roughness:0,metalness:1}));
    secretOrb.position.set(0,7,0); scene.add(secretOrb);
    secretOrb.userData.isOrb=true;

    // Orbiting particles
    const orbParticles=[];
    for(let i=0;i<20;i++){
      const p=new THREE.Mesh(new THREE.SphereGeometry(.12,6,6),
        new THREE.MeshBasicMaterial({color:[0xffd740,0xff9100,0xd500f9,0x00f5ff][i%4]}));
      p.position.set(Math.cos(i/20*Math.PI*2)*3,6+Math.sin(i/10*Math.PI)*1.5,Math.sin(i/20*Math.PI*2)*3);
      p.userData.phase=i/20*Math.PI*2;
      scene.add(p); orbParticles.push(p);
    }

    // Floating rings
    for(let i=0;i<3;i++){
      const ring=new THREE.Mesh(new THREE.TorusGeometry(2+i*.8,.06,8,32),
        new THREE.MeshBasicMaterial({color:[0xffd740,0xff9100,0xd500f9][i]}));
      ring.position.set(0,4+i*.8,0);
      ring.userData.ringIdx=i; scene.add(ring);
    }

    // Star field
    const starGeo=new THREE.BufferGeometry();
    const starPos=new Float32Array(300*3);
    for(let i=0;i<300*3;i++) starPos[i]=(Math.random()-.5)*100;
    starGeo.setAttribute('position',new THREE.BufferAttribute(starPos,3));
    scene.add(new THREE.Points(starGeo,new THREE.PointsMaterial({color:0xffffff,size:.08,transparent:true,opacity:.6})));

    let t=0;
    function animSecret(){
      if(!document.getElementById('secret-overlay').classList.contains('on')){return;}
      requestAnimationFrame(animSecret);
      t+=.018;
      goldLight.intensity=3+Math.sin(t*2)*1.5;
      secretOrb.rotation.y=t;
      secretOrb.position.y=7+Math.sin(t*1.5)*.4;
      orbParticles.forEach((p,i)=>{
        const ph=p.userData.phase+t;
        p.position.set(Math.cos(ph)*3.5,6+Math.sin(ph*1.3)*.8,Math.sin(ph)*3.5);
      });
      scene.children.filter(c=>c.userData.ringIdx!==undefined).forEach((r,i)=>{
        r.rotation.x=t*(i%2===0?0.5:-0.3);
        r.rotation.z=t*(i%2===0?-0.4:0.6);
      });
      cam.position.x=Math.sin(t*.2)*5;
      cam.position.z=18+Math.cos(t*.15)*4;
      cam.lookAt(0,5,0);
      ren.render(scene,cam);
    }
    animSecret();
  }catch(e){console.warn('Secret canvas error:',e);}
}

// ═══════════════════════════════════════
// MINECRAFT 3D MODE
// ═══════════════════════════════════════
const MC_BLOCKS=[
  {id:'grass',emoji:'🟩',color:0x4caf50,top:0x66bb6a,label:'Grama'},
  {id:'dirt',emoji:'🟫',color:0x795548,label:'Terra'},
  {id:'stone',emoji:'⬜',color:0x757575,label:'Pedra'},
  {id:'wood',emoji:'🪵',color:0x8d6e63,label:'Madeira'},
  {id:'sand',emoji:'🟡',color:0xffd54f,label:'Areia'},
  {id:'brick',emoji:'🔴',color:0xc62828,label:'Tijolo'},
  {id:'glass',emoji:'🔷',color:0x80deea,label:'Vidro',transparent:true},
  {id:'gold',emoji:'🌟',color:0xffd740,label:'Ouro'},
  {id:'secret',emoji:'⭐',color:0xff9100,label:'Bloco Secreto'},
];
const MC_BLOCK_SIZE=1;
let mcScene,mcCam,mcRen,mcWorld={},mcKeys={},mcPlock=false;
let mcPlayer={x:0,y:70,z:0,vx:0,vy:0,vz:0,yaw:0,pitch:0,onGround:false};
let mcMode='creative',mcFlying=false,mcSelectedSlot=0;
let mcRoomCode='',mcRaf=null;
const MC_GRAVITY=0.025,MC_JUMP=0.35,MC_SPEED=0.12,MC_FLY_SPD=0.22;
const MC_HALF=50; // half world size

function generateRoomCode(){
  return Array.from({length:6},()=>'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'[Math.floor(Math.random()*32)]).join('');
}

function openMC(){
  document.getElementById('mc-overlay').classList.add('on');
  document.getElementById('mc-lobby-screen').style.display='';
}
function closeMC(){
  document.getElementById('mc-overlay').classList.remove('on');
}
function closeMCGame(){
  mcRaf=null;
  if(mcRen) mcRen.dispose();
  mcScene=mcCam=mcRen=null;
  if(mcPlock&&document.pointerLockElement) document.exitPointerLock();
  document.getElementById('mc-canvas').style.display='none';
  document.getElementById('mc-hud').style.display='none';
  document.getElementById('mc-cross').style.display='none';
  document.getElementById('mc-fly-ind').style.display='none';
  document.getElementById('mc-info').style.display='none';
  document.getElementById('mc-toolbar').style.display='none';
  document.getElementById('mc-lobby-screen').style.display='';
}
function mcShowJoin(){
  document.getElementById('mc-join-section').style.display='flex';
  document.getElementById('mc-room-display').style.display='none';
}
function mcCreateRoom(){
  mcRoomCode=generateRoomCode();
  document.getElementById('mc-code-disp').textContent=mcRoomCode;
  document.getElementById('mc-room-display').style.display='flex';
  document.getElementById('mc-join-section').style.display='none';
  toast(`Sala criada! Código: ${mcRoomCode}`,'ok');
}
function mcJoinRoom(){
  const code=document.getElementById('mc-code-inp').value.trim().toUpperCase();
  if(code.length<4){toast('Código inválido!','err');return;}
  mcRoomCode=code;
  toast(`Entrando na sala ${code}...`,'ok');
  // Simulated join (real multiplayer needs server)
  setTimeout(()=>mcStartGame('survival'),600);
}
function mcCopyCode(){
  navigator.clipboard?.writeText(mcRoomCode).then(()=>toast('Código copiado!','ok')).catch(()=>toast('Código: '+mcRoomCode,''));
}

function mcStartGame(mode){
  mcMode=mode;
  mcFlying=(mode==='creative');
  document.getElementById('mc-lobby-screen').style.display='none';
  document.getElementById('mc-canvas').style.display='block';
  document.getElementById('mc-hud').style.display='flex';
  document.getElementById('mc-cross').style.display='block';
  document.getElementById('mc-fly-ind').style.display='none';
  document.getElementById('mc-info').style.display='block';
  document.getElementById('mc-toolbar').style.display='flex';
  document.getElementById('mc-mode-lbl').textContent=mode==='creative'?'CRIATIVO':'SOBREVIVÊNCIA';
  document.getElementById('mc-fly-btn').textContent=mcFlying?'✈️ Voar: ON':'✈️ Voar: OFF';
  if(mcFlying) document.getElementById('mc-fly-ind').style.display='block';
  mcBuildToolbar();
  mcInitScene();
  mcAddKeyListeners();
  toast(`Modo ${mode==='creative'?'Criativo':'Sobrevivência'} iniciado! Clique para capturar o mouse.`,'ok');
}

function mcBuildToolbar(){
  const tb=document.getElementById('mc-toolbar');
  if(!tb) return;
  tb.innerHTML=MC_BLOCKS.slice(0,9).map((b,i)=>
    `<div class="mc-slot${i===mcSelectedSlot?' active':''}" title="${b.label}" onclick="mcSelectSlot(${i})">${b.emoji}</div>`
  ).join('');
}
function mcSelectSlot(i){ mcSelectedSlot=i; mcBuildToolbar(); }

function mcInitScene(){
  const cv=document.getElementById('mc-canvas');
  cv.width=window.innerWidth; cv.height=window.innerHeight;
  mcScene=new THREE.Scene();
  mcScene.background=new THREE.Color(0x87ceeb);
  mcScene.fog=new THREE.FogExp2(0x87ceeb,.018);

  mcCam=new THREE.PerspectiveCamera(70,cv.width/cv.height,.05,200);
  mcRen=new THREE.WebGLRenderer({canvas:cv,antialias:true});
  mcRen.setSize(cv.width,cv.height);
  mcRen.shadowMap.enabled=true;

  // Lighting
  mcScene.add(new THREE.AmbientLight(0xffffff,.7));
  const sun=new THREE.DirectionalLight(0xffffff,.9);
  sun.position.set(50,80,30); sun.castShadow=true;
  sun.shadow.mapSize.width=1024; sun.shadow.mapSize.height=1024;
  mcScene.add(sun);

  window.addEventListener('resize',()=>{
    if(!mcRen) return;
    cv.width=window.innerWidth; cv.height=window.innerHeight;
    mcCam.aspect=cv.width/cv.height; mcCam.updateProjectionMatrix();
    mcRen.setSize(cv.width,cv.height);
  });

  // Pointer lock
  cv.addEventListener('click',()=>{if(document.pointerLockElement!==cv) cv.requestPointerLock();});
  document.addEventListener('pointerlockchange',()=>{ mcPlock=document.pointerLockElement===cv; });
  document.addEventListener('mousemove',mcOnMouseMove);
  cv.addEventListener('mousedown',mcOnMouseDown);
  document.addEventListener('wheel',mcOnWheel);

  // Generate terrain
  mcWorld={};
  mcGenerateTerrain();

  mcPlayer={x:0,y:70,z:0,vx:0,vy:0,vz:0,yaw:0,pitch:0,onGround:false};

  // If survival, add trees and resources
  if(mcMode==='survival') mcGenerateTrees();

  // Secret "7 A E MELHOR" area at world center deep underground
  if(S.isAdmin||PROFILE.owned.includes('secret_7ae')){
    // Place glowing gold platform at 0,50,0
    for(let x=-3;x<=3;x++) for(let z=-3;z<=3;z++){
      mcSetBlock(x,50,z,'gold');
    }
    mcSetBlock(0,51,0,'secret');
  }

  mcAnimLoop();
}

function mcGenerateTerrain(){
  const H=64; // base terrain height
  // Simple flat-ish terrain with some hills
  for(let x=-MC_HALF;x<MC_HALF;x+=1) for(let z=-MC_HALF;z<MC_HALF;z+=1){
    // Height variation
    const h=H+Math.floor(Math.sin(x*.08)*3+Math.cos(z*.07)*3+Math.sin((x+z)*.05)*2);
    mcSetBlock(x,h,z,'grass');
    mcSetBlock(x,h-1,z,'dirt');
    mcSetBlock(x,h-2,z,'dirt');
    for(let y=h-3;y>=H-10;y--) mcSetBlock(x,y,z,'stone');
  }
}

function mcGenerateTrees(){
  const treePositions=[[5,3],[10,-8],[-12,5],[8,12],[-5,-10],[-15,-3],[20,8],[3,-18]];
  treePositions.forEach(([tx,tz])=>{
    const h=mcGroundAt(tx,tz)+1;
    if(!h) return;
    // Trunk
    for(let y=0;y<4;y++) mcSetBlock(tx,h+y,tz,'wood');
    // Leaves
    for(let lx=-2;lx<=2;lx++) for(let lz=-2;lz<=2;lz++) for(let ly=0;ly<3;ly++){
      if(Math.abs(lx)+Math.abs(lz)+Math.abs(ly)<4) mcSetBlock(tx+lx,h+3+ly,tz+lz,'grass');
    }
  });
}

function mcGroundAt(x,z){
  const H=64;
  return H+Math.floor(Math.sin(x*.08)*3+Math.cos(z*.07)*3);
}

function mcSetBlock(x,y,z,type){
  if(!type){ delete mcWorld[`${x},${y},${z}`]; return; }
  mcWorld[`${x},${y},${z}`]=type;
}
function mcGetBlock(x,y,z){ return mcWorld[`${x},${y},${z}`]||null; }

// Chunk rendering system (only render nearby blocks)
let mcMeshes={}, mcLastChunk='';
function mcRenderWorld(){
  const px=Math.round(mcPlayer.x), py=Math.round(mcPlayer.y), pz=Math.round(mcPlayer.z);
  const chunkKey=`${Math.floor(px/8)},${Math.floor(py/8)},${Math.floor(pz/8)}`;
  if(chunkKey===mcLastChunk) return;
  mcLastChunk=chunkKey;

  // Remove old meshes
  Object.values(mcMeshes).forEach(m=>mcScene.remove(m));
  mcMeshes={};

  const RENDER_DIST=20;
  Object.entries(mcWorld).forEach(([key,type])=>{
    const [bx,by,bz]=key.split(',').map(Number);
    if(Math.abs(bx-px)>RENDER_DIST||Math.abs(by-py)>RENDER_DIST||Math.abs(bz-pz)>RENDER_DIST) return;
    if(mcMeshes[key]) return;
    const block=MC_BLOCKS.find(b=>b.id===type)||MC_BLOCKS[0];
    const mat=new THREE.MeshLambertMaterial({
      color:block.color,
      transparent:!!block.transparent,
      opacity:block.transparent?.85:1
    });
    const mesh=new THREE.Mesh(new THREE.BoxGeometry(1,1,1),mat);
    mesh.position.set(bx,by,bz);
    mesh.castShadow=true; mesh.receiveShadow=true;
    mcScene.add(mesh);
    mcMeshes[key]=mesh;
  });
}

function mcOnMouseMove(e){
  if(!mcPlock) return;
  mcPlayer.yaw-=e.movementX*.002;
  mcPlayer.pitch-=e.movementY*.002;
  mcPlayer.pitch=Math.max(-1.4,Math.min(1.4,mcPlayer.pitch));
}

function mcOnMouseDown(e){
  if(!mcPlock) return;
  if(e.button===0) mcBreakBlock(); // left = break
  if(e.button===2) mcPlaceBlock(); // right = place
}

function mcOnWheel(e){
  if(!document.getElementById('mc-canvas').style.display||document.getElementById('mc-canvas').style.display==='none') return;
  mcSelectedSlot=(mcSelectedSlot+(e.deltaY>0?1:-1)+9)%9;
  mcBuildToolbar();
}

function mcBreakBlock(){
  // Raycast forward from camera
  const dir=new THREE.Vector3(Math.sin(mcPlayer.yaw)*Math.cos(mcPlayer.pitch),-Math.sin(mcPlayer.pitch),Math.cos(mcPlayer.yaw)*Math.cos(mcPlayer.pitch));
  for(let d=0.5;d<5;d+=0.25){
    const bx=Math.round(mcPlayer.x+dir.x*d), by=Math.round(mcPlayer.y+dir.y*d), bz=Math.round(mcPlayer.z+dir.z*d);
    if(mcGetBlock(bx,by,bz)){
      mcSetBlock(bx,by,bz,null);
      const key=`${bx},${by},${bz}`;
      if(mcMeshes[key]){mcScene.remove(mcMeshes[key]);delete mcMeshes[key];}
      playSound('click'); break;
    }
  }
}

function mcPlaceBlock(){
  const dir=new THREE.Vector3(Math.sin(mcPlayer.yaw)*Math.cos(mcPlayer.pitch),-Math.sin(mcPlayer.pitch),Math.cos(mcPlayer.yaw)*Math.cos(mcPlayer.pitch));
  let prevBx=null,prevBy=null,prevBz=null;
  for(let d=0.5;d<5;d+=0.25){
    const bx=Math.round(mcPlayer.x+dir.x*d), by=Math.round(mcPlayer.y+dir.y*d), bz=Math.round(mcPlayer.z+dir.z*d);
    if(mcGetBlock(bx,by,bz)){
      if(prevBx!==null&&!(prevBx===Math.round(mcPlayer.x)&&prevBy===Math.round(mcPlayer.y)&&prevBz===Math.round(mcPlayer.z))){
        const blockType=MC_BLOCKS[mcSelectedSlot]?.id||'grass';
        mcSetBlock(prevBx,prevBy,prevBz,blockType);
        mcLastChunk=''; // force re-render
      }
      break;
    }
    prevBx=bx; prevBy=by; prevBz=bz;
  }
}

function mcAddKeyListeners(){
  document.addEventListener('keydown',mcKD);
  document.addEventListener('keyup',mcKU);
}
function mcKD(e){
  if(!document.getElementById('mc-canvas').style.display||document.getElementById('mc-canvas').style.display==='none') return;
  mcKeys[e.code]=true;
  if(e.code==='Space'){e.preventDefault();if(mcFlying){mcPlayer.vy=MC_FLY_SPD;}else if(mcPlayer.onGround){mcPlayer.vy=MC_JUMP;mcPlayer.onGround=false;}}
  if(e.code==='KeyC'&&mcFlying) mcPlayer.vy=-MC_FLY_SPD;
  if(e.code==='KeyF'&&(mcMode==='creative'||S.isAdmin)) mcToggleFly();
  if(e.code==='Escape'&&mcPlock) document.exitPointerLock();
  if(e.code==='Digit1'||e.code==='Numpad1') mcSelectSlot(0);
  if(e.code==='Digit2'||e.code==='Numpad2') mcSelectSlot(1);
  if(e.code==='Digit3'||e.code==='Numpad3') mcSelectSlot(2);
}
function mcKU(e){ mcKeys[e.code]=false; }

function mcToggleFly(){
  if(mcMode!=='creative'&&!S.isAdmin){toast('Voar apenas no modo criativo ou para admin!','warn');return;}
  mcFlying=!mcFlying;
  document.getElementById('mc-fly-btn').textContent=mcFlying?'✈️ Voar: ON':'✈️ Voar: OFF';
  document.getElementById('mc-fly-ind').style.display=mcFlying?'block':'none';
  if(mcFlying) mcPlayer.vy=0;
}

function mcSaveWorld(){
  try{
    const worldData={blocks:mcWorld,mode:mcMode,room:mcRoomCode,player:mcPlayer};
    localStorage.setItem('freegames_mc_world',JSON.stringify(worldData));
    toast('Mundo salvo!','ok');
  }catch(e){toast('Erro ao salvar mundo','err');}
}

function mcAnimLoop(){
  if(!mcScene||!mcRen){return;}
  requestAnimationFrame(mcAnimLoop);
  mcUpdatePlayer();
  mcRenderWorld();
  // Position camera
  mcCam.position.set(mcPlayer.x,mcPlayer.y+1.6,mcPlayer.z);
  mcCam.rotation.order='YXZ';
  mcCam.rotation.y=mcPlayer.yaw;
  mcCam.rotation.x=mcPlayer.pitch;
  // Update coords HUD
  document.getElementById('mc-coords').textContent=`X:${Math.floor(mcPlayer.x)} Y:${Math.floor(mcPlayer.y)} Z:${Math.floor(mcPlayer.z)}`;
  mcRen.render(mcScene,mcCam);
}

function mcUpdatePlayer(){
  const spd=mcFlying?MC_FLY_SPD:MC_SPEED*(S.isAdmin&&adminPowers.speed?2.5:1);
  const sin=Math.sin(mcPlayer.yaw), cos=Math.cos(mcPlayer.yaw);
  let mx=0, mz=0;
  if(mcKeys['KeyW']){mx+=sin;mz+=cos;}
  if(mcKeys['KeyS']){mx-=sin;mz-=cos;}
  if(mcKeys['KeyA']){mx+=cos;mz-=sin;}
  if(mcKeys['KeyD']){mx-=cos;mz+=sin;}
  const len=Math.sqrt(mx*mx+mz*mz)||1;
  mcPlayer.x+=mx/len*spd;
  mcPlayer.z+=mz/len*spd;

  if(mcFlying){
    if(mcKeys['Space']) mcPlayer.y+=MC_FLY_SPD;
    if(mcKeys['KeyC']||mcKeys['ShiftLeft']) mcPlayer.y-=MC_FLY_SPD;
    mcPlayer.vy=0;
  } else {
    // Gravity
    mcPlayer.vy-=MC_GRAVITY;
    mcPlayer.y+=mcPlayer.vy;
    // Simple ground collision — check block below
    const bx=Math.round(mcPlayer.x), bz=Math.round(mcPlayer.z);
    for(let by=Math.floor(mcPlayer.y-0.5);by>=Math.floor(mcPlayer.y-2);by--){
      if(mcGetBlock(bx,by,bz)){
        mcPlayer.y=by+1.5;
        mcPlayer.vy=0;
        mcPlayer.onGround=true;
        break;
      }
    }
    if(mcPlayer.y<60) mcPlayer.y=69; // fall reset
  }
  // World boundary
  mcPlayer.x=Math.max(-MC_HALF+1,Math.min(MC_HALF-1,mcPlayer.x));
  mcPlayer.z=Math.max(-MC_HALF+1,Math.min(MC_HALF-1,mcPlayer.z));

  // Check secret area
  if(Math.abs(mcPlayer.x)<4&&Math.abs(mcPlayer.z)<4&&Math.abs(mcPlayer.y-51)<3){
    if(!PROFILE.owned.includes('secret_7ae')){
      toast('⭐ Você encontrou a área "7 A E MELHOR"!','ok');
      setTimeout(openSecret,1500);
    }
  }
}

// BOOT
(function(){
  goPage('login');
  document.getElementById('adm-btn').style.display='none';
  setTimeout(()=>document.getElementById('galert').classList.add('on'),1500);
  // Try to restore saved session
  try{
    const saved=localStorage.getItem('freegames_profile');
    if(saved){
      const data=JSON.parse(saved);
      Object.assign(PROFILE,data);
      // Restore groups
      if(data.myGroups) ALL_GROUPS.forEach(g=>{if(data.myGroups.includes(g.id))g.joined=true;});
    }
  }catch(e){}
})();
</script>
</body>
</html>
