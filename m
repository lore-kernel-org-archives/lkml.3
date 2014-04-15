Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaDOSmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:42:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:59495 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaDOSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:42:22 -0400
Date: Tue, 15 Apr 2014 20:42:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH V1 Resend 1/5] tick-common: fix wrong check in
 tick_check_replacement()
In-Reply-To: <486a02efe0246635aaba786e24b42d316438bf3b.1397537987.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1404152031440.22697@ionos.tec.linutronix.de>
References: <cover.1397537986.git.viresh.kumar@linaro.org> <486a02efe0246635aaba786e24b42d316438bf3b.1397537987.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;3202;0c

On Tue, 15 Apr 2014, Viresh Kumar wrote:

> tick_check_replacement() returns if a replacement of clock_event_device is
> possible or not. It does this as the first check:
> 
> 	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
> 		return false;
> 
> This looks wrong as we are returning false when tick_check_percpu() returned
> true. Probably Thomas forgot '!' here in his commit: 03e13cf5e ?

Come on. You can do better changelogs.

"This looks wrong" is definitely not a good description of the
problem.

Either you know WHY it is wrong, then you say so. If not, then you can
send an RFC.

I fixed the changelog up this time.
 
Thanks,

	tglx
