Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3BUTjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:39:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:51791 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3BUTjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:39:03 -0500
Date: Thu, 21 Feb 2013 20:39:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Abbott <abbotti@mev.co.uk>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] timers: Add jsleep() and jsleep_interruptible()
In-Reply-To: <1361472491-10848-1-git-send-email-abbotti@mev.co.uk>
Message-ID: <alpine.LFD.2.02.1302212008360.22263@ionos>
References: <1361472491-10848-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, Ian Abbott wrote:
> I'm not sure how useful this would be, but there are a couple of places
> in "serial_core.c" that could usefully call jsleep_interruptible()
> instead of msleep_interruptible().

Oh no. jiffies is such a misconception. 

We want to get rid of jiffies in the long run not fostering the usage.

Thanks,

	tglx
