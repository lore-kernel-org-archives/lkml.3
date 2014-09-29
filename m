Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaI2K6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:58:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaI2K6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:58:49 -0400
Date: Mon, 29 Sep 2014 12:58:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 0/4] pwm: imx: support output polarity inversion
Message-ID: <20140929105842.GG4958@pengutronix.de>
References: <1408517756-9412-1-git-send-email-LW@KARO-electronics.de>
 <20140826092409.7dea5530@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140826092409.7dea5530@ipc1.ka-ro>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:47:48 up 19 days,  3:35, 80 users,  load average: 0.05, 0.10,
 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 09:24:09AM +0200, Lothar Waßmann wrote:
> Hi,
> 
> Lothar Waßmann wrote:
> > This patch series adds support for polarity inversion to the pwm-imx
> > driver. The patches have been tested on i.MX6, i.MX53 and with the
> > ti-ehrpwm.c driver.
> > 
> > Changes wrt. v2:
> > - make the use of '#pwm-cells = <3>' optional, so that the change does
> >   not break existing DT blobs as suggested by Arnd Bergmann and Sascha
> >   Hauer.
> > 
> > Changes wrt. v3:
> > - implemented the approach suggested by Sascha Hauer 
> > - don't modify struct pwm_ops in the imx_pwm probe function
> > 
> > 
> Any further comments?

No, except this one:

Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
