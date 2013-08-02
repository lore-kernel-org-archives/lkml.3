Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3HBQ0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:26:00 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35590 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3HBQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:25:58 -0400
Date: Fri, 2 Aug 2013 18:25:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf: Account freq events per cpu
Message-ID: <20130802162552.GE13170@somewhere>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
 <20130801124658.GC1032@krava.brq.redhat.com>
 <20130801133155.GB27162@twins.programming.kicks-ass.net>
 <20130801135525.GE431@somewhere>
 <20130801140352.GE27162@twins.programming.kicks-ass.net>
 <20130801140615.GF27162@twins.programming.kicks-ass.net>
 <20130801142109.GH431@somewhere>
 <20130801144005.GG27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801144005.GG27162@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 04:40:05PM +0200, Peter Zijlstra wrote:
> On Thu, Aug 01, 2013 at 04:21:11PM +0200, Frederic Weisbecker wrote:
> > > > Yeah, just go with a single global state for now..
> > > 
> > > The perf default is to create inherited counter, which are per cpu
> > > anyway. So we'll not loose much.
> > 
> > So you mean that I keep the per cpu state when event->cpu != -1 and also have
> > a global counter for the others. Right?
> 
> No, only a single global counter. The fact that perf, by default,
> creates a counter per cpu, means that there's little effective
> difference between a single global counter and per-cpu counters.

Good point! I just included that in the changelog.

Thanks.
