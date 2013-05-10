Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3EJJof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:44:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3EJJoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:44:34 -0400
Date: Fri, 10 May 2013 11:43:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130510094357.GG1040@krava.brq.redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <20130509150744.GB3039@dyad.programming.kicks-ass.net>
 <20130509152022.GD1628@krava.brq.redhat.com>
 <20130510092930.GF3039@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510092930.GF3039@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:29:30AM +0200, Peter Zijlstra wrote:
> On Thu, May 09, 2013 at 05:20:22PM +0200, Jiri Olsa wrote:
> > On Thu, May 09, 2013 at 05:07:44PM +0200, Peter Zijlstra wrote:
> > > On Thu, May 09, 2013 at 03:32:15PM +0200, Jiri Olsa wrote:
> > > > hi,
> > > > adding sysfs attribute to specify the maximum allowed value
> > > > for perf_event_attr::precise_ip field.
> > > > 
> > > > Adding functionality for simple 'p' modifier and 'precise' term
> > > > to get the maximum allowed value for perf_event_attr::precise_ip
> > > > field.
> > > > 
> > > 
> > > You've seem to lost the part explaining why we want this.. :-)
> > 
> > well, initially it was an answer when we broke precise event
> > monitoring in kernel so I wrote automated test for it (patches 1,2,3)
> > https://lkml.org/lkml/2012/12/12/561
> 
> Oh urgh 1-3 aren't just tests; they introduce all this nonsense already :/

yep
