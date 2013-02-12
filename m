Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab3BLSTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:19:22 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:56234 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab3BLSTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:19:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 5/6] of_spi: Add fetching of of_gpio flags to of_spi_register_master
To: Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <511A0DB6.1080702@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-6-git-send-email-andreas@gaisler.com> <20130211002220.AFCA83E0C13@localhost> <511A0DB6.1080702@gaisler.com>
Date: Tue, 12 Feb 2013 17:09:48 +0000
Message-Id: <20130212170948.C5BA63E07C5@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 10:39:02 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> On 2013-02-11 01:22, Grant Likely wrote:
> > On Tue, 29 Jan 2013 15:53:42 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> >> When using a gpio chip select with a OF_GPIO_ACTIVE_LOW flag, this needs to be
> >> known to the controller driver.
> >>
> >> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> >
> > Out of curiosity, what do you need the flags for? Polarity of the CS
> > signal? I think it is long past time to revisit baking polarity control
> > into core of gpiolib. Would you mind investigating doing that instead of
> > having to manage it manually in each and every driver?
> 
> I don't even need it on my hardware. It seemed like a good thing to have 
> via of_spi_register_master. I am OK with just dropping this.

Hahaha. Okay, let's leave it for now until someone does need it. I can
however see the need for the polarity flag, so the request still stands
for someone to put that feature into the core.  :-)

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
