Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3DPNim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:38:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58134 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3DPNik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:38:40 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 16 Apr 2013 06:38:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, olof@lixom.net, djkurtz@chromium.org,
        swarren@wwwdotorg.org, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 1/3] i2c: mux: Add i2c-arb-gpio-challenge 'mux' driver
Message-ID: <20130416133858.GC30206@roeck-us.net>
References: <1363192583-26363-1-git-send-email-dianders@chromium.org>
 <1365543270-10736-1-git-send-email-dianders@chromium.org>
 <20130416093633.GC16978@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416093633.GC16978@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:36:33AM +0200, Wolfram Sang wrote:
> Doug,
> 
[ ... ]
> 
> "callenge & response"?
> 
> ...
> 
> > diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> > new file mode 100644
> > index 0000000..bda020a
> > --- /dev/null
> > +++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> > @@ -0,0 +1,252 @@
> > +/*
> > + * GPIO-based I2C Arbitration
> 
> "callenge & response"?
> 
s/callenge/challenge/g
