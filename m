Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3DVNu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:50:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:58166 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3DVNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:50:58 -0400
Date: Mon, 22 Apr 2013 15:50:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
In-Reply-To: <201304221404.31281.arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1304221519221.21884@ionos>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de> <20130419150927.GE15233@pengutronix.de> <20130422100219.GH15233@pengutronix.de> <201304221404.31281.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1473770335-1366637420=:21884"
Content-ID: <alpine.LFD.2.02.1304221532010.21884@ionos>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1473770335-1366637420=:21884
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.02.1304221532011.21884@ionos>

On Mon, 22 Apr 2013, Arnd Bergmann wrote:
> On Monday 22 April 2013, Uwe Kleine-König wrote:
> > For the uncommented files using %32 instead of -gc->irq_base should
> > work.
> 
> I'm not sure I understand why this doesn't work for the ones that use
> a base that isn't a multiple of 32. Since you are masking the hwirq
> rather than the irq number, it will still be zero-based, won't it?

The issue is that for anything which uses this w/o irq domains
d->hwirq is 0.

Thanks,

	tglx


--8323328-1473770335-1366637420=:21884--
