Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3IIPEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:04:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39055 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3IIPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:04:09 -0400
Date: Mon, 9 Sep 2013 17:03:46 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
        grant.likely@linaro.org, linux@arm.linux.org.uk, rob@landley.net,
        ian.campbell@citrix.com, swarren@wwwdotorg.org, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv3 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20130909150346.GV30088@pengutronix.de>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
	grant.likely@linaro.org, linux@arm.linux.org.uk, rob@landley.net,
	ian.campbell@citrix.com, swarren@wwwdotorg.org,
	mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
	linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, Jingchang Lu <b35083@freescale.com>
References: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
 <1378454907-22728-2-git-send-email-Li.Xiubo@freescale.com>
 <20130909122008.GC22197@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909122008.GC22197@ulmo>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:03:05 up 16 days, 33 min, 48 users,  load average: 0.13, 0.28,
 0.39
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:20:09PM +0200, Thierry Reding wrote:
> On Fri, Sep 06, 2013 at 04:08:24PM +0800, Xiubo Li wrote:
> > The FTM PWM device can be found on Vybrid VF610 Tower and Layerscape LS-1 SoCs.
> > 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> > ---
> >  drivers/pwm/Kconfig       |  10 +
> >  drivers/pwm/Makefile      |   1 +
> >  drivers/pwm/pwm-fsl-ftm.c | 505 ++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 516 insertions(+)
> >  create mode 100644 drivers/pwm/pwm-fsl-ftm.c
> 
> This looks pretty good to me. I noticed that you didn't Cc Sascha who
> commented on this a lot. Can you please resend with him Cc'ed to make
> sure he sees this version of the series?

I'm already aware of this, no need to resend. I'll have a look over it
tomorrow.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
