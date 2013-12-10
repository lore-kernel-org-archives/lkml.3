Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3LJHjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:39:44 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46620 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3LJHjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:39:41 -0500
MIME-Version: 1.0
In-Reply-To: <1386286255-4338-1-git-send-email-tim.kryger@linaro.org>
References: <1386286255-4338-1-git-send-email-tim.kryger@linaro.org>
Date: Mon, 9 Dec 2013 23:39:17 -0800
Message-ID: <CAEPRUYpQdS5yGEoYS0Yp16TL9Kj3hZr3tb16ZHzkWG+bW0Q4PA@mail.gmail.com>
Subject: Re: [RESEND PATCH] ARM: bcm_defconfig: Do not expect appended DTB
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 3:30 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> The bootloaders used with Broadcom mobile SoCs are capable of handling
> a device tree separately from the zImage so there is no need for this
> option to be enabled.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  arch/arm/configs/bcm_defconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> index 6e49310..b152367 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -35,7 +35,6 @@ CONFIG_AEABI=y
>  # CONFIG_COMPACTION is not set
>  CONFIG_ZBOOT_ROM_TEXT=0x0
>  CONFIG_ZBOOT_ROM_BSS=0x0
> -CONFIG_ARM_APPENDED_DTB=y
>  CONFIG_CMDLINE="console=ttyS0,115200n8 mem=128M"
>  CONFIG_CPU_IDLE=y
>  CONFIG_VFP=y
> --
> 1.8.0.1
>
Applied to armsoc/for-3.14/soc

 thanks,
  csd
