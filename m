Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967297Ab3DRJoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:44:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:43288 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967066Ab3DRJoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:44:05 -0400
Date: Thu, 18 Apr 2013 11:44:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Bohan <mbohan@codeaurora.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] hrtimer: Prevent enqueue of hrtimer on dead CPU
In-Reply-To: <1365628068-32738-3-git-send-email-mbohan@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1304181141170.21884@ionos>
References: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org> <1365628068-32738-3-git-send-email-mbohan@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Michael Bohan wrote:

> When switching the hrtimer cpu_base, we briefly allow for
> preemption to become enabled by unlocking the cpu_base lock.

No, interrupts still stay disabled and there is no way to preempt
here. Can you please explain, what you are trying to do and what makes
you think there is a problem in that code?

Thanks,

	tglx


