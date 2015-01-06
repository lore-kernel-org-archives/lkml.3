Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbbAFXfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:35:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53453 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:35:00 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ca-54ac71223336
Message-id: <54AC7121.60303@samsung.com>
Date: Wed, 07 Jan 2015 08:34:57 +0900
From: Beomho Seo <beomho.seo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lee.jone@linaro.org, Mark Brown <broonie@kernel.org>,
        Sebastian Reichel <sre@kernel.org>, dbaryshkov@gmail.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, InKi Dae <inki.dae@samsung.com>,
        sw0312.kim@samsung.com, Lee Jones <lee.jones@linaro.org>,
        beomho.seo@samsung.com
Subject: Re: [PATCH RESEND 3/3] Documentation: Add documentation for rt5033
 multifunction device
References: <1420523117-6814-1-git-send-email-beomho.seo@samsung.com>
 <1420523117-6814-4-git-send-email-beomho.seo@samsung.com>
 <CAL_Jsq+Sz_iCkaDWzssA6DFeLX8fQ2hqKut0Gv6i5P706bmvpA@mail.gmail.com>
In-reply-to: <CAL_Jsq+Sz_iCkaDWzssA6DFeLX8fQ2hqKut0Gv6i5P706bmvpA@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkRFepcE2IQccTGYvTn7axW0x9+ITN
	4vqX56wWk568Z7aYf+Qcq0X/m4WsFuderWS0mHR/AovF+z1nGC3ufz3KaHF51xw2i8+9Rxgt
	ll6/yGQxYfpaFovWvUfYLb5/+8ZmcXp3icWMyS/ZHIQ81sxbw+hxua+XyWPnrLvsHiuXf2Hz
	2LSqk83jzrU9bB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV8fhlI1vBbPOK+1e3sDQwrlbt
	YuTkkBAwkThwdAcbhC0mceHeeiCbi0NIYCmjxLdnaxhhitrvrGCCSExnlNi9dRkrhPOaUeLz
	6h2sIFW8AhoSXWtusYPYLAKqEj9PPWcCsdkENCXeT7nCAmKLCkRIfFj1lQ2iXlDix+R7YHER
	AXWJb8uPg61mFuhklehYu5oZJCEskCSxZfkLdohtJxgllkw5CDaVUyBY4vPuv0D3cQB1qEtM
	mZILEmYWkJfYvOYtM0i9hMAeDonfk86wQVwkIPFt8iEWkHoJAVmJTQeYIV6TlDi44gbLBEax
	WUhumoUwdRaSqQsYmVcxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBKaA0/+eTdzBeP+A9SFG
	AQ5GJR5ej67VIUKsiWXFlbmHGE2BjpjILCWanA9MNHkl8YbGZkYWpiamxkbmlmZK4rw60j+D
	hQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTC6hIqLWc119M/e35y0aufBC6d3ea6XfGQ+Z8vO
	w12fk+W/d15fc+3O67u7l9WcLZrBNmd28CvtjKIDbVNsDF3Ozu7+eP5Eyxf2iZnByUJxL+W9
	duQxVTBvepezUfjKK8XrX3l2LFrz7hvHOt9nD5aWd9q15Ld5L6ybrF5Z8MjYe7NVWsjUlkXX
	lFiKMxINtZiLihMBDZ1cQfwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV2lwjUhBkuPCFmc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC363yxktTj3aiWjxaT7E1gs3u85w2hx/+tRRovLu+awWXzuPcJo
	sfT6RSaLCdPXsli07j3CbvH92zc2i9O7SyxmTH7J5iDksWbeGkaPy329TB47Z91l91i5/Aub
	x6ZVnWwed67tYfPo27KK0ePzJrkAjqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoGeUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmg
	gYQ1jBmPXzayFcw2r7h/dQtLA+Nq1S5GTg4JAROJ9jsrmCBsMYkL99azdTFycQgJTGeU2L11
	GSuE85pR4vPqHawgVbwCGhJda26xg9gsAqoSP089B+tmE9CUeD/lCguILSoQIfFh1Vc2iHpB
	iR+T74HFRQTUJb4tPw62gVmgk1WiY+1qZpCEsECSxJblL9ghtp1glFgy5SDYVE6BYInPu/8y
	djFyAHWoS0yZkgsSZhaQl9i85i3zBEaBWUh2zEKomoWkagEj8ypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4ATzTGoH48oGi0OMAhyMSjy8Hl2rQ4RYE8uKK3MPMUpwMCuJ8JZkrgkR4k1J
	rKxKLcqPLyrNSS0+xGgKDIGJzFKiyfnA5JdXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliS
	mp2aWpBaBNPHxMEp1cB4dsp+q3N3Ikz5f3BtWr3T6nL8zqvGBhFXxfZuexd9Oaakbkfe/y96
	ixuWdmieUVm583nBmXh+V+MLZ6/JTS8W/1d+rEg8PeDxFnbme31e87jnSJib35+zYkl+9fK/
	PtpGAaG8W3JufH18c699G1PTmht6W2dvULzlwsG5l+3UHRt79qrXbioiSizFGYmGWsxFxYkA
	Jm/48UYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review.

