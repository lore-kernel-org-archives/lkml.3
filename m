Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbbAWHkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:40:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57912 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbAWHkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:40:39 -0500
X-AuditID: cbfee68e-f79b46d000002b74-6d-54c1faf4612a
Message-id: <54C1FAF3.9090701@samsung.com>
Date: Fri, 23 Jan 2015 16:40:35 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 6/6] Documentation: Add device tree bindings document for
 max77843
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
 <1421989367-32721-7-git-send-email-jaewon02.kim@samsung.com>
 <54C1E943.2020800@samsung.com>
In-reply-to: <54C1E943.2020800@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkQPfLr4MhBjdaRSymPnzCZnH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRotJ9yewWOxoOMJqcf/rUUaLy7vmsFl87j3CaLH0+kUmiwnT17JY
	tO49wm5xeneJA5/HmnlrGD0u9/Uyeaxc/oXNY9OqTjaPO9f2sHn0bVnF6PF5k1wAexSXTUpq
	TmZZapG+XQJXxqfLC1gL9qhVrLy4gqmB8Z5cFyMnh4SAicT+iftZIGwxiQv31rN1MXJxCAks
	ZZSYtqSHDaboyN/HrBCJRYwSO+dOY4FwXjNKbGs+xgRSxSugJXHgx15mEJtFQFWibfVVsG42
	AU2J91OugK0QFYiQmH/sNTNEvaDEj8n3wOIiAv4Sndvng8WZBRYzS+x6W9DFyMEhDFR/4gE7
	xK4VjBJvHs0Fq+EU0JZY0HScDaSGWUBP4v5FLYhWeYnNa94yg9RLCEzkkLi6up8N4h4BiW+T
	D7GA1EsIyEpsOsAM8ZikxMEVN1gmMIrNQnLRLISps5BMXcDIvIpRNLUguaA4Kb3ISK84Mbe4
	NC9dLzk/dxMjMJpP/3vWt4Px5gHrQ4wCHIxKPLyNWw6GCLEmlhVX5h5iNAU6YiKzlGhyPjBl
	5JXEGxqbGVmYmpgaG5lbmimJ8yZI/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOjWeHDZ
	Ti3HegWtMwmyeXJpZYxf5q1gnbPpWMq7N+xZOw8e8548gd3Ldq/SqaRXQmJy13MKG4zkBEM+
	XvEtZpKcftvIXU1XZ9uCl4lfNk+99vxD0jSxAlUV986itxMyfeWYypIia5z8r+T9vx4l1qJw
	2NBZ4Z/F0896yaG9/35+YCucaXYuQomlOCPRUIu5qDgRAGbwkHThAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd0vvw6GGCyfxGUx9eETNovrX56z
	Wsw/co7Vov/NQlaLc69WMlpMuj+BxWJHwxFWi/tfjzJaXN41h83ic+8RRoul1y8yWUyYvpbF
	onXvEXaL07tLHPg81sxbw+hxua+XyWPl8i9sHptWdbJ53Lm2h82jb8sqRo/Pm+QC2KMaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZ8uryAtWCPWsXKiyuYGhjvyXUxcnJI
	CJhIHPn7mBXCFpO4cG89WxcjF4eQwCJGiZ1zp7FAOK8ZJbY1H2MCqeIV0JI48GMvM4jNIqAq
	0bb6KhuIzSagKfF+yhUWEFtUIEJi/rHXzBD1ghI/Jt8Di4sI+Et0bp8PFmcWWMwssettQRcj
	B4cwUP2JB+wQu1YwSrx5NBeshlNAW2JB03E2kBpmAT2J+xe1IFrlJTavecs8gVFgFpINsxCq
	ZiGpWsDIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOFU8k9rBuLLB4hCjAAejEg9vw5aD
	IUKsiWXFlbmHGCU4mJVEeOO+AIV4UxIrq1KL8uOLSnNSiw8xmgL9P5FZSjQ5H5jG8kriDY1N
	zIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGEv0F12P5LPoe6u0cjVHeFsN
	i+Xtt1/9pM24Lj1sE62/Kcc059i0fXdM9B/vnq+lsNtydd0LxT+C7ZHmbNc8m7/cuvaw1GTj
	1KOi0dwnK9zf2vbrXGJSutJy5snRUIbj7mYpLyZezXz1NFNl7Q/7a+4WBU93JJ3g2JXLx8XO
	fptv6YTi6/9ClyqxFGckGmoxFxUnAgBcmKQKKwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 03:25 PM, Chanwoo Choi wrote:
