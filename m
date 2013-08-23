Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3HWT6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:58:16 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33857 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3HWT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:58:14 -0400
Date: Fri, 23 Aug 2013 12:58:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wei Hu <wei@aristanetworks.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (k10temp) Add support for Fam16h
 (Kabini)
Message-ID: <20130823195810.GA12208@roeck-us.net>
References: <1377279498-2868-1-git-send-email-wei@aristanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377279498-2868-1-git-send-email-wei@aristanetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 10:38:18AM -0700, Wei Hu wrote:
> The temperature reporting interface stays the same, so we just
> add the PCI-ID to the list.
> 
> Verified on AMD Olive Hill.

The Signed-off-by: statement is missing. I can not apply the patch without it.

Guenter

> ---
>  Documentation/hwmon/k10temp |    1 +
>  drivers/hwmon/Kconfig       |    4 ++--
>  drivers/hwmon/k10temp.c     |    3 ++-
>  3 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/hwmon/k10temp b/Documentation/hwmon/k10temp
> index 90956b6..4dfdc8f 100644
> --- a/Documentation/hwmon/k10temp
> +++ b/Documentation/hwmon/k10temp
> @@ -12,6 +12,7 @@ Supported chips:
>  * AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
>  * AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
>  * AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity"
> +* AMD Family 16h processors: "Kabini"
>  
>    Prefix: 'k10temp'
>    Addresses scanned: PCI space
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index e989f7f..1e27838 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -296,8 +296,8 @@ config SENSORS_K10TEMP
>  	  If you say yes here you get support for the temperature
>  	  sensor(s) inside your CPU. Supported are later revisions of
>  	  the AMD Family 10h and all revisions of the AMD Family 11h,
> -	  12h (Llano), 14h (Brazos) and 15h (Bulldozer/Trinity)
> -	  microarchitectures.
> +	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity) and
> +	  16h (Kabini) microarchitectures.
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called k10temp.
> diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
> index e3b037c..e633856 100644
> --- a/drivers/hwmon/k10temp.c
> +++ b/drivers/hwmon/k10temp.c
> @@ -1,5 +1,5 @@
>  /*
> - * k10temp.c - AMD Family 10h/11h/12h/14h/15h processor hardware monitoring
> + * k10temp.c - AMD Family 10h/11h/12h/14h/15h/16h processor hardware monitoring
>   *
>   * Copyright (c) 2009 Clemens Ladisch <clemens@ladisch.de>
>   *
> @@ -211,6 +211,7 @@ static DEFINE_PCI_DEVICE_TABLE(k10temp_id_table) = {
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
>  	{}
>  };
>  MODULE_DEVICE_TABLE(pci, k10temp_id_table);
> -- 
> 1.7.4.4
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 
