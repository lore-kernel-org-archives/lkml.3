Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3KTJW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:22:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52828 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3KTJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:22:51 -0500
Date: Wed, 20 Nov 2013 10:22:48 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: time-efm32: Select CLKSRC_MMIO
Message-ID: <20131120092248.GL28642@pengutronix.de>
References: <1384913711.13115.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384913711.13115.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:15:11AM +0800, Axel Lin wrote:
> The time-efm32 driver uses the clocksource MMIO functions.
> Thus it needs to select CLKSRC_MMIO in Kconfig.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Good catch. I selected CLKSRC_MMIO from MACH_EFM32 (still out-of-tree)
but of course this is wrong.

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
