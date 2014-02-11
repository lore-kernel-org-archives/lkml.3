Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaBKJVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:21:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47891 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaBKJVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:21:12 -0500
Date: Tue, 11 Feb 2014 10:21:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v2] sched: Init idle->on_rq in init_idle()
Message-ID: <20140211092108.GL27965@twins.programming.kicks-ass.net>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
 <1391803122-4425-2-git-send-email-bigeasy@linutronix.de>
 <20140207210905.GV5002@laptop.programming.kicks-ass.net>
 <20140211091758.GA19477@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211091758.GA19477@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:17:58AM +0100, Sebastian Andrzej Siewior wrote:
> The init task is state TASK_RUNNING and on_irq should be set to 1. It won't

					^^^ irq? :-)

> be set by scheduler because the idle task is never woken up, it is always the
> task we fall back to if there is no other task pending.

But why? Who cares? I mean, its true.. but what problem does it solve.
Why did Thomas write this patch.

