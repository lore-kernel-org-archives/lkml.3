Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaHJPQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 11:16:44 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45997 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaHJPQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 11:16:43 -0400
Date: Sun, 10 Aug 2014 17:16:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140810151636.GA25121@gmail.com>
References: <20140810044127.GB11810@localhost>
 <20140810075915.GR9918@twins.programming.kicks-ass.net>
 <20140810105413.GA29451@localhost>
 <20140810150503.GV9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140810150503.GV9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, Aug 10, 2014 at 06:54:13PM +0800, Fengguang Wu wrote:
> > The "brickland1/aim7/6000-page_test" is the test case part.
> > 
> > The "TOTAL XXX" is the metric part. One test run may generate lots of
> > metrics, reflecting different aspect of the system dynamics.
> > 
> > This view may be easier to read, by grouping the metrics by test case.
> 
> Right, at least that makes more sense.
> 
> > test case: brickland1/aim7/6000-page_test
> 
> Ok, so next question, what is a brickland? I suspect its a machine of
> sorts, seeing how some others had wsm in that part of the test. Now I
> know what a westmere is, but I've never heard of a brickland.
> 
> Please describe the machine, this is a topology patch, so we need to
> know the topology of the affected machines.

Wikipedia says:

http://en.wikipedia.org/wiki/List_of_Intel_codenames

Brickland 	Platform 	High-end server platform based on the Ivy Bridge-EX processor.[6] 	Reference unknown. 	2010

Thanks,

	Ingo
