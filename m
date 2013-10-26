Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3JZMfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 08:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab3JZMfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 08:35:54 -0400
Date: Sat, 26 Oct 2013 14:35:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFP: Fixing "-ga -ag -g fp -g dwarf" was Re: [PATCHSET 0/8] perf
 tools: Fix scalability problem on callchain merging (v5)
Message-ID: <20131026123536.GA1069@krava.brq.redhat.com>
References: <20131011073448.GA11064@krava.redhat.com>
 <52581511.2010909@gmail.com>
 <52581737.8090309@gmail.com>
 <20131012165319.GB15116@gmail.com>
 <5259A63B.5050406@gmail.com>
 <20131013052328.GA22563@gmail.com>
 <20131025190951.GC1853@ghostprotocols.net>
 <526AC4F3.1020404@gmail.com>
 <20131025194643.GE1853@ghostprotocols.net>
 <20131026120336.GA24439@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026120336.GA24439@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 02:03:36PM +0200, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> 
> > Em Fri, Oct 25, 2013 at 01:22:27PM -0600, David Ahern escreveu:
> > > On 10/25/13 1:09 PM, Arnaldo Carvalho de Melo wrote:
> > > >>>I think I did with the second follow up patch: -ga -ag -g fp -g
> > > >>>dwarf should all work properly with fp the default for -g.
> > 
> > > >>Acked-by: Ingo Molnar <mingo@kernel.org>
> > 
> > > >Can I have this one submitted?
> >  
> > > Upon further review, Jiri was correct: that patch handles some of
> > > the old cases fine, but did not handle others. ie., it just moved
> > > the bad syntax problem around.
> > 
> > perhaps we can do, at least for now, with what Ingo suggested?
> > 
> > Namely, having:
> > 
> > --call-graph   Require an argument, either "dwarf" or "fp"
> > -g             Doesn't require anything, uses whatever is configured,
> >                fp if no explicit config is done in places like
> >                ~/.perfconfig
> > 
> > Fits with what most people do usually, no?
> 
> Please do this! Usability sucks right now, going from '-g' to
> '-g <foo>' was an incompatible change, a regression I argue,
> which should be fixed in an urgent branch ASAP.

about to finish patches with that, will send it soon

jirka
