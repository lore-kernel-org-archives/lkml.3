Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbbAWGZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:25:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12307 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbAWGZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:25:09 -0500
X-AuditID: cbfee68e-f79b46d000002b74-3f-54c1e9433d2a
Message-id: <54C1E943.2020800@samsung.com>
Date: Fri, 23 Jan 2015 15:25:07 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Subject: Re: [PATCH 6/6] Documentation: Add device tree bindings document for
 max77843
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-7-git-send-email-jaewon02.kim@samsung.com>
In-reply-to: <1421989367-32721-7-git-send-email-jaewon02.kim@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkRNf55cEQg8WPjC1Of9rGbjH14RM2
	i/lHzrFa9L9ZyGpx7tVKRotJ9yewWOxoOMJqcf/rUUaLy7vmsFl87j3CaLH0+kUmiwnT17JY
	tO49wm5xeneJA5/HmnlrGD0u9/Uyeaxc/oXNY9OqTjaPO9f2sHn0bVnF6PF5k1wAexSXTUpq
	TmZZapG+XQJXxsx595kKrilVTJn/hq2B8bx0FyMnh4SAicTSOesZIWwxiQv31rOB2EICSxkl
	2mdrwtRMnP6ICSI+nVHieJNiFyMXkP2aUeLGil9gDbwCWhLHfz1nB7FZBFQl/rYtBmtgA4rv
	f3EDrEZUIExi5fQrLBD1ghI/Jt8Ds0UENCWOHDnCCDKUWeAUs8TJxT1AzRwcwgIREicesEMs
	a2eUuDrtNjNIA6eAp8TzK1vBmpkFdCT2t05jg7DlJTavecsMcXUvh8SmH24QBwlIfJt8iAVk
	poSArMSmA1AlkhIHV9xgmcAoNgvJSbOQTJ2FZOoCRuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ
	+bmbGIHRfPrfs74djDcPWB9iFOBgVOLhbdxyMESINbGsuDL3EKMp0BUTmaVEk/OBKSOvJN7Q
	2MzIwtTE1NjI3NJMSZw3QepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG74fLl9Reyau8
	wWz8TvnNgQ0FQT47P/yoff9q/1Sjibuk7e4fFbQs5s8r1FR9afIi9mbTZm1JTburdpceBTcV
	zHrj82slX3Y3+1yN+Bz3xg0TWDWT1mhzHmBLk264v/9hq1pce67zU3fJvZkZzZfmxppPF4nU
	MtPeJ26RGiK7dFJh9LuHzsuUWIozEg21mIuKEwGl+mVk4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQV3nlwdDDN7d0rI4/Wkbu8XUh0/Y
	LOYfOcdq0f9mIavFuVcrGS0m3Z/AYrGj4Qirxf2vRxktLu+aw2bxufcIo8XS6xeZLCZMX8ti
	0br3CLvF6d0lDnwea+atYfS43NfL5LFy+Rc2j02rOtk87lzbw+bRt2UVo8fnTXIB7FENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDcrKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDNmzrvPVHBNqWLK/DdsDYznpbsYOTkk
	BEwkJk5/xARhi0lcuLeeDcQWEpjOKHG8SbGLkQvIfs0ocWPFL7AEr4CWxPFfz9lBbBYBVYm/
	bYvBmtmA4vtf3ACrERUIk1g5/QoLRL2gxI/J98BsEQFNiSNHjjCCDGUWOMUscXJxD1AzB4ew
	QITEiQfsEMvaGSWuTrvNDNLAKeAp8fzKVrBmZgEdif2t09ggbHmJzWveMk9gFJiFZMcsJGWz
	kJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcLp5J7WBc2WBxiFGAg1GJh7dhy8EQ
	IdbEsuLK3EOMEhzMSiK83Y+AQrwpiZVVqUX58UWlOanFhxhNgUEwkVlKNDkfmMrySuINjU3M
	jCyNzA0tjIzNlcR5lezbQoQE0hNLUrNTUwtSi2D6mDg4pRoYzfMlanncpn6L43BVcwg/035h
	g3eOAU+/3obDK7s275BKkWf95NngvMUl+YtLxWXPHdWlz6Jiu8S+Zb7jOT3x5v9fLxOe5y62
	dXx19WaGxAXv06+/77U6eist0Fz5zhal63/2OEfM+MAwzd+s9p6JTuNR6buf9rxnr6raLvso
	stqCcdWmFKnZSizFGYmGWsxFxYkAOt+bLS0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaewon,

