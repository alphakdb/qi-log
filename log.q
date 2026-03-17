.log.now:{.z.p}
.log.stdout:-1
.log.FIELDS:()!()

/ configuration functions
.log.setformat:{[fmt] if[not fmt in key .log.render;.log.bad_format];.conf.LOGFORMAT:fmt}
.log.setlevel:{[lvl] 
  a:({x!count[x]#(::)}l:.conf.LOGLEVELS);
  .log,:a,k!(.log.print@)each k:(1+l?lvl)#l;
  .log.fatal:{.log.print[`fatal;x];exit 1};
  }

.log.usefields:{[d] .log.FIELDS:@[d;where 100>type each d;.qi.tostr]}

/ internal functions
.log.seval:{[f] $[(t:type r:f@(::))in -10 10h;r;t<0;string r;-3!r]}
.log.render.plain:" "sv get@
.log.render.logfmt:{" "sv "="sv'flip(string key x;get @[x;`msg;.j.s])}
.log.render.json:.j.j

.log.print:{[lvl;x]
 d:();
 if[not type msg:x;
  if[(0<count d)&99<>type d:last msg;'"second arg must be a fields dict when passing a non-string arg"];
  msg:first x];
 fields:`ts`lvl`h!(string .log.now`;string lvl;string .z.w);
 fields:fields,.log.FIELDS,$[count d;d;()],enlist[`msg]!enlist msg;
 fields:@[fields;where 100<=type each fields;.log.seval];
 .log.stdout .log.render[.conf.LOGFORMAT]fields;
 }

.log.setlevel .conf.LOGLEVEL;

/

usage examples
.log.info"testing"
.log.setformat`logfmt
.log.usefields`pid`user`heap!(.z.i;{.z.u};{.Q.w[]`heap})
.log.warn"testing again"
.log.info("next test";`arg5`ts!("yes";string .z.d))
.log.setformat`json
.log.now:{.z.P}
.log.setformat`plain
