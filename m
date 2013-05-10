Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3EJKgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:36:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38254 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EJKgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:36:23 -0400
Date: Fri, 10 May 2013 12:34:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130510103436.GC31235@dyad.programming.kicks-ass.net>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <20130509150744.GB3039@dyad.programming.kicks-ass.net>
 <20130509152022.GD1628@krava.brq.redhat.com>
 <20130510092741.GE3039@dyad.programming.kicks-ass.net>
 <20130510094053.GF1040@krava.brq.redhat.com>
 <20130510095345.GG3039@dyad.programming.kicks-ass.net>
 <20130510101823.GA18427@gmail.com>
 <20130510102245.GA31235@dyad.programming.kicks-ass.net>
 <20130510103112.GA18755@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510103112.GA18755@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:31:12PM +0200, Ingo Molnar wrote:
> PERF_COUNT_HW_CPU_CYCLES_PRECISE is not a vague request at all: it means 
> 'get me the most precise cycles profiling available on this system'.

And how will you interpret the results? Do you know to manually adjust for skid
or will you assume the results 'correct'?

I see such a feature only causing confusion; I told it to be precise, therefore
this register op after the memory load really is the more expensive thing.

People generally don't volunteer to think, you have to force them to -- even if
that makes them complain.
