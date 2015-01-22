Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbbAVJVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:21:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63594 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbAVJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:21:43 -0500
X-AuditID: cbfee68d-f79296d000004278-e5-54c0c124b0c6
Message-id: <54C0C124.7010403@samsung.com>
Date: Thu, 22 Jan 2015 18:21:40 +0900
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
 <20150122074101.GK22024@x1> <54C0B1EA.7030901@samsung.com>
 <20150122090243.GA5465@x1>
In-reply-to: <20150122090243.GA5465@x1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkWFf14IEQg9Pz2C2mPnzCZnH9y3NW
	i0lP3jNbzD9yjtWi/81CVotzr1YyWky6P4HF4v2eM4wW978eZbS4vGsOm8Xn3iOMFkuvX2Sy
	mDB9LYtF694j7Band5dYzJj8ks1BwGPNvDWMHpf7epk8ds66y+6xcvkXNo9NqzrZPO5c28Pm
	0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBn/zp5kLThqUvF3wzfmBsbzWl2MnBwSAiYS/f+n
	M0PYYhIX7q1n62Lk4hASWMoo8WH6AqAEB1jR9EdaEPFFjBKHuzcxQTivGSXaD71mAunmFdCS
	OPX/EwuIzSKgKnH8ynGwOJuApsT7KVfA4qICERLzj71mhqgXlPgx+R4LyAIRARWJc2/MQWYy
	Czxnkpg+cwo7SI2wQJxEf/NsRohldxkllrx7yQjSwCmgLrF4HdhxzEDmlCm5IOXMAvISm9e8
	ZQYplxBYyiGx4eJKNoh7BCS+TT7EAvGMrMSmA1APS0ocXHGDZQKj2CwkF81CmDoLydQFjMyr
	GEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQIj/fS/Z707GG8fsD7EKMDBqMTD+3LGgRAh1sSy
	4srcQ4ymQEdMZJYSTc4HppO8knhDYzMjC1MTU2Mjc0szJXFeRamfwUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoY53W/Su1ZGP/fhc1yZ9DOD53HVDqcW4LKU25L6j/iuP5WXMw6qfbyrf5V
	mlNdoyt/nljweWvB6uwVsYWcF7y1P4TstPjb+LymKWf/KyMr6xknLF42LhdmVwrdf2DXs60H
	n/9+wV25pL+s93VHrX5jqffVu7yXnzxNeDOxofmI5ovtvv493zdFKrEUZyQaajEXFScCAOCo
	vLLvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV2VgwdCDA4/tLSY+vAJm8X1L89Z
	LSY9ec9sMf/IOVaL/jcLWS3OvVrJaDHp/gQWi/d7zjBa3P96lNHi8q45bBafe48wWiy9fpHJ
	YsL0tSwWrXuPsFuc3l1iMWPySzYHAY8189Ywelzu62Xy2DnrLrvHyuVf2Dw2repk87hzbQ+b
	R9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoq
	ufgE6Lpl5gC9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+Hf2JGvB
	UZOKvxu+MTcwntfqYuTgkBAwkZj+CMjkBDLFJC7cW8/WxcjFISSwiFHicPcmJgjnNaNE+6HX
	TCBVvAJaEqf+f2IBsVkEVCWOXzkOFmcT0JR4P+UKWFxUIEJi/rHXzBD1ghI/Jt9jAVkmIqAi
	ce6NOchMZoHnTBLTZ05hB6kRFoiT6G+ezQix7C6jxJJ3LxlBGjgF1CUWr2MGMZmBzClTckHK
	mQXkJTavecs8gVFgFpINsxCqZiGpWsDIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOI08
	k97BuKrB4hCjAAejEg9vRvGBECHWxLLiytxDjBIczEoivDs3AIV4UxIrq1KL8uOLSnNSiw8x
	mgL9P5FZSjQ5H5ji8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUa
	GJnND3NHLlhWVbOoauHBX1JTIl84SNWW3Uptu9R/4Fq+xfn5rrINgo+mSa3srX50ZmbEHiFL
	Ew6XwP5/aU0rsozOCN+sm/TXfSobn/yK93cv3ljPdGWDW+otQ+ElVUlcvmm5vQ15y4LLbzbN
	1c6SO5Cb+EL+sv8Rn8zoz0+DVGNlg07uTJt6SYmlOCPRUIu5qDgRACeaZUk5AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 06:02 PM, Lee Jones wrote:
