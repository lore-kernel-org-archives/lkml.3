Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaKJKrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:47:20 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36381 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaKJKrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:47:18 -0500
Date: Mon, 10 Nov 2014 10:47:12 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 05/13] ARM: multi_v7_defconfig: Enable stih415/6 usb2 phy
 driver.
Message-ID: <20141110104712.GR21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-6-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-6-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> This driver is used by the ehci / ohci usb controllers on stih415/6 SoCs.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index c7a9517..e13ab7e 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -426,6 +426,7 @@ CONFIG_PWM_VT8500=y
>  CONFIG_OMAP_USB2=y
>  CONFIG_TI_PIPE3=y
>  CONFIG_PHY_MIPHY365X=y
> +CONFIG_PHY_STIH41X_USB=y
>  CONFIG_PHY_SUN4I_USB=y
>  CONFIG_EXT4_FS=y
>  CONFIG_VFAT_FS=y

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
