Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaBTLJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:09:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:58365 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaBTLJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:09:37 -0500
Date: Thu, 20 Feb 2014 12:09:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Anton Vorontsov <anton@enomsg.org>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v3 5/6] timerfd: Add support for deferrable timers
In-Reply-To: <1392885633-7787-6-git-send-email-a.perevalov@samsung.com>
Message-ID: <alpine.DEB.2.02.1402201152440.4468@ionos.tec.linutronix.de>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com> <1392885633-7787-6-git-send-email-a.perevalov@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Alexey Perevalov wrote:

> From: Anton Vorontsov <anton@enomsg.org>
> 
> This patch implements a userland-side API for generic deferrable timers,
> per linux/timer.h:
> 
>  * A deferrable timer will work normally when the system is busy, but
>  * will not cause a CPU to come out of idle just to service it; instead,
>  * the timer will be serviced when the CPU eventually wakes up with a
>  * subsequent non-deferrable timer.
> 
> These timers are crucial for power saving, i.e. periodic tasks that want
> to work in background when the system is under use, but don't want to
> cause wakeups themselves.
> 
> The deferred timers are somewhat orthogonal to high-res external timers,
> since the deferred timer is tied to the system load, not just to some
> external decrementer source.

Again this changelog makes no sense. What's orthogonal to high-res
timers and why are they external?

So 5 out of 6 patches are a trainwreck in various degrees of
wreckage. A pretty impressive achievement.

Thanks,

	tglx
