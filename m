Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3IXVQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:16:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45643 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab3IXVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:16:45 -0400
Date: Tue, 24 Sep 2013 23:16:41 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, Marc Pignat <marc.pignat@hevs.ch>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] clockevents: Sanitize ticks to nsec conversion
Message-ID: <20130924211641.GF16106@pengutronix.de>
References: <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de>
 <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

just found another little issue ...

On Tue, Sep 24, 2013 at 09:50:23PM +0200, Uwe Kleine-König wrote:
> +/**
> + * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
> + * @latch:	value to convert
> + * @evt:	pointer to clock event device descriptor
> + *
> + * Math helper, returns latch value converted to nanoseconds (bound checked)
> + */
> +u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
... the kernel-doc comment has an 's' too much in the function name.

I'm not sending a v3 for just that. Can you fix that up when/if
applying?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
