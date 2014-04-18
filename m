Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaDRJjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:39:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59108 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaDRJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:39:00 -0400
Date: Fri, 18 Apr 2014 11:38:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
Message-ID: <20140418093845.GD11096@twins.programming.kicks-ass.net>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
 <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org>
 <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr>
 <534FDCDC.6000806@linaro.org>
 <alpine.LFD.2.11.1404171138470.980@knanqh.ubzr>
 <534FFBB3.8050601@linaro.org>
 <alpine.LFD.2.11.1404171207531.980@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1404171207531.980@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:21:28PM -0400, Nicolas Pitre wrote:
> CPU topology is needed to properly describe scheduling domains.  Whether 
> we balance across domains or pack using as few domains as possible is a 
> separate issue.  In other words, you shouldn't have to care in this 
> patch series.
> 
> And IMHO coupled C-state is a low-level mechanism that should remain 
> private to cpuidle which the scheduler shouldn't be aware of.

I'm confused.. why wouldn't you want to expose these?
