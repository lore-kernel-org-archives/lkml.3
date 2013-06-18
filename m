Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3FRJJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:09:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37987 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3FRJJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:09:15 -0400
Date: Tue, 18 Jun 2013 11:09:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH] sched/rt: Simplify pull_rt_task() logic and remove
 .leaf_rt_rq_list
Message-ID: <20130618090909.GE3204@twins.programming.kicks-ass.net>
References: <1370633863.9844.92.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370633863.9844.92.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:37:43PM -0400, Steven Rostedt wrote:
> [ Peter, this is based off of some of my work, I ran it though a few 
>   tests and it passed. I also reviewed it, and added my SOB as I am
>   somewhat a co-author to it. ]
> 
> From: Kirill Tkhai <tkhai@yandex.ru>
> 
> Based on the patch by Steven Rostedt from previous year:
> 
> https://lkml.org/lkml/2012/4/18/517
> 
> 1)Simplify pull_rt_task() logic: search in pushable tasks of dest runqueue.
> The only pullable tasks are the tasks which are pushable in their local rq,
> and no others.
> 
> 2)Remove .leaf_rt_rq_list member of struct rt_rq and functions connected
> with it: nobody uses it since now.
> 
> Link: http://lkml.kernel.org/r/287571370557898@web7d.yandex.ru
> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!
