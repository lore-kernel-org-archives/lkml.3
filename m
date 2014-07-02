Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaGBIyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:54:11 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:58275 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaGBIyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:54:08 -0400
Date: Wed, 2 Jul 2014 09:54:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: sti: Add STiH407 Kconfig entry to select
 STIH407_RESET
Message-ID: <20140702085403.GG10311@lee--X1>
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
 <1404225047-9495-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404225047-9495-3-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2014, Peter Griffin wrote:

> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/mach-sti/Kconfig | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Looks okay, although could probably do with a few words in the commit
message about what the STiH407 is; yada, yada, yada ...

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
> index 878e9ec..8825bc9 100644
> --- a/arch/arm/mach-sti/Kconfig
> +++ b/arch/arm/mach-sti/Kconfig
> @@ -42,4 +42,14 @@ config SOC_STIH416
>  	  and other digital audio/video applications using Flattened Device
>  	  Trees.
>  
> +config SOC_STIH407
> +	bool "STiH407 STMicroelectronics Consumer Electronics family"
> +	default y
> +	select STIH407_RESET
> +	help
> +	  This enables support for STMicroelectronics Digital Consumer
> +	  Electronics family StiH407 parts, targetted at set-top-box
> +	  and other digital audio/video applications using Flattened Device
> +	  Trees.
> +
>  endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
