Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaG2JCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:02:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20658 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaG2JCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:02:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19UTgK8ds0Z7urisl9IAZW2
Date: Tue, 29 Jul 2014 02:01:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Enable TI PIPE3 PHY driver
Message-ID: <20140729090120.GJ29045@atomide.com>
References: <1406540737-9493-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406540737-9493-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140728 02:48]:
> This driver is needed by SATA, PCIe and USB modules on TI SoCs.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

You need to send this to arm@kernel.org to avoid conflicts.

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index 5348364..e411a37 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -368,6 +368,7 @@ CONFIG_PWM=y
>  CONFIG_PWM_TEGRA=y
>  CONFIG_PWM_VT8500=y
>  CONFIG_OMAP_USB2=y
> +CONFIG_TI_PIPE3=y
>  CONFIG_PHY_SUN4I_USB=y
>  CONFIG_EXT4_FS=y
>  CONFIG_VFAT_FS=y
> -- 
> 1.8.3.2
> 
