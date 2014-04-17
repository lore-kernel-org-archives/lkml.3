Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaDQOrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:47:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaDQOrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:47:21 -0400
Date: Thu, 17 Apr 2014 16:47:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose
 the idlest cpu
Message-ID: <20140417144707.GL11096@twins.programming.kicks-ass.net>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
 <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org>
 <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr>
 <534FDCDC.6000806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FDCDC.6000806@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 03:53:32PM +0200, Daniel Lezcano wrote:
> Concerning the policy, I would suggest to create an entry in
> /proc/sys/kernel/sched_power, where a couple of values could be performance
> - power saving (0 / 1).

Ingo wanted a sched_balance_policy file with 3 values:
  "performance, power, auto"

Where the auto thing switches between them, initially based off of
having AC or not.
