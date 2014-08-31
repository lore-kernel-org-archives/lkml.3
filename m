Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaHaSWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:22:21 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:54610 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaHaSWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:22:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] pinctrl: sh-pfc: use a saner Kconfig symbol
Date: Sun, 31 Aug 2014 20:22:53 +0300
Message-ID: <4845771.kPKGOTpt3B@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1409316719-28904-1-git-send-email-linus.walleij@linaro.org>
References: <1409316719-28904-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Thank you for the patch.

On Friday 29 August 2014 14:51:59 Linus Walleij wrote:
> There is currently a kludge to get the Makefile to move down
> to sh-pfc:s drivers: the arch definitions are used twice to
> get it done. However we can very well use the Kconfig symbol
> for the SH PFC pin control feature itself: it doesn't matter
> that it comes from a lower leaf in the Kconfig hierarchy which
> is completely orthogonal.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pinctrl/Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> index 7ebb3c5a9c30..0ffe1f608c67 100644
> --- a/drivers/pinctrl/Makefile
> +++ b/drivers/pinctrl/Makefile
> @@ -60,8 +60,7 @@ obj-$(CONFIG_PLAT_ORION)        += mvebu/
>  obj-y				+= nomadik/
>  obj-$(CONFIG_ARCH_QCOM)		+= qcom/
>  obj-$(CONFIG_PINCTRL_SAMSUNG)	+= samsung/
> -obj-$(CONFIG_ARCH_SHMOBILE)	+= sh-pfc/
> -obj-$(CONFIG_SUPERH)		+= sh-pfc/
> +obj-$(CONFIG_PINCTRL_SH_PFC)	+= sh-pfc/
>  obj-$(CONFIG_PLAT_SPEAR)	+= spear/
>  obj-$(CONFIG_ARCH_SUNXI)	+= sunxi/
>  obj-$(CONFIG_ARCH_VT8500)	+= vt8500/

-- 
Regards,

Laurent Pinchart

