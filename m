Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3FDMoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:44:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3FDMn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:43:58 -0400
Date: Tue, 4 Jun 2013 14:43:51 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tty: serial: Enable uartlite for ARM zynq
Message-ID: <20130604124351.GC5107@pengutronix.de>
References: <26d21aaa1f4a5b3bcae1d82f1524ea53ce9a36bd.1370348438.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26d21aaa1f4a5b3bcae1d82f1524ea53ce9a36bd.1370348438.git.michal.simek@xilinx.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:39:27 up 86 days, 22:19, 23 users,  load average: 0.40, 0.63,
 0.66
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:20:43PM +0200, Michal Simek wrote:
> Enable it in Kconfig.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/tty/serial/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 7e7006f..64250b1 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -576,7 +576,7 @@ config SERIAL_IMX_CONSOLE
> 
>  config SERIAL_UARTLITE
>  	tristate "Xilinx uartlite serial port support"
> -	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE
> +	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE || ARCH_ZYNQ
>  	select SERIAL_CORE
>  	help
>  	  Say Y here if you want to use the Xilinx uartlite serial controller.
> --
> 1.8.2.3
> 

Hi!

Doesn't the Zynq use xilinx_uartps ? (which in turn is actually a Cadence UART)

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
