Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461AbaDJR4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:56:31 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:45021 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaDJR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:56:28 -0400
Date: Thu, 10 Apr 2014 13:56:23 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Mark Brown <broonie@kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Olof Johansson <olof@lixom.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/3] Update bcm_defconfig with new pinctrl CONFIG
Message-ID: <20140410175623.GC23695@beef>
References: <1390509887-19278-1-git-send-email-syin@broadcom.com>
 <1396478439-16586-1-git-send-email-syin@broadcom.com>
 <1396478439-16586-3-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396478439-16586-3-git-send-email-syin@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 03:40:38PM -0700, Sherman Yin wrote:
> To be consistent with other Broadcom drivers, the Broadcom Capri pinctrl
> driver and its related CONFIG option are renamed to bcm281xx.
> 
> This commit updates the defconfig that enables the pinctrl driver.
> 
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Matt Porter <mporter@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Matt Porter <mporter@linaro.org>

> ---
>  arch/arm/configs/bcm_defconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> index 2519d6d..b4d3013 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -125,7 +125,7 @@ CONFIG_CRC_ITU_T=y
>  CONFIG_CRC7=y
>  CONFIG_XZ_DEC=y
>  CONFIG_AVERAGE=y
> -CONFIG_PINCTRL_CAPRI=y
> +CONFIG_PINCTRL_BCM281XX=y
>  CONFIG_WATCHDOG=y
>  CONFIG_BCM_KONA_WDT=y
>  CONFIG_BCM_KONA_WDT_DEBUG=y
> -- 
> 1.7.9.5
> 
