Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaBOLnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:43:11 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44472 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaBOLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:43:08 -0500
Message-ID: <52FF52EF.4050209@kernel.org>
Date: Sat, 15 Feb 2014 11:43:43 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 6/6] ARM: dts: AM33XX: Add ecap interrupt properties
References: <1391626901-31684-1-git-send-email-mporter@linaro.org> <1391626901-31684-7-git-send-email-mporter@linaro.org>
In-Reply-To: <1391626901-31684-7-git-send-email-mporter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 19:01, Matt Porter wrote:
> Add missing interrupt properties to the ecap0, ecap1, and ecap2
> nodes.
>
> Signed-off-by: Matt Porter <mporter@linaro.org>
This one is unconnected from the rest of the series really so should go
into the relevant arch tree whenever it make sense.

Jonathan
> ---
>   arch/arm/boot/dts/am33xx.dtsi | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 6d95d3d..b4139ba 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -582,6 +582,8 @@
>   				compatible = "ti,am33xx-ecap";
>   				#pwm-cells = <3>;
>   				reg = <0x48300100 0x80>;
> +				interrupts = <31>;
> +				interrupt-names = "ecap0";
>   				ti,hwmods = "ecap0";
>   				status = "disabled";
>   			};
> @@ -610,6 +612,8 @@
>   				compatible = "ti,am33xx-ecap";
>   				#pwm-cells = <3>;
>   				reg = <0x48302100 0x80>;
> +				interrupts = <47>;
> +				interrupt-names = "ecap1";
>   				ti,hwmods = "ecap1";
>   				status = "disabled";
>   			};
> @@ -638,6 +642,8 @@
>   				compatible = "ti,am33xx-ecap";
>   				#pwm-cells = <3>;
>   				reg = <0x48304100 0x80>;
> +				interrupts = <61>;
> +				interrupt-names = "ecap2";
>   				ti,hwmods = "ecap2";
>   				status = "disabled";
>   			};
>

