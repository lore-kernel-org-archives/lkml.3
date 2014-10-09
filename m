Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaJIOo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:44:59 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:62577 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaJIOou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:44:50 -0400
MIME-Version: 1.0
In-Reply-To: <1412843614-4537-1-git-send-email-gdjakov@mm-sol.com>
References: <1412843614-4537-1-git-send-email-gdjakov@mm-sol.com>
Date: Thu, 9 Oct 2014 07:44:49 -0700
Message-ID: <CAJAp7Ohi89GSZiHQCxqrHSJw++VtBucUccTyStiUF_MWUJy-YQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: qcom: Increase MMC_BLOCK_MINORS in defconfig
From: Bjorn Andersson <bjorn@kryo.se>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 1:33 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> There are currently more than 16 partitions on the eMMC of all recent
> Qualcomm devices. Increase the number of minors per block device to
> detect all available partitions.
>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Good stuff.

Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn

> ---
>  arch/arm/configs/qcom_defconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
> index 8c7da33..cd09e12 100644
> --- a/arch/arm/configs/qcom_defconfig
> +++ b/arch/arm/configs/qcom_defconfig
> @@ -125,7 +125,7 @@ CONFIG_USB_GADGET=y
>  CONFIG_USB_GADGET_DEBUG_FILES=y
>  CONFIG_USB_GADGET_VBUS_DRAW=500
>  CONFIG_MMC=y
> -CONFIG_MMC_BLOCK_MINORS=16
> +CONFIG_MMC_BLOCK_MINORS=32
>  CONFIG_MMC_ARMMMCI=y
>  CONFIG_MMC_SDHCI=y
>  CONFIG_MMC_SDHCI_PLTFM=y
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
