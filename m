Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaDRIKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:10:37 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42319 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaDRIJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:09:58 -0400
Date: Fri, 18 Apr 2014 10:09:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
Message-ID: <20140418080951.GB14280@gmail.com>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
 <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org>
 <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr>
 <534FDCDC.6000806@linaro.org>
 <20140417144707.GL11096@twins.programming.kicks-ass.net>
 <534FED53.2030804@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FED53.2030804@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> On 04/17/2014 04:47 PM, Peter Zijlstra wrote:
> >On Thu, Apr 17, 2014 at 03:53:32PM +0200, Daniel Lezcano wrote:
> >>Concerning the policy, I would suggest to create an entry in
> >>/proc/sys/kernel/sched_power, where a couple of values could be performance
> >>- power saving (0 / 1).
> >
> >Ingo wanted a sched_balance_policy file with 3 values:
> >   "performance, power, auto"
> >
> >Where the auto thing switches between them, initially based off of
> >having AC or not.
> 
> oh, good. Thanks !

Also, 'auto' should be the default, because the kernel doing TRT is 
really what users want.

Userspace can sill tweak it all and make it all user-space controlled, 
by flipping between 'performance' and 'power'. (and those modes are 
also helpful for development and debugging.)

Thanks,

	Ingo
