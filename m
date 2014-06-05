Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaFENIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:08:18 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33182 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFENIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:08:16 -0400
Date: Thu, 5 Jun 2014 14:08:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        kernel@stlinux.com
Subject: Re: [PATCH v3 09/10] ARM: update multi_v7_defconfig for STI
Message-ID: <20140605130809.GB24240@lee--X1>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
 <1401899424-1365-10-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401899424-1365-10-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch enables SDHCI STI platform driver.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index d4e8a47..48951fc 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -277,6 +277,7 @@ CONFIG_MMC_SDHCI_TEGRA=y
>  CONFIG_MMC_SDHCI_DOVE=y
>  CONFIG_MMC_SDHCI_SPEAR=y
>  CONFIG_MMC_SDHCI_BCM_KONA=y
> +CONFIG_MMC_SDHCI_ST=y
>  CONFIG_MMC_OMAP=y
>  CONFIG_MMC_OMAP_HS=y
>  CONFIG_MMC_MVSDIO=y

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
