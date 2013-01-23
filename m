Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3AWXga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:36:30 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40588 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3AWXgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:36:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Roger Quadros <rogerq@ti.com>, <sameo@linux.intel.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1358937492-8129-21-git-send-email-rogerq@ti.com>
Cc: linux@arm.linux.org.uk, sshtylyov@mvista.com, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, kishon@ti.com,
        linux-arm-kernel@lists.infradead.org, bjorn@mork.no, rogerq@ti.com
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
 <1358937492-8129-21-git-send-email-rogerq@ti.com>
Message-ID: <20130123233617.9205.88295@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v9 20/20] mdf: omap-usb-host: get rid of build warning
Date: Wed, 23 Jan 2013 15:36:17 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Roger Quadros (2013-01-23 02:38:12)
> Fixes the below build warning when driver is built-in.
> 
> drivers/mfd/omap-usb-host.c:750:12: warning:
> ‘usbhs_omap_remove’ defined but not used [-Wunused-function]
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Hi Roger,

I just noticed that $SUBJECT says "mdf" instead of "mfd" ;)

Regards,
Mike

> ---
>  drivers/mfd/omap-usb-host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index b21ca76..6b5edf6 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -791,7 +791,7 @@ static struct platform_driver usbhs_omap_driver = {
>                 .owner          = THIS_MODULE,
>                 .pm             = &usbhsomap_dev_pm_ops,
>         },
> -       .remove         = __exit_p(usbhs_omap_remove),
> +       .remove         = usbhs_omap_remove,
>  };
>  
>  MODULE_AUTHOR("Keshava Munegowda <keshava_mgowda@ti.com>");
> -- 
> 1.7.4.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
