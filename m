Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaBTKej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:34:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:58141 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaBTKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:34:37 -0500
Date: Thu, 20 Feb 2014 11:34:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Anton Vorontsov <anton@scarybugs.org>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v3 3/6] kernel/time: Add new helpers to convert ktime
 to/from jiffies
In-Reply-To: <1392885633-7787-4-git-send-email-a.perevalov@samsung.com>
Message-ID: <alpine.DEB.2.02.1402201133550.4468@ionos.tec.linutronix.de>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com> <1392885633-7787-4-git-send-email-a.perevalov@samsung.com>
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

> From: Anton Vorontsov <anton@scarybugs.org>
> 
> Two new functions: jiffies_to_ktime() and ktime_to_jiffies(), we'll use
> them for timerfd deferred timers handling.

I don't think so. That's probably a leftover from the mess you tried
to create earlier.

Thanks,

	tglx

 
