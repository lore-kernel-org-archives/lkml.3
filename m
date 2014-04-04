Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaDDKUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:20:41 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46610 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaDDKUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:20:37 -0400
Message-ID: <533E8793.8060409@linaro.org>
Date: Fri, 04 Apr 2014 05:21:07 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: mporter@linaro.org, bcm@fixthebug.org, devicetree@vger.kernel.org,
        arnd@arndb.de, sboyd@codeaurora.org
CC: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ARM: configs: enable SMP in bcm_defconfig
References: <1396577891-2713-1-git-send-email-elder@linaro.org> <1396577891-2713-4-git-send-email-elder@linaro.org>
In-Reply-To: <1396577891-2713-4-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 09:18 PM, Alex Elder wrote:
> Also explicitly set CONFIG_NR_CPUS to 2, limiting it to the most we
> currently need.
> 
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  arch/arm/configs/bcm_defconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
> index 0100464..ea374a7 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -24,6 +24,8 @@ CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
>  # CONFIG_BLK_DEV_BSG is not set
>  CONFIG_PARTITION_ADVANCED=y
> +CONFIG_SMP=y
> +CONFIG_NR_CPUS=2

Since this will be part of a MULTIPLATFORM build, I don't
want to set CONFIG_NR_CPUS.  I will delete this line.

					-Alex

>  CONFIG_ARCH_BCM=y
>  CONFIG_ARCH_BCM_MOBILE=y
>  CONFIG_ARM_THUMBEE=y
> 

