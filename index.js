function import$(n,e){var t={}.hasOwnProperty;for(var r in e)t.call(e,r)&&(n[r]=e[r]);return n}$(document).ready(function(){var n,e,t,r,i,a,s,o,u,c,d,h;return n={},e={linear:function(n){return n},quadratic:function(n){return n*n},easeInOut:function(n){return.5>=n?4*Math.pow(n,3):1-4*Math.pow(1-n,3)}},t=function(n,e,t){var r,i,a,s=[];r={},n.transition={src:r,des:t,config:e,start:(new Date).getTime()};for(i in t)a=t[i],s.push(r[i]=n[i]);return s},r=function(n){var e,t,r,i,a,s,o,u,c,d,h,l;if(null!=n.transition&&(e={src:(e=n.transition).src,des:e.des,config:e.config,start:e.start},t=e.src,r=e.des,i=e.config,a=e.start,e={dur:i.dur,ease:i.ease,delay:i.delay},s=e.dur,o=e.ease,u=e.delay,c=(new Date).getTime(),!(null!=u&&a+u>c))){d=(c-a-(null!=u?u:0))/s,d>=0||(d=0),1>=d||(d=1),o&&(d=o(d));for(h in r)l=r[h],n[h]=t[h]+(r[h]-t[h])*d;return d>=1?(e=n.transition,delete n.transition,e):void 0}},i={pos:[],neg:[]},a=function(n,e){return null==e&&(e=!0),this.reset(n,e),this},s={w:0,h:0,c:1e3,dur:2e3,step:10},a.prototype=o={mod:100,w:4,h:2,m:2,c:{r:200,g:90,b:90},opacity:1,iteration:0,idx:0,pos:function(n){var e;return null==n&&(n=!0),e={x:this.idx%this.mod*(this.w+this.m)+this.m,y:parseInt(this.idx/this.mod)*(this.h+this.m)},n&&(e.y=s.h-e.y),e},reset:function(n,e){return null==e&&(e=!0),null!=n&&(this.idx=n),this.opacity=1,this.iteration=0,import$(this,this.pos(e))}},u=function(){var e,t,r,u,c,d,l,p,g,f,y,w,m;for(e=$("#container"),t=[e.width(),e.height()],s.w=t[0],s.h=t[1],t=t,r=t[0],u=t[1],o.mod=parseInt(r/(o.w+o.m)),n.renderer=c=new PIXI.WebGLRenderer(r,u),$("#container")[0].appendChild(c.view),n.graphics=d=new PIXI.Graphics,d.beginFill(16776960),n.stage=l=new PIXI.Container,l.addChild(d),p={x:5,y:4},g={x:10,y:10},f=0,y=s.c;y>f;++f)w=f,m=new a(w,!1),i.neg.push(m),m=new a(w,!0),i.pos.push(m);return h($("#money")[0].value,!0),c.render(l)},c=function(){var e,t,a,o;for(requestAnimationFrame(c),n.graphics.beginFill(16777215),n.graphics.drawRect(0,0,s.w,s.h),n.graphics.beginFill(3428144384),e=0,a=(t=i.neg).length;a>e;++e)o=t[e],o.transition&&r(o),n.graphics.drawRect(o.x,o.y,3,2);for(n.graphics.beginFill(1439454464),e=0,a=(t=i.pos).length;a>e;++e)o=t[e],o.transition&&r(o),n.graphics.drawRect(o.x,o.y,3,2);return n.renderer.render(n.stage)},d=function(n,r,i,a){var o,u,c,d,h,l,p,g,f,y=[];for(null==i&&(i=!0),null==a&&(a=!1),o=parseInt(n/s.step),i||(o=-o),o<=(u=s.c)||(o=u),o>=0||(o=0),c=a?0:s.dur,d=0;o>d;++d)h=d,l=r[h],u=l.pos(i),p=u.x,g=u.y,t(l,{delay:a?0:parseInt(1e3*Math.random()),dur:c,ease:e.easeInOut},{y:g,opacity:1});for(d=o,f=s.c;f>d;++d)h=d,l=r[h],y.push(t(l,{delay:a?0:parseInt(1e3*Math.random()),dur:c,ease:e.easeInOut},{y:i?0:s.h,opacity:0}));return y},h=function(n,e){return null==e&&(e=!1),d(n,i.neg,!1,e),d(n,i.pos,!0,e)},window.change=function(){return h(document.getElementById("money").value)},u(),c()});