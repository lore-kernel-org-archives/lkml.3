Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3IQJgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:36:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33641 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3IQJgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:36:48 -0400
Date: Tue, 17 Sep 2013 11:36:22 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: thierry.reding@gmail.com, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: allow for non-increasing brightness levels
Message-ID: <20130917093622.GB30088@pengutronix.de>
References: <1379010952-8928-1-git-send-email-mikedunn@newsguy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379010952-8928-1-git-send-email-mikedunn@newsguy.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:31:33 up 23 days, 19:02, 49 users,  load average: 0.05, 0.07,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Sep 12, 2013 at 11:35:52AM -0700, Mike Dunn wrote:
> Currently the driver assumes that the values specified in the brightness-levels
> device tree property increase as they are parsed from left to right.  But boards
> that invert the signal between the PWM output and the backlight will need to
> specify decreasing brightness-levels.  This patch removes the assumption that
> the last element of the array is the max value, and instead searches the array
> for the max value and uses that as the normalizing value when determining the
> duty cycle.

Note there's also support for inverted PWMs in the PWM framework
provided your hardware supports this.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