> On Thu, 22 Jan 2015, Beomho Seo wrote:
> 
>> On 01/22/2015 04:41 PM, Lee Jones wrote:
>>> On Thu, 22 Jan 2015, Beomho Seo wrote:
>>>
>>>> This patch device tree binding documentation for rt5033 multifunction device.
>>>>
>>>> Cc: Sebastian Reichel <sre@kernel.org>
>>>> Cc: Lee Jones <lee.jones@linaro.org>
>>>> Cc: Mark Brown <broonie@kernel.org>
>>>> Cc: Rob Herring <robh+dt@kernel.org>
>>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>> Cc: Ian campbell <ijc+devicetree@hellion.org.uk>
>>>> Cc: Kumar Gala <galak@codeaurora.org>
>>>> Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
>>>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Acked-by: Lee Jones <lee.jones@linaro.org>
>>>
>>> I did not Ack this patch.
>>>
>>> Your new vendor bindings require a DT Ack.
>>>
>>> Although, as the ones I'm concerned with are Regulator related, and
>>> Ack from Mark Brown will also suffice.
>>>
>>
>> I want to apologize for my mistake. I completely misunderstood your reply.
>> Unfortunately, This patch merged by Sebastian at his git.
>> Please tell me what to do.
> 
> That's strange, as I haven't heard anything from Sebastian.
> 
> Anyway, he needs to remove it from his tree until we receive a
> suitable Ack.
> 

OK, If Sebastian remove it from his tree, I will fix Acked-by. And then
wait receive a suitable Ack.

