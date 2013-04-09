Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935335Ab3DIXrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:47:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:43528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934886Ab3DIXqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:46:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="316892415"
Date: Wed, 10 Apr 2013 07:46:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, kbuild-all@01.org,
        Christopher Li <sparse@chrisli.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: include/trace/events/kmem.h:47:1: sparse: cast from restricted
 gfp_t
Message-ID: <20130409234647.GA6916@localhost>
References: <515f9fa5.Wgg6IDtv/7bWnfni%fengguang.wu@intel.com>
 <1365522679.25498.65.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365522679.25498.65.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:51:19AM -0400, Steven Rostedt wrote:
> On Sat, 2013-04-06 at 12:08 +0800, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
> > head:   d08d528dc1848fb369a0b27cdb0749d8f6f38063
> > commit: 62ba180e80f4194a498585ac0e4c07daa8ca08d1 tracing: add flag output for kmem events
> > date:   3 years, 10 months ago
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> 
> These are meaningless errors. I don't see anything here that we should
> be concerned about.

Sorry. It's the second time I see such gfp_t warnings commented as
harmless.

Should I blacklist "sparse: cast from restricted gfp_t", or the more
general pattern "sparse: cast from restricted"?

Thanks,
Fengguang
 
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:47:1: sparse: incorrect type in argument 3 (different base types)
> >    include/trace/events/kmem.h:47:1:    expected unsigned long [unsigned] flags
> >    include/trace/events/kmem.h:47:1:    got restricted gfp_t [usertype] gfp_flags
> >    include/trace/events/kmem.h:47:1: sparse: symbol 'ftrace_raw_output_kmalloc' was not declared. Should it be static?
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:81:1: sparse: incorrect type in argument 3 (different base types)
> >    include/trace/events/kmem.h:81:1:    expected unsigned long [unsigned] flags
> >    include/trace/events/kmem.h:81:1:    got restricted gfp_t [usertype] gfp_flags
> >    include/trace/events/kmem.h:81:1: sparse: symbol 'ftrace_raw_output_kmem_cache_alloc' was not declared. Should it be static?
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:115:1: sparse: incorrect type in argument 3 (different base types)
> >    include/trace/events/kmem.h:115:1:    expected unsigned long [unsigned] flags
> >    include/trace/events/kmem.h:115:1:    got restricted gfp_t [usertype] gfp_flags
> >    include/trace/events/kmem.h:115:1: sparse: symbol 'ftrace_raw_output_kmalloc_node' was not declared. Should it be static?
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: cast from restricted gfp_t
> > >> include/trace/events/kmem.h:153:1: sparse: incorrect type in argument 3 (different base types)
> >    include/trace/events/kmem.h:153:1:    expected unsigned long [unsigned] flags
> >    include/trace/events/kmem.h:153:1:    got restricted gfp_t [usertype] gfp_flags
> > >> include/trace/events/kmem.h:153:1: sparse: too many warnings
> >    include/trace/events/kmem.h:47:1: sparse: incompatible types for operation (<)
> >    include/trace/events/kmem.h:47:1:    left side has type void const *<noident>
> >    include/trace/events/kmem.h:47:1:    right side has type int
> >    include/trace/events/kmem.h:81:1: sparse: incompatible types for operation (<)
> >    include/trace/events/kmem.h:81:1:    left side has type void const *<noident>
> >    include/trace/events/kmem.h:81:1:    right side has type int
> >    include/trace/events/kmem.h:115:1: sparse: incompatible types for operation (<)
> >    include/trace/events/kmem.h:115:1:    left side has type void const *<noident>
> >    include/trace/events/kmem.h:115:1:    right side has type int
> >    include/trace/events/kmem.h:153:1: sparse: incompatible types for operation (<)
> >    include/trace/events/kmem.h:153:1:    left side has type void const *<noident>
> >    include/trace/events/kmem.h:153:1:    right side has type int
> >    include/trace/events/kmem.h:191:1: sparse: incompatible types for operation (<)
> >    include/trace/events/kmem.h:191:1:    left side has type void const *<noident>
> >    include/trace/events/kmem.h:191:1:    right side has type int
> >    include/trace/events/kmem.h:210:1: sparse: incompatible types for operation (<)
> >    include/trace/events/kmem.h:210:1:    left side has type void const *<noident>
> >    include/trace/events/kmem.h:210:1:    right side has type int
> >    In file included from arch/x86/include/asm/smp.h:13:0,
> >                     from arch/x86/include/asm/mmzone_64.h:12,
> >                     from arch/x86/include/asm/mmzone.h:4,
> >                     from include/linux/mmzone.h:775,
> >                     from include/linux/gfp.h:4,
> >                     from include/linux/mm.h:8,
> >                     from mm/util.c:1:
> >    arch/x86/include/asm/apic.h: In function 'native_apic_msr_read':
> >    arch/x86/include/asm/apic.h:135:11: warning: variable 'high' set but not used [-Wunused-but-set-variable]
> >    arch/x86/include/asm/apic.h: In function 'x2apic_enabled':
> >    arch/x86/include/asm/apic.h:176:11: warning: variable 'msr2' set but not used [-Wunused-but-set-variable]
> >    In file included from include/trace/ftrace.h:162:0,
> >                     from include/trace/define_trace.h:56,
> >                     from include/trace/events/kmem.h:231,
> >                     from mm/util.c:10:
> >    include/trace/events/kmem.h: In function 'ftrace_raw_output_kfree':
> >    include/trace/events/kmem.h:191:1: warning: variable 'p' set but not used [-Wunused-but-set-variable]
> >    include/trace/events/kmem.h: In function 'ftrace_raw_output_kmem_cache_free':
> >    include/trace/events/kmem.h:210:1: warning: variable 'p' set but not used [-Wunused-but-set-variable]
> > 
> > vim +47 include/trace/events/kmem.h
> > 
> >     41		{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
> >     42		{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
> >     43		{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
> >     44		{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
> >     45		) : "GFP_NOWAIT"
> >     46	
> >   > 47	TRACE_EVENT(kmalloc,
> >     48	
> >     49		TP_PROTO(unsigned long call_site,
> >     50			 const void *ptr,
> >     51			 size_t bytes_req,
> >     52			 size_t bytes_alloc,
> >     53			 gfp_t gfp_flags),
> >     54	
> >     55		TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
> >     56	
> >     57		TP_STRUCT__entry(
> >     58			__field(	unsigned long,	call_site	)
> >     59			__field(	const void *,	ptr		)
> >     60			__field(	size_t,		bytes_req	)
> >     61			__field(	size_t,		bytes_alloc	)
> >     62			__field(	gfp_t,		gfp_flags	)
> >     63		),
> >     64	
> >     65		TP_fast_assign(
> >     66			__entry->call_site	= call_site;
> >     67			__entry->ptr		= ptr;
> >     68			__entry->bytes_req	= bytes_req;
> >     69			__entry->bytes_alloc	= bytes_alloc;
> >     70			__entry->gfp_flags	= gfp_flags;
> >     71		),
> >     72	
> >     73		TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
> >     74			__entry->call_site,
> >     75			__entry->ptr,
> >     76			__entry->bytes_req,
> >     77			__entry->bytes_alloc,
> >     78			show_gfp_flags(__entry->gfp_flags))
> >     79	);
> >     80	
> >     81	TRACE_EVENT(kmem_cache_alloc,
> >     82	
> >     83		TP_PROTO(unsigned long call_site,
> >     84			 const void *ptr,
> >     85			 size_t bytes_req,
> >     86			 size_t bytes_alloc,
> >     87			 gfp_t gfp_flags),
> >     88	
> >     89		TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
> >     90	
> >     91		TP_STRUCT__entry(
> >     92			__field(	unsigned long,	call_site	)
> >     93			__field(	const void *,	ptr		)
> >     94			__field(	size_t,		bytes_req	)
> >     95			__field(	size_t,		bytes_alloc	)
> >     96			__field(	gfp_t,		gfp_flags	)
> >     97		),
> >     98	
> >     99		TP_fast_assign(
> >    100			__entry->call_site	= call_site;
> >    101			__entry->ptr		= ptr;
> >    102			__entry->bytes_req	= bytes_req;
> >    103			__entry->bytes_alloc	= bytes_alloc;
> >    104			__entry->gfp_flags	= gfp_flags;
> >    105		),
> >    106	
> >    107		TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
> >    108			__entry->call_site,
> >    109			__entry->ptr,
> >    110			__entry->bytes_req,
> >    111			__entry->bytes_alloc,
> >    112			show_gfp_flags(__entry->gfp_flags))
> >    113	);
> >    114	
> >    115	TRACE_EVENT(kmalloc_node,
> >    116	
> >    117		TP_PROTO(unsigned long call_site,
> >    118			 const void *ptr,
> >    119			 size_t bytes_req,
> >    120			 size_t bytes_alloc,
> >    121			 gfp_t gfp_flags,
> >    122			 int node),
> >    123	
> >    124		TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
> >    125	
> >    126		TP_STRUCT__entry(
> >    127			__field(	unsigned long,	call_site	)
> >    128			__field(	const void *,	ptr		)
> >    129			__field(	size_t,		bytes_req	)
> >    130			__field(	size_t,		bytes_alloc	)
> >    131			__field(	gfp_t,		gfp_flags	)
> >    132			__field(	int,		node		)
> >    133		),
> >    134	
> >    135		TP_fast_assign(
> >    136			__entry->call_site	= call_site;
> >    137			__entry->ptr		= ptr;
> >    138			__entry->bytes_req	= bytes_req;
> >    139			__entry->bytes_alloc	= bytes_alloc;
> >    140			__entry->gfp_flags	= gfp_flags;
> >    141			__entry->node		= node;
> >    142		),
> >    143	
> >    144		TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
> >    145			__entry->call_site,
> >    146			__entry->ptr,
> >    147			__entry->bytes_req,
> >    148			__entry->bytes_alloc,
> >    149			show_gfp_flags(__entry->gfp_flags),
> >    150			__entry->node)
> >    151	);
> >    152	
> >    153	TRACE_EVENT(kmem_cache_alloc_node,
> >    154	
> >    155		TP_PROTO(unsigned long call_site,
> >    156			 const void *ptr,
> > 
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
