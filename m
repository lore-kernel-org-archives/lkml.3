Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab3KHKxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:53:30 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:54126 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3KHKx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:53:28 -0500
Message-ID: <527CC2A5.7080000@linaro.org>
Date: Fri, 08 Nov 2013 11:53:25 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        patches@linaro.org
Subject: Re: [RESEND PATCH v2 1/6] ARM: dts: Declare clocks as fixed on bcm11351
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org> <1381960030-1640-2-git-send-email-tim.kryger@linaro.org>
In-Reply-To: <1381960030-1640-2-git-send-email-tim.kryger@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 11:47 PM, Tim Kryger wrote:
> Declare clocks that are enabled and configured by bootloaders as fixed
> rate clocks in the DTS such that device drivers may use standard clock
> function calls.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---

Hi Tim,

I was wondering what is the status of this patchset ?

The patchset touches different areas maintained by different people. 
Through what tree do you expect this patchset to be merged ??

Thanks
   -- Daniel

>   arch/arm/boot/dts/bcm11351.dtsi | 97 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 97 insertions(+)
>
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index 98e6bc0..c6464fb 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -126,4 +126,101 @@
>   		status = "disabled";
>   	};
>
> +	clocks {
> +		bsc1_clk: bsc1 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		bsc2_clk: bsc2 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		bsc3_clk: bsc3 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		pmu_bsc_clk: pmu_bsc {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		hub_timer_clk: hub_timer {
> +			compatible = "fixed-clock";
> +			clock-frequency = <32768>;
> +			#clock-cells = <0>;
> +		};
> +
> +		pwm_clk: pwm {
> +			compatible = "fixed-clock";
> +			clock-frequency = <26000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		sdio1_clk: sdio1 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <48000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		sdio2_clk: sdio2 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <48000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		sdio3_clk: sdio3 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <48000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		sdio4_clk: sdio4 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <48000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		tmon_1m_clk: tmon_1m {
> +			compatible = "fixed-clock";
> +			clock-frequency = <1000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		uartb_clk: uartb {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		uartb2_clk: uartb2 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		uartb3_clk: uartb3 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		uartb4_clk: uartb4 {
> +			compatible = "fixed-clock";
> +			clock-frequency = <13000000>;
> +			#clock-cells = <0>;
> +		};
> +
> +		usb_otg_ahb_clk: usb_otg_ahb {
> +			compatible = "fixed-clock";
> +			clock-frequency = <52000000>;
> +			#clock-cells = <0>;
> +		};
> +	};
>   };
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