>>>> ---
>>>> Changes in v4
>>>> - none.
>>>> Changes in v3
>>>> - Add Acked-by
>>>> Changes in v2
>>>> - Fix incorrect typo.
>>>> - Align -uamp and -uvolt names with regulator binding suffixes.
>>>> - Drop incorrect phandle.
>>>> - Fix incorrect example.
>>>> ---
>>>>
>>>>  Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++++++++++++++++++
>>>>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>>>>  2 files changed, 102 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
>>>> new file mode 100644
>>>> index 0000000..64b23e8
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
>>>> @@ -0,0 +1,101 @@
>>>> +Richtek RT5033 Power management Integrated Circuit
>>>> +
>>>> +RT5033 is a Multifunction device which includes battery charger, fuel gauge,
>>>> +flash LED current source, LDO and synchronous Buck converter for portable
>>>> +applications. It is interfaced to host controller using i2c interface.
>>>> +
>>>> +Required properties:
>>>> +- compatible : Must be "richtek,rt5033"
>>>> +- reg : Specifies the i2c slave address of general part.
>>>> +- interrupts : This i2c devices has an IRQ line connected to the main SoC.
>>>> +- interrupt-parent : The parent interrupt controller.
>>>> +
>>>> +Optional node:
>>>> +Regulators: The regulators of RT5033 have to be instantiated under sub-node
>>>> +named "regulators" using the following format.
>>>> +
>>>> +	regulators {
>>>> +		regulator-name {
>>>> +			regulator-name = LDO/BUCK
>>>> +			regulator subnodes called X, Y and Z
>>>> +		};
>>>> +	};
>>>> +	refer Documentation/devicetree/bindings/regulator/regulator.txt
>>>> +
>>>> +
>>>> +Battery charger: There battery charger of RT5033 have to be instantiated under
>>>> +sub-node named "charger" using the following format.
>>>> +
>>>> +Required properties:
>>>> +- compatible : Must be "richtek,rt5033-charger".
>>>> +- richtek,pre-uamp : Current of pre-charge mode. The pre-charge current levels
>>>> +  are 350 mA to 650 mA programmed by I2C per 100 mA.
>>>> +- richtek,fast-uamp : Current of fast-charge mode. The fast-charge current
>>>> +  levels are 700 mA to 2000 mA programmed by I2C per 100 mA.
>>>> +- richtek,eoc-uamp : This property is end of charge current. Its level 150 mA
>>>> +  to 200 mA.
>>>> +- richtek,pre-threshold-uvolt : Voltage of threshold pre-charge mode. Battery
>>>> +  voltage is below pre-charge threshold voltage, the charger is in pre-charge
>>>> +  mode with pre-charge current. Its levels are 2.3 V  to 3.8 V programmed
>>>> +  by I2C per 0.1 V.
>>>> +- richtek,const-uvolt :  Battery regulation voltage of constant voltage mode.
>>>> +  This voltage level 3.65 V to 4.4 V bye I2C per 0.025 V.
>>>> +
>>>> +	charger {
>>>> +		compatible = "richtek,rt5033-charger";
>>>> +		richtek,pre-uamp = <350000>;
>>>> +		richtek,fast-uamp = <2000000>;
>>>> +		richtek,eoc-uamp = <250000>;
>>>> +		richtek,pre-threshold-uvolt = <3400000>;
>>>> +		richtek,const-uvolt = <4350000>;
>>>> +
>>>> +	};
>>>> +
>>>> +
>>>> +Fuelgauge: There fuelgauge of RT5033 to be instantiated node named "fuelgauge"
>>>> +using the following format.
>>>> +
>>>> +Required properties:
>>>> +- compatible = Must be "richtek,rt5033-battery".
>>>> +
>>>> +	rt5033@35 {
>>>> +		compatible = "richtek,rt5033-battery";
>>>> +		interrupt-parent = <&gpx2>;
>>>> +		interrupts = <3 0>;
>>>> +		reg = <0x35>;
>>>> +	};
>>>> +
>>>> +Example:
>>>> +
>>>> +		rt5033@34 {
>>>> +			compatible = "richtek,rt5033";
>>>> +			reg = <0x34>;
>>>> +			interrupt-parent = <&gpx1>;
>>>> +			interrupts = <5 0>;
>>>> +
>>>> +			regulators {
>>>> +				buck_reg: BUCK {
>>>> +					regulator-name = "BUCK";
>>>> +					regulator-min-microvolt = <1200000>;
>>>> +					regulator-max-microvolt = <1200000>;
>>>> +					regulator-always-on;
>>>> +				};
>>>> +			};
>>>> +
>>>> +			charger {
>>>> +				compatible = "richtek,rt5033-charger";
>>>> +				richtek,pre-uamp = <350000>;
>>>> +				richtek,fast-uamp = <2000000>;
>>>> +				richtek,eoc-uamp = <250000>;
>>>> +				richtek,pre-threshold-uvolt = <3400000>;
>>>> +				richtek,const-uvolt = <4350000>;
>>>> +			};
>>>> +
>>>> +		};
>>>> +
>>>> +		rt5033@35 {
>>>> +				compatible = "richtek,rt5033-battery";
>>>> +				interrupt-parent = <&gpx2>;
>>>> +				interrupts = <3 0>;
>>>> +				reg = <0x35>;
>>>> +		};
>>>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>>>> index b1df0ad..b6a2ca1 100644
>>>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>>>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>>>> @@ -134,6 +134,7 @@ ralink	Mediatek/Ralink Technology Corp.
>>>>  ramtron	Ramtron International
>>>>  realtek Realtek Semiconductor Corp.
>>>>  renesas	Renesas Electronics Corporation
>>>> +richtek	Richtek Technology Corporation
>>>>  ricoh	Ricoh Co. Ltd.
>>>>  rockchip	Fuzhou Rockchip Electronics Co., Ltd
>>>>  samsung	Samsung Semiconductor
>>>
>>
>> Thanks,
>> Beomho Seo
> 

