Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab3FAP2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 11:28:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53169 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3FAP2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 11:28:36 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 1 Jun 2013 08:29:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 1/2] watchdog: xilinx: Fix driver header
Message-ID: <20130601152909.GB7751@roeck-us.net>
References: <cover.1369979787.git.michal.simek@xilinx.com>
 <b565740967bfa3b3fa867442634f524000c097f8.1369979787.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b565740967bfa3b3fa867442634f524000c097f8.1369979787.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 07:56:33AM +0200, Michal Simek wrote:
> - Remove reference for IP version
> - Fix header coding style
> - Remove notes which are visible from the code
> - Fix driver license according to header
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> Changes in v2: None
> 
>  drivers/watchdog/of_xilinx_wdt.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
> index 2761ddb..d4a35ab 100644
> --- a/drivers/watchdog/of_xilinx_wdt.c
> +++ b/drivers/watchdog/of_xilinx_wdt.c
> @@ -1,23 +1,13 @@
>  /*
> -*   of_xilinx_wdt.c  1.01  A Watchdog Device Driver for Xilinx xps_timebase_wdt
> -*
> -*   (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
> -*
> -*       -----------------------
> -*
> -*   This program is free software; you can redistribute it and/or
> -*   modify it under the terms of the GNU General Public License
> -*   as published by the Free Software Foundation; either version
> -*   2 of the License, or (at your option) any later version.
> -*
> -*       -----------------------
> -*	30-May-2011 Alejandro Cabrera <aldaya@gmail.com>
> -*		- If "xlnx,wdt-enable-once" wasn't found on device tree the
> -*		  module will use CONFIG_WATCHDOG_NOWAYOUT
> -*		- If the device tree parameters ("clock-frequency" and
> -*		  "xlnx,wdt-interval") wasn't found the driver won't
> -*		  know the wdt reset interval
> -*/
> + * Watchdog Device Driver for Xilinx axi/xps_timebase_wdt
> + *
> + * (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> 
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> @@ -413,5 +403,5 @@ module_platform_driver(xwdt_driver);
> 
>  MODULE_AUTHOR("Alejandro Cabrera <aldaya@gmail.com>");
>  MODULE_DESCRIPTION("Xilinx Watchdog driver");
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> --
> 1.8.2.3
> 


