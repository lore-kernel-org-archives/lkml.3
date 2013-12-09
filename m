Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab3LIQR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:17:28 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43651 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838Ab3LIQRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <1386284438-11099-2-git-send-email-tim.kryger@linaro.org>
References: <1386284438-11099-1-git-send-email-tim.kryger@linaro.org>
	<1386284438-11099-2-git-send-email-tim.kryger@linaro.org>
Date: Mon, 9 Dec 2013 08:17:21 -0800
Message-ID: <CAEPRUYr3u6z+6CKf+u+hEMo+D4Nz=P43zKJGBJy=ZDVyNBBt4A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: bcm_defconfig: CONFIG_OABI_COMPAT default off
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        ARM Linux List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 3:00 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> Now that CONFIG_OABI_COMPAT is off by default, remove the explicit
> disabling of this feature.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  arch/arm/configs/bcm_defconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> index 287ac1d..574e046 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -29,7 +29,6 @@ CONFIG_ARCH_BCM_MOBILE=y
>  CONFIG_ARM_THUMBEE=y
>  CONFIG_PREEMPT=y
>  CONFIG_AEABI=y
> -# CONFIG_OABI_COMPAT is not set
>  # CONFIG_COMPACTION is not set
>  CONFIG_ZBOOT_ROM_TEXT=0x0
>  CONFIG_ZBOOT_ROM_BSS=0x0
> --
> 1.8.0.1
>
Applied to armsoc/for-3.14/soc

 thanks,
   csd
