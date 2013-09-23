Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3IWHEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:04:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43538 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3IWHEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:04:07 -0400
Date: Mon, 23 Sep 2013 09:03:26 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: cinifr <cinifr@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        coosty@163.com, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130923070326.GC16106@pengutronix.de>
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
 <1379768716-11672-2-git-send-email-cinifr@gmail.com>
 <20130921140059.GA2779@lukather>
 <CAK3cCByL3nD5pMdDwAkxOE8pP0HQEWthD1HUPJ70VeprNpLzBA@mail.gmail.com>
 <20130921224900.GF2779@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130921224900.GF2779@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 21, 2013 at 05:49:00PM -0500, Maxime Ripard wrote:
> On Sun, Sep 22, 2013 at 12:49:45AM +0800, cinifr wrote:
> > Thanks. I have modify my patch as you said.
> > It is in attachments. Maybe I remail the new patch?
> 
> Yes, remail the whole serie and change the prefix to PATCHv3 (you can
> use the --subject-prefix option of git format-patch to do so).
git >= 1.8.2 also support --reroll-count 3 which also changes the filenames
of the patches.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
