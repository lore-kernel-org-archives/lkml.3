Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3IXVLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:11:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44362 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab3IXVLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:11:47 -0400
Date: Tue, 24 Sep 2013 23:11:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Marc Pignat <marc.pignat@hevs.ch>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Timekeeping on at91rm9200 [Was: [PATCH v2] clockevents: Sanitize
 ticks to nsec conversion]
Message-ID: <20130924211139.GE16106@pengutronix.de>
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

Hello Nicolas, hello Jean-Christophe,

I expect you should be able to revert 

	b7a8ca5 (ARM: at91: rm9200 fix time support)

which reverted 

	838a2ae (ARM: use clockevents_config_and_register() where possible)

for at91rm9200 on top of the patch this mail is a reply to.

Can you please test that?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
