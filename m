Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaDPJHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:07:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45837 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaDPJHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:07:41 -0400
Message-ID: <534E4873.5070308@linaro.org>
Date: Wed, 16 Apr 2014 11:08:03 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, tglx@linutronix.de,
        shawn.guo@linaro.org, b35083@freescale.com, r64188@freescale.com,
        b40534@freescale.com
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer Module
 timer node.
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com> <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 04:19 AM, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Jingchang Lu <b35083@freescale.com>

That deserves a patch description and an update of the documentation.

Thanks
   -- Daniel

> ---
>   arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 107e2c0..c3a276f 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -153,6 +153,19 @@
>   				clock-names = "pit";
>   			};
>
> +			ftm0: ftm@40038000 {
> +				compatible = "fsl,vf610-ftm-timer";
> +				reg = <0x40038000 0x2000>;
> +				interrupts = <0 42 IRQ_TYPE_LEVEL_HIGH>;
> +				clock-names = "ftm0", "ftm1",
> +					"ftm0_counter_en", "ftm1_counter_en";
> +				clocks = <&clks VF610_CLK_FTM0>,
> +					<&clks VF610_CLK_FTM1>,
> +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>,
> +					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
> +				status = "disabled";
> +			};
> +
>   			wdog@4003e000 {
>   				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
>   				reg = <0x4003e000 0x1000>;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

