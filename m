Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaGIH0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:26:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaGIH0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:26:05 -0400
Date: Wed, 9 Jul 2014 09:25:53 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: balbi@ti.com, linux@arm.linux.org.uk, tony@atomide.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Removes FIXME message in usb.c
Message-ID: <20140709072553.GJ7827@pengutronix.de>
References: <1404871119-4324-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404871119-4324-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:58:39PM -0400, Nicholas Krause wrote:
> This patch removes a fixme message in this file:wq for setting the usb 2
:wq?

> speed on the board to the correct level. We need to depend on the
> bootloader for doing this as the wires may be shared for the other
> things on the board with the usb chipset.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/arm/mach-omap1/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap1/usb.c b/arch/arm/mach-omap1/usb.c
> index 4118db5..172245a 100644
> --- a/arch/arm/mach-omap1/usb.c
> +++ b/arch/arm/mach-omap1/usb.c
> @@ -505,7 +505,7 @@ static u32 __init omap1_usb2_init(unsigned nwires, unsigned alt_pingroup)
>  		omap_cfg_reg(W5_USB2_SE0);
>  		if (nwires != 3)
>  			omap_cfg_reg(Y5_USB2_RCV);
> -		// FIXME omap_cfg_reg(USB2_SPEED);
> +		/* Depend on boatloader for USB speed to be stated for board */
bootloader?

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
