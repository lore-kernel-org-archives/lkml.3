Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3J2MqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:46:19 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56101 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3J2MqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:46:18 -0400
Date: Tue, 29 Oct 2013 13:46:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/4] perf tools: Add call-graph option support into
 .perfconfig
Message-ID: <20131029124615.GA17271@gmail.com>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
 <1382797536-32303-4-git-send-email-jolsa@redhat.com>
 <87bo2995o1.fsf@sejong.aot.lge.com>
 <20131029101821.GA1093@krava.brq.redhat.com>
 <20131029124319.GC6944@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029124319.GC6944@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Oct 29, 2013 at 11:18:21AM +0100, Jiri Olsa escreveu:
> > On Mon, Oct 28, 2013 at 05:10:54PM +0900, Namhyung Kim wrote:
> > > > +	opts->call_graph_enabled = !unset;
> > > > +
> > > 
> > > Why not just using symbol_conf.use_callchain?
> > > 
> > 
> > right, this way we'd be in sync with top
> 
> Cool, so a patch on top of what is in perf/urgent would be handy, 
> I'll deal with clashes with what is in perf/core, talking about 
> that I think I should do a merge sooner...

Note that I have resolved those conflicts between perf/urgent and 
perf/core in the latest tip:perf/core tree, please double check the 
conflict resolution and base further work on that if it looks good 
to you.

Thanks,

	Ingo
