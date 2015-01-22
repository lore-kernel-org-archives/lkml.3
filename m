Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbbAVIQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:16:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48674 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbAVIQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:16:45 -0500
X-AuditID: cbfee68e-f79b46d000002b74-34-54c0b1ea2882
Message-id: <54C0B1EA.7030901@samsung.com>
Date: Thu, 22 Jan 2015 17:16:42 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, robh+dt@kernel.org,
        lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH v4 2/2] Documentation: Add documentation for rt5033
 multifunction device
References: <1421899601-19327-1-git-send-email-beomho.seo@samsung.com>
 <1421899601-19327-3-git-send-email-beomho.seo@samsung.com>
 <20150122074101.GK22024@x1>
In-reply-to: <20150122074101.GK22024@x1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkUPf1xgMhBrsWsllMffiEzeL6l+es
	FpOevGe2mH/kHKtF/5uFrBbnXq1ktJh0fwKLxfs9Zxgt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y6xmDH5JZuDgMeaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	o2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDK+zF7PVjBBv+Lq5vVsDYyfVLsYOTkkBEwkehbd
	YIawxSQu3FvP1sXIxSEksJRR4tbJ74xdjBxgRRfeuUHEFzFKLJt5lRGkQUjgNaPEmrnsIDav
	gJbEq9MbwQaxCKhKHNu/BCzOJqAp8X7KFRYQW1QgQmL+sdfMEPWCEj8m32MBmS8ioCJx7o05
	yHxmgedMEtNnTgHrFRaIk+hvns0IsXgho8T0BU1MIAlOAQ2JvtXXwY5jFlCXmDIlFyTMLCAv
	sXnNW2aQegmBtRwSH//MZoM4SEDi2+RDLBDPyEpsOgD1sKTEwRU3WCYwis1CctIshKmzkExd
	wMi8ilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMw0k//e9a3g/HmAetDjAIcjEo8vBnFB0KE
	WBPLiitzDzGaAh0xkVlKNDkfmE7ySuINjc2MLExNTI2NzC3NlMR5E6R+BgsJpCeWpGanphak
	FsUXleakFh9iZOLglGpgnClusv110vW/X922eqmpzHS3T9FuYik4nK/mJR+0xD7j28Q7jjPK
	rd8Hr/JqDPa4bHv0zqsrycXVRT3Nqcc8nn0UWVYQ8uHAvJPN3zmsVh6rnsdefHTxk+zzCZ0L
	1Ju37va5e2y663v9ptK5u2ovhMVHGZ55y/M4YnvJHGdBpWjh+bVJ8b36SizFGYmGWsxFxYkA
	GwT3ru8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd1XGw+EGLR0WlpMffiEzeL6l+es
	FpOevGe2mH/kHKtF/5uFrBbnXq1ktJh0fwKLxfs9Zxgt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y6xmDH5JZuDgMeaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	o2/LKkaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22V
	XHwCdN0yc4BeUFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmfJm9nq1g
	gn7F1c3r2RoYP6l2MXJwSAiYSFx459bFyAlkiklcuLeerYuRi0NIYBGjxLKZVxlBEkICrxkl
	1sxlB7F5BbQkXp3eyAxiswioShzbvwQsziagKfF+yhUWEFtUIEJi/rHXzBD1ghI/Jt9jAdkl
	IqAice6NOch8ZoHnTBLTZ04B6xUWiJPob57NCLF4IaPE9AVNTCAJTgENib7V1xlBmpkF1CWm
	TMkFCTMLyEtsXvOWeQKjwCwkK2YhVM1CUrWAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnAaeSa1g3Flg8UhRgEORiUe3oziAyFCrIllxZW5hxglOJiVRHh3bgAK8aYkVlalFuXHF5Xm
	pBYfYjQFBsBEZinR5HxgissriTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj
	4uCUamAMi/6dW5a/VXrq9sQTZ9J9Di9VXvB8o/fslMcvbrz9yhYpzLO8Z+45s71Gnau8Py89
	IOzIwiXLYN7kLaGspbXN5dOzm2vEmngv7d9f6z17y75e/uy13h2SLE1LPA9IH6qvfqxvyPB3
	MfulRke3vY5P2n3XivK37DtRMKslqHvmX77fm6P3PJmlxFKckWioxVxUnAgA65t4zTkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 04:41 PM, Lee Jones wrote:
> On Thu, 22 Jan 2015, Beomho Seo wrote:
> 
>> This patch device tree binding documentation for rt5033 multifunction device.
>>
>> Cc: Sebastian Reichel <sre@kernel.org>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> I did not Ack this patch.
> 
> Your new vendor bindings require a DT Ack.
> 
> Although, as the ones I'm concerned with are Regulator related, and
> Ack from Mark Brown will also suffice.
> 

I want to apologize for my mistake. I completely misunderstood your reply.
Unfortunately, This patch merged by Sebastian at his git.
Please tell me what to do.

