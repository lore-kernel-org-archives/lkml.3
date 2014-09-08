Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaIHJlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:41:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36169 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaIHJlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:41:42 -0400
Message-ID: <540D79B9.6090408@ti.com>
Date: Mon, 8 Sep 2014 15:11:13 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>
CC: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] ARM: multi_v7_defconfig: Enable stih41x usb phy
 driver.
References: <1410168638-11072-1-git-send-email-peter.griffin@linaro.org> <1410168638-11072-5-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1410168638-11072-5-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 08 September 2014 03:00 PM, Peter Griffin wrote:
> This driver is used by the ehci / ohci usb controllers on stih41x SoCs.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

FWIW
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index 5fb95fb..74fd4a1 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -387,6 +387,7 @@ CONFIG_PWM_VT8500=y
>  CONFIG_OMAP_USB2=y
>  CONFIG_TI_PIPE3=y
>  CONFIG_PHY_MIPHY365X=y
> +CONFIG_PHY_STIH41X_USB=y
>  CONFIG_PHY_SUN4I_USB=y
>  CONFIG_EXT4_FS=y
>  CONFIG_VFAT_FS=y
> 
