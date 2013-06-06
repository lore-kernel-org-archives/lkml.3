Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3FFIDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:03:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48537 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3FFIDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:03:06 -0400
Date: Thu, 6 Jun 2013 10:03:00 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, Rob Landley <rob@landley.net>,
        kernel@pengutronix.de
Subject: Re: [PATCH v3] pwm: add pca9685 driver
Message-ID: <20130606080300.GG21522@pengutronix.de>
References: <1369900212-14368-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369900212-14368-1-git-send-email-s.trumtrar@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:01:44 up 88 days, 17:42, 24 users,  load average: 0.41, 0.44,
 0.36
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 09:50:12AM +0200, Steffen Trumtrar wrote:
> Add pwm driver for the NXP pca9685 16 channel pwm-led controller.
> 
> The driver is really barebones at this stage. E.g. the OE' pin and
> therefore the corresponding registers are not supported.
> The driver was tested on a HW where this pin is tied to GND.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
> Changes since v2:
> 	- s/pwm-pca9685-led/pwm-pca9685/g
> 	- replace DT properties with booleans
> 	- whitespace/blank line cleanup
> 	- add "depends on REGMAP_I2C" in Kconfig
> 	- rework code readability
> 	- add pwm_ops.free function
> 	- set SLEEP bit on request/free/remove
> 
> Changes since v1:
> 	- fix typo in documentation example
> 
>  .../devicetree/bindings/pwm/nxp,pca9685-pwm.txt    |  27 ++
>  drivers/pwm/Kconfig                                |   9 +
>  drivers/pwm/Makefile                               |   1 +
>  drivers/pwm/pwm-pca9685.c                          | 291 +++++++++++++++++++++
>  4 files changed, 328 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/nxp,pca9685-pwm.txt
>  create mode 100644 drivers/pwm/pwm-pca9685.c
> 

Ping ?!

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