> Hi Jaewon,
> 
> On 01/23/2015 02:02 PM, Jaewon Kim wrote:
>> Add document describing device tree bindings for max77843 MFD.
>> Drivers: MFD core, regulator, extcon, charger and fuelgauge.
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Sebastian Reichel <sre@kernel.org>
>> Cc: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> ---
>>  Documentation/devicetree/bindings/mfd/max77843.txt |   87 ++++++++++++++++++++
>>  1 file changed, 87 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/max77843.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/max77843.txt b/Documentation/devicetree/bindings/mfd/max77843.txt
>> new file mode 100644
>> index 0000000..6895604
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/max77843.txt
>> @@ -0,0 +1,87 @@
>> +Maxim MAX77843 multi-function device
>> +
>> +MAX77843 is a Multi-Function Device with the following submodules:
>> +- PMIC	  : 2 SAFEOUT LDOs for USB device
>> +- CHARGER : Li+ battery charger with Fuel Gauge
>> +- MUIC	  : Micro USB Interface Circuit
>> +- HAPTIC  : motor control driver for haptics
> 
> HAPTIC ?
> 
>> +- LED	  : 4 channel RGBW LED
> 
> LED ?
> 
> This patchset don't include andy haptic/led drivers.
> I think it is un-necessary information.
> 
> When you implement the haptic/led driver, you will add the information
> for haptic/led driver.
> 

OK. I will remove them.

>> +
>> +It is interfaced to host controller using I2C.
>> +
>> +Required properties:
>> +- compatible : Must be "maxim,max77843".
>> +- reg : I2C slave address of PMIC block.
>> +- interrupts : I2C line for main SoCs.
>> +- interrupt-parent : The parent of interrupt controller.
>> +
>> +Optional properties:
>> +- regulators : The regulators of max77843 have to be instantiated under subnode
>> +	named "regulators" using the following format.
>> +
>> +	[*]refer : Documentation/devicetree/bindings/regulator/regulator.txt
>> +
>> +	regulators {
>> +		SAFEOUT {
>> +			regulator-name = "SAFEOUT";
>> +		};
>> +	}
>> +
>> +	List of valid regulator names:
>> +	- SAFEOUT1, SAFEOUT2, CHARGER.
>> +
>> +- max77843-muic : This properties used by extcon consumers.
>> +	Required properties:
>> +		- compatible : Must be "maxim,max77842-muic".
>> +
>> +- max77843-charger : There battery charger of MAX77843 have to be instantiated
>> +	under sub-node named "max77843-charger" using the following format.
>> +	Required properties:
>> +		- compatible : Must be "maxim,max77842-charger".
>> +		- maxim,fast-charge-uamp : Fast charge current levels are
>> +			100 mA to 3150 mA programmed by I2C per 100 mA.
>> +		- maxim,top-off-uamp : Top off current threshold levels are
>> +			125 mA to 650 mA programmed by I2C per 75 mA.
>> +		- maxim,input-uamp-limit : Input current limit levels are
>> +			100 mA to 3533 mA programmed by I2C per 33 mA.
>> +- max77843-fuelgauge : There fuelgauge of MAX77843 have to be instantiated
>> +	under sub-node named "max77843-fuelgauge" using the following format.
>> +	Required properties:
>> +		- compatible : Must be "maxim,max77842-fuelgauge".
>> +
>> +Example:
>> +	max77843@66 {
>> +		compatible = "samsung,max77843";
>> +		reg = <0x66>;
>> +		interrupt-parent = <&gpa1>;
>> +		interrupts = <5 2>;
>> +
>> +		regulators {
>> +			SAFEOUT1 {
>> +				regulator-name = "SAFEOUT1";
>> +				regulator-min-microvolt = <3300000>;
>> +				regulator-max-microvolt = <4950000>;
>> +			};
>> +			SAFEOUT2 {
>> +				regulator-name = "SAFEOUT2";
>> +				regulator-min-microvolt = <3300000>;
>> +				regulator-max-microvolt = <4950000>;
>> +			};
> 
> As I knew, max77843 regulator driver supprot 'CHARGER' regulator.
> I think you have to add the 'CHARGER' dt node for regulators.
> 
> 

Right, I will include charger regulator.

>> +		};
>> +
>> +		max77843-muic {
>> +			compatible = "maxim,max77843-muic";
>> +		};
>> +
>> +		max77843-charger {
>> +			compatible = "maxim,max77843-charger";
>> +			maxim,fast-charge-uamp = <450000>;
>> +			maxim,top-off-uamp = <125000>;
>> +			maxim,input-uamp-limit = <500000>;
>> +		};
>> +
>> +		max77843-fuelgauge {
>> +			compatible = "maxim,max77843-fuelgauge";
>> +		};
>> +
>> +	};
>>
> 
> Thanks,
> Chanwoo Choi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

