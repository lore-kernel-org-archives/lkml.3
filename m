Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaBTLM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:12:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:58394 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaBTLM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:12:26 -0500
Date: Thu, 20 Feb 2014 12:12:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3 0/6] Deferrable timers support for hrtimers/timerfd
 API
In-Reply-To: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
Message-ID: <alpine.DEB.2.02.1402201209550.4468@ionos.tec.linutronix.de>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
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

> Hello.
> 
> This is a combo patch set for support defferability in timerfd.
> Due implementation of timerfd is based on hrtimers and only on hrtimers,
> it was necessary to add such deferrability into hrtimers too.

Sigh, this is not about timerfd. Adding new clock ids exposes them to
all other hrtimer based interfaces as well.
 
Thanks,

	tglx
