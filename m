Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaBFUuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:50:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:37940 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaBFUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:50:23 -0500
Date: Thu, 6 Feb 2014 21:50:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
In-Reply-To: <52F3C8A5.708@samsung.com>
Message-ID: <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com> <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de> <52F1DDA8.90605@samsung.com> <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org> <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de> <52F3C8A5.708@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Alexey Perevalov wrote:
> On 02/06/2014 02:16 AM, Thomas Gleixner wrote:
> As I truly understand, you decided - flags is better than new clockids, and
> internals of timerfd could be a mix of timer_list and hrtimer.

NO, NO, NO, NO. There is no mix of timer_list and hrtimer. Either we
add proper deferrable support to hrtimers or the whole thing is not
going to happen at all. There is no way that we bring back timer_list
to user space interfaces. Period.

Thanks,

	tglx


