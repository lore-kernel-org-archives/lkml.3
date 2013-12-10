Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3LJHnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:43:52 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:33931 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3LJHns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:43:48 -0500
MIME-Version: 1.0
In-Reply-To: <1386284438-11099-3-git-send-email-tim.kryger@linaro.org>
References: <1386284438-11099-1-git-send-email-tim.kryger@linaro.org>
	<1386284438-11099-3-git-send-email-tim.kryger@linaro.org>
Date: Mon, 9 Dec 2013 23:43:46 -0800
Message-ID: <CAEPRUYrOvFWFbGjCBNHPPtN1y6hDHgoj4ocHst-9iapF3bocRg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: bcm_defconfig: Unset CONFIG_CRYPTO_ANSI_CPRNG
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
> Do not build the Pseudo Random Number Generation for Cryptographic
> modules since it is not currently being used for this platform.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  arch/arm/configs/bcm_defconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> index 574e046..ef03bba 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -119,6 +119,7 @@ CONFIG_DETECT_HUNG_TASK=y
>  CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=110
>  CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
>  # CONFIG_FTRACE is not set
> +# CONFIG_CRYPTO_ANSI_CPRNG is not set
>  CONFIG_CRC_CCITT=y
>  CONFIG_CRC_T10DIF=y
>  CONFIG_CRC_ITU_T=y
> --
> 1.8.0.1
>
Applied to armsoc/for-3.14/soc

 thanks
  csd
