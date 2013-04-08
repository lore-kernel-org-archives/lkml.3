Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204Ab3DHVqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:46:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29417 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965011Ab3DHVqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:46:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18eCLwLyDAwaYOs9n3NsjRf
Date: Mon, 8 Apr 2013 14:46:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: omap2plus_defconfig: Add support for
 BMP085 pressure sensor
Message-ID: <20130408214613.GX10155@atomide.com>
References: <1361193652-25313-1-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361193652-25313-1-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ruslan Bilovol <ruslan.bilovol@ti.com> [130218 05:24]:
> This patch enables BMP085 pressure sensor that can be
> found on OMAP4 Blaze Tablet development platform
> 
> Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>

Thanks adding to omap-for-v3.10/board.

Regards,

Tony

> ---
>  arch/arm/configs/omap2plus_defconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> index b16bae2..6a4e9a2 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -93,6 +93,7 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
>  CONFIG_SENSORS_LIS3LV02D=m
>  CONFIG_SENSORS_TSL2550=m
>  CONFIG_SENSORS_LIS3_I2C=m
> +CONFIG_BMP085_I2C=m
>  CONFIG_SCSI=y
>  CONFIG_BLK_DEV_SD=y
>  CONFIG_SCSI_MULTI_LUN=y
> -- 
> 1.7.9.5
> 
