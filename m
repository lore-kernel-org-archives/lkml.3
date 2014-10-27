Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaJ0VlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:41:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:40754 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJ0VlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:41:15 -0400
Date: Mon, 27 Oct 2014 22:41:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH RFC 06/12] time: Fix build warnings for time64_t to
 __kernel_time_t warning on 64-bit systems.
In-Reply-To: <1414388802-5866-5-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410272239370.5308@nanos>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org> <1414388802-5866-5-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, pang.xunlei wrote:

> The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
> will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.
> 
> This patch fixed the build warnings brought by former patches.

If we know that the previous patch introduced the warning and that
patch has not yet been committed to any immutable git tree then we fix
it in that very patch and not after the fact.

Thanks,

	tglx
