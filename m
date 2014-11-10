Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaKJKsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:48:18 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:56935 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaKJKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:48:16 -0500
Date: Mon, 10 Nov 2014 10:48:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 04/13] ARM: multi_v7_defconfig: Enable st ohci and ehci
 HCD drivers.
Message-ID: <20141110104810.GS21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-5-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-5-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> Enable the ehci and ohci drivers in the multi_v7_defconfig so that
> the USB controllers on stih41x work by default.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/configs/multi_v7_defconfig | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index 491b7d5..c7a9517 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -318,9 +318,11 @@ CONFIG_USB_XHCI_HCD=y
>  CONFIG_USB_XHCI_MVEBU=y
>  CONFIG_USB_EHCI_HCD=y
>  CONFIG_USB_EHCI_TEGRA=y
> +CONFIG_USB_EHCI_HCD_STI=y
>  CONFIG_USB_EHCI_HCD_PLATFORM=y
>  CONFIG_USB_ISP1760_HCD=y
>  CONFIG_USB_OHCI_HCD=y
> +CONFIG_USB_OHCI_HCD_STI=y
>  CONFIG_USB_OHCI_HCD_PLATFORM=y
>  CONFIG_USB_STORAGE=y
>  CONFIG_USB_CHIPIDEA=y

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
