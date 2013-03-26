Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322Ab3CZJXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:23:16 -0400
Received: from sauhun.de ([89.238.76.85]:57788 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934019Ab3CZJXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:23:14 -0400
Date: Tue, 26 Mar 2013 10:23:07 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Yuvaraj CD <yuvaraj.lkml@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        grundler@chromium.org, naveenkrishna.ch@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [RFC: PATCH v5] i2c: exynos5: add High Speed I2C controller
 driver
Message-ID: <20130326092306.GA8553@the-dreams.de>
References: <1363062732-27869-1-git-send-email-ch.naveen@samsung.com>
 <1363796690-30242-1-git-send-email-ch.naveen@samsung.com>
 <CA+NduCBFUTW9Pu1k4NyTK+tFUyWUHBbMONO_oAr6PK+y30sYDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+NduCBFUTW9Pu1k4NyTK+tFUyWUHBbMONO_oAr6PK+y30sYDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +       /* CLK_DIV max is 256 */
> > +       for (i = 0; i < 256; i++) {
> > +               utemp1 = utemp0 / (i + 1);
> > +               /* SCLK_L/H max is 256 / 2 */
> > +               if (utemp1 < 128) {
> I think TSCLK_L and TSCLK_H both can be configured upto 255.Why
> limiting it to < 128 ?
> By limiting it to < 128 dont we achieve lesser SCL clock?

Thanks for reviewing but please quote only the relevant part of the
message (like I did). This improves readability a lot.
