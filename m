Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3GPOWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:22:14 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:48375 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3GPOWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:22:09 -0400
Message-ID: <51E55710.8060907@cogentembedded.com>
Date: Tue, 16 Jul 2013 18:22:08 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
CC: tony@atomide.com, benoit.cousson@linaro.org, rnayak@ti.com,
        peter.ujfalusi@ti.com, kishon@ti.com, jic23@cam.ac.uk,
        grant.likely@linaro.org, rob.herring@calxeda.com, lars@metafoo.de,
        sameo@linux.intel.com, ch.naveen@samsung.com, poeschel@lemonage.de,
        milo.kim@ti.com, balajitk@ti.com, gg@slimlogic.co.uk,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] ARM: dts: twl: Add GPADC data to device tree
References: <1373974500-23609-1-git-send-email-oleksandr.kozaruk@ti.com>
In-Reply-To: <1373974500-23609-1-git-send-email-oleksandr.kozaruk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/16/2013 03:34 PM, Oleksandr Kozaruk wrote:

> GPADC is the general purpose ADC present on twl6030.
> The dt data is interrupt used to trigger end of ADC
> conversion.

> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
> ---
>   arch/arm/boot/dts/twl6030.dtsi | 6 ++++++
>   1 file changed, 6 insertions(+)

> diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
> index 2e3bd31..434842c 100644
> --- a/arch/arm/boot/dts/twl6030.dtsi
> +++ b/arch/arm/boot/dts/twl6030.dtsi
> @@ -103,4 +103,10 @@
>   		compatible = "ti,twl6030-pwmled";
>   		#pwm-cells = <2>;
>   	};
> +
> +	gpadc: twl6030_gpadc {
> +		compatible = "ti,twl6030_gpadc";
> +		interrupts = <3>;
> +		#io-channel-cells = <1>;
> +	};

    ePAPR [1] says: "The name of a node should be somewhat generic, 
reflecting the function of the device and not its precise programming 
model."

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