On 01/07/2015 01:54 AM, Rob Herring wrote:
> On Mon, Jan 5, 2015 at 11:45 PM, Beomho Seo <beomho.seo@samsung.com> wrote:
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
>> ---
>>  Documentation/devicetree/bindings/mfd/rt5033.txt   |  108 ++++++++++++++++++++
>>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>>  2 files changed, 109 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/rt5033.txt b/Documentation/devicetree/bindings/mfd/rt5033.txt
>> new file mode 100644
>> index 0000000..52a6d33
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/rt5033.txt
>> @@ -0,0 +1,108 @@
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
>> +named "regulators" usinge the following format.
> 
> s/usinge/using/
> 

I will fix wrong typo.

>> +
>> +       regulators {
>> +               regulator-name {
>> +                       regulator-name = LDO/BUCK
>> +                       regulator subnodes called X, Y and Z
>> +               };
>> +       };
>> +       refer Documentation/devicetree/bindings/regulator/regulator.txt
>> +
>> +
>> +Battery charger: There battery charger of RT5033 have to be instantiated under
>> +sub-node named "charger" using the following format.
>> +
>> +Required properties:
>> +- compatible : Must be "richtek,rt5033-charger".
>> +- richtek,pre-uamp : Current of pre-charge mode. The pre-charge current levels
>> +  are 350 mA to 650 mA programmed by I2C per 100 mA.
>> +- richtek,pre-threshold-uvolt : Voltage of threshold pre-charge mode. Battery
>> +  voltage is below pre-charge threshold voltage, the charger is in pre-charge
>> +  mode with pre-charge current. Its levels are 2.3 V  to 3.8 V programmed
>> +  by I2C per 0.1 V.
>> +- richtek,fast-uamp : Current of fast-charge mode. The fast-charge current
>> +  levels are 700 mA to 2000 mA programmed by I2C per 100 mA.
>> +- richtek,const-uvolt :  Battery regulation voltage of constant voltage mode.
>> +  This voltage level 3.65 V to 4.4 V bye I2C per 0.025 V.
>> +- richtek,eoc-uamp : This property is end of charge current. Its level 150 mA
>> +  to 200 mA.
> 
> Please align -uamp and -uvolt names with regulator binding suffixes.
> 

OK. I will fix it.

>> +       charger {
>> +               compatible = "richtek,rt5033-charger";
>> +               richtek,pre-uamp = <350000>;
>> +               richtek,pre-threshold-uvolt = <3400000>;
>> +               richtek,fast-uamp = <2000000>;
>> +               richtek,const-uvolt = <4350000>;
>> +               richtek,eoc-uamp = <250000>;
>> +       };
>> +
>> +
>> +Fuelgauge: There fuelgauge of RT5033 to be instantiated node named "fuelgauge"
>> +using the following format.
>> +
>> +Required properties:
>> +- compatible = Must be "richtek,rt5033-battery".
>> +
>> +       i2c_fuel: i2c@1 {
> 
> Drop the @1.
> 

OK. I will fix it.

>> +               compatible = "i2c-gpio";
>> +               standard i2c-gpio constraints...
>> +               fuelgauge {
>> +                       compatible = "richtek,rt5033-battery".
>> +               };
>> +       };
> 
> I'm a bit confused by this. The fuelgauge is an i2c device hanging off
> the rt5033 or a 2nd i2c slave on the rt5033?
>

It is 2nd i2c slave on the rt5033.

>> +
>> +
>> +Example:
>> +
>> +               rt5033@34 {
>> +                       compatible = "richtek,rt5033";
>> +                       reg = <0x34>;
>> +                       interrupt-parent = <&gpx1>;
>> +                       interrupts = <5 0>;
>> +
>> +                       regulators {
>> +                               buck_reg: BUCK {
>> +                                       regulator-name = "BUCK";
>> +                                       regulator-min-microvolt = <1200000>;
>> +                                       regulator-max-microvolt = <1200000>;
>> +                                       regulator-always-on;
>> +                               };
>> +                       };
>> +
>> +                       charger {
>> +                               compatible = "richtek,rt5033-charger";
>> +                               richtek,pre-uamp = <350000>;
>> +                               richtek,pre-threshold-uvolt = <3400000>;
>> +                               richtek,fast-uamp = <2000000>;
>> +                               richtek,const-uvolt = <4350000>;
>> +                               richtek,eoc-uamp = <250000>;
>> +                       };
>> +
>> +               };
>> +
>> +               i2c_fuel: i2c@10 {
>> +                       compatible = "i2c-gpio";
>> +                       gpios = <&gpm3 1 0
>> +                               &gpm3 0 0>;
>> +
>> +                       fuel: rt5033-battery@35 {
>> +                               compatible = "richtek,rt5033-battery";
>> +                               interrupt-parent = <&gpx2>;
>> +                               interrupts = <3 0>;
>> +                               reg = <0x35>;
>> +                       };
>> +               };
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> index 723999d..611b543 100644
>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> @@ -124,6 +124,7 @@ ralink      Mediatek/Ralink Technology Corp.
>>  ramtron        Ramtron International
>>  realtek Realtek Semiconductor Corp.
>>  renesas        Renesas Electronics Corporation
>> +richtek        Richtek Technology Corporation
>>  ricoh  Ricoh Co. Ltd.
>>  rockchip       Fuzhou Rockchip Electronics Co., Ltd
>>  samsung        Samsung Semiconductor
>> --
>> 1.7.9.5
>>
> 

Best regards,
Beomho Seo

