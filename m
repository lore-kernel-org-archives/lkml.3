Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaBUKky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:40:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:37631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaBUKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:40:53 -0500
Date: Fri, 21 Feb 2014 11:41:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anton Vorontsov <anton@enomsg.org>
cc: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, anton@nomsg.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3 4/6] timerfd: Factor out timer-type unspecific
 timerfd_expire()
In-Reply-To: <20140221041325.GA19817@teo>
Message-ID: <alpine.DEB.2.02.1402211140280.21251@ionos.tec.linutronix.de>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com> <1392885633-7787-5-git-send-email-a.perevalov@samsung.com> <alpine.DEB.2.02.1402201136500.4468@ionos.tec.linutronix.de> <20140221041325.GA19817@teo>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Anton Vorontsov wrote:
> On Thu, Feb 20, 2014 at 11:52:03AM +0100, Thomas Gleixner wrote:
> Instead of rushing with resending yet another series, please actually read
> Thomas' review.

And please hold off until we sorted out the clockid vs. flags discussion.

Thanks,

	tglx