On 01/23/2015 02:02 PM, Jaewon Kim wrote:
> Add document describing device tree bindings for max77843 MFD.
> Drivers: MFD core, regulator, extcon, charger and fuelgauge.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max77843.txt |   87 ++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max77843.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/max77843.txt b/Documentation/devicetree/bindings/mfd/max77843.txt
> new file mode 100644
> index 0000000..6895604
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/max77843.txt
> @@ -0,0 +1,87 @@
> +Maxim MAX77843 multi-function device
> +
> +MAX77843 is a Multi-Function Device with the following submodules:
> +- PMIC	  : 2 SAFEOUT LDOs for USB device
> +- CHARGER : Li+ battery charger with Fuel Gauge
> +- MUIC	  : Micro USB Interface Circuit
> +- HAPTIC  : motor control driver for haptics

HAPTIC ?

> +- LED	  : 4 channel RGBW LED

LED ?

This patchset don't include andy haptic/led drivers.
I think it is un-necessary information.

When you implement the haptic/led driver, you will add the information
for haptic/led driver.

> +
> +It is interfaced to host controller using I2C.
> +
> +Required properties:
> +- compatible : Must be "maxim,max77843".
> +- reg : I2C slave address of PMIC block.
> +- interrupts : I2C line for main SoCs.
> +- interrupt-parent : The parent of interrupt controller.
> +
> +Optional properties:
> +- regulators : The regulators of max77843 have to be instantiated under subnode
> +	named "regulators" using the following format.
> +
> +	[*]refer : Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +	regulators {
> +		SAFEOUT {
> +			regulator-name = "SAFEOUT";
> +		};
> +	}
> +
> +	List of valid regulator names:
> +	- SAFEOUT1, SAFEOUT2, CHARGER.
> +
> +- max77843-muic : This properties used by extcon consumers.
> +	Required properties:
> +		- compatible : Must be "maxim,max77842-muic".
> +
> +- max77843-charger : There battery charger of MAX77843 have to be instantiated
> +	under sub-node named "max77843-charger" using the following format.
> +	Required properties:
> +		- compatible : Must be "maxim,max77842-charger".
> +		- maxim,fast-charge-uamp : Fast charge current levels are
> +			100 mA to 3150 mA programmed by I2C per 100 mA.
> +		- maxim,top-off-uamp : Top off current threshold levels are
> +			125 mA to 650 mA programmed by I2C per 75 mA.
> +		- maxim,input-uamp-limit : Input current limit levels are
> +			100 mA to 3533 mA programmed by I2C per 33 mA.
> +- max77843-fuelgauge : There fuelgauge of MAX77843 have to be instantiated
> +	under sub-node named "max77843-fuelgauge" using the following format.
> +	Required properties:
> +		- compatible : Must be "maxim,max77842-fuelgauge".
> +
> +Example:
> +	max77843@66 {
> +		compatible = "samsung,max77843";
> +		reg = <0x66>;
> +		interrupt-parent = <&gpa1>;
> +		interrupts = <5 2>;
> +
> +		regulators {
> +			SAFEOUT1 {
> +				regulator-name = "SAFEOUT1";
> +				regulator-min-microvolt = <3300000>;
> +				regulator-max-microvolt = <4950000>;
> +			};
> +			SAFEOUT2 {
> +				regulator-name = "SAFEOUT2";
> +				regulator-min-microvolt = <3300000>;
> +				regulator-max-microvolt = <4950000>;
> +			};

As I knew, max77843 regulator driver supprot 'CHARGER' regulator.
I think you have to add the 'CHARGER' dt node for regulators.


> +		};
> +
> +		max77843-muic {
> +			compatible = "maxim,max77843-muic";
> +		};
> +
> +		max77843-charger {
> +			compatible = "maxim,max77843-charger";
> +			maxim,fast-charge-uamp = <450000>;
> +			maxim,top-off-uamp = <125000>;
> +			maxim,input-uamp-limit = <500000>;
> +		};
> +
> +		max77843-fuelgauge {
> +			compatible = "maxim,max77843-fuelgauge";
> +		};
> +
> +	};
> 

Thanks,
Chanwoo Choi