>> ---
>> Changes in v4
>> - none.
>> Changes in v3
>> - Add Acked-by
>> Changes in v2
>> - Fix incorrect typo.
>> - Align -uamp and -uvolt names with regulator binding suffixes.
>> - Drop incorrect phandle.
>> - Fix incorrect example.
>> ---
>>
>>  Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++++++++++++++++++
>>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>>  2 files changed, 102 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
>> new file mode 100644
>> index 0000000..64b23e8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
>> @@ -0,0 +1,101 @@
>> +Richtek RT5033 Power management Integrated Circuit
>> +
>> +RT5033 is a Multifunction device which includes battery charger, fuel gauge,
>> +flash LED current source, LDO and synchronous Buck converter for portable
>> +applications. It is interfaced to host controller using i2c interface.
>> +
>> +Required properties:
>> +- compatible : Must be "richtek,rt5033"
>> +- reg : Specifies the i2c slave address of general part.
>> +- interrupts : This i2c devices has an IRQ line connected to the main SoC.
>> +- interrupt-parent : The parent interrupt controller.
>> +
>> +Optional node:
>> +Regulators: The regulators of RT5033 have to be instantiated under sub-node
>> +named "regulators" using the following format.
>> +
>> +	regulators {
>> +		regulator-name {
>> +			regulator-name = LDO/BUCK
>> +			regulator subnodes called X, Y and Z
>> +		};
>> +	};
>> +	refer Documentation/devicetree/bindings/regulator/regulator.txt
>> +
>> +
>> +Battery charger: There battery charger of RT5033 have to be instantiated under
>> +sub-node named "charger" using the following format.
>> +
>> +Required properties:
>> +- compatible : Must be "richtek,rt5033-charger".
>> +- richtek,pre-uamp : Current of pre-charge mode. The pre-charge current levels
>> +  are 350 mA to 650 mA programmed by I2C per 100 mA.
>> +- richtek,fast-uamp : Current of fast-charge mode. The fast-charge current
>> +  levels are 700 mA to 2000 mA programmed by I2C per 100 mA.
>> +- richtek,eoc-uamp : This property is end of charge current. Its level 150 mA
>> +  to 200 mA.
>> +- richtek,pre-threshold-uvolt : Voltage of threshold pre-charge mode. Battery
>> +  voltage is below pre-charge threshold voltage, the charger is in pre-charge
>> +  mode with pre-charge current. Its levels are 2.3 V  to 3.8 V programmed
>> +  by I2C per 0.1 V.
>> +- richtek,const-uvolt :  Battery regulation voltage of constant voltage mode.
>> +  This voltage level 3.65 V to 4.4 V bye I2C per 0.025 V.
>> +
>> +	charger {
>> +		compatible = "richtek,rt5033-charger";
>> +		richtek,pre-uamp = <350000>;
>> +		richtek,fast-uamp = <2000000>;
>> +		richtek,eoc-uamp = <250000>;
>> +		richtek,pre-threshold-uvolt = <3400000>;
>> +		richtek,const-uvolt = <4350000>;
>> +
>> +	};
>> +
>> +
>> +Fuelgauge: There fuelgauge of RT5033 to be instantiated node named "fuelgauge"
>> +using the following format.
>> +
>> +Required properties:
>> +- compatible = Must be "richtek,rt5033-battery".
>> +
>> +	rt5033@35 {
>> +		compatible = "richtek,rt5033-battery";
>> +		interrupt-parent = <&gpx2>;
>> +		interrupts = <3 0>;
>> +		reg = <0x35>;
>> +	};
>> +
>> +Example:
>> +
>> +		rt5033@34 {
>> +			compatible = "richtek,rt5033";
>> +			reg = <0x34>;
>> +			interrupt-parent = <&gpx1>;
>> +			interrupts = <5 0>;
>> +
>> +			regulators {
>> +				buck_reg: BUCK {
>> +					regulator-name = "BUCK";
>> +					regulator-min-microvolt = <1200000>;
>> +					regulator-max-microvolt = <1200000>;
>> +					regulator-always-on;
>> +				};
>> +			};
>> +
>> +			charger {
>> +				compatible = "richtek,rt5033-charger";
>> +				richtek,pre-uamp = <350000>;
>> +				richtek,fast-uamp = <2000000>;
>> +				richtek,eoc-uamp = <250000>;
>> +				richtek,pre-threshold-uvolt = <3400000>;
>> +				richtek,const-uvolt = <4350000>;
>> +			};
>> +
>> +		};
>> +
>> +		rt5033@35 {
>> +				compatible = "richtek,rt5033-battery";
>> +				interrupt-parent = <&gpx2>;
>> +				interrupts = <3 0>;
>> +				reg = <0x35>;
>> +		};
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> index b1df0ad..b6a2ca1 100644
>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> @@ -134,6 +134,7 @@ ralink	Mediatek/Ralink Technology Corp.
>>  ramtron	Ramtron International
>>  realtek Realtek Semiconductor Corp.
>>  renesas	Renesas Electronics Corporation
>> +richtek	Richtek Technology Corporation
>>  ricoh	Ricoh Co. Ltd.
>>  rockchip	Fuzhou Rockchip Electronics Co., Ltd
>>  samsung	Samsung Semiconductor
> 

Thanks,
Beomho Seo
