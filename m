Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbaDQLwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:52:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38035 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaDQLwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:52:14 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-e0-534fc06ca7d9
Message-id: <534FC071.9080502@samsung.com>
Date: Thu, 17 Apr 2014 20:52:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 2/2] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
References: <1397643118-6934-1-git-send-email-cw00.choi@samsung.com>
 <1397643118-6934-3-git-send-email-cw00.choi@samsung.com>
 <534E6E4E.4020807@samsung.com>
In-reply-to: <534E6E4E.4020807@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42JZI2JSqJt7wD/Y4P8zZou7zw8zWsw/co7V
	ov/NQlaLc69WMlo8aFrFZNG74CqbxabH11gtFrYtYbGYd+Qdi8XlXXPYLGac38dksfT6RSaL
	CdPXsli8vTOdxaJ17xF2i5N/ehkt1s94zeIg6LFm3hpGj8t9vUweK5d/YfPYvELLY9OqTjaP
	O9f2AHlL6j36tqxi9Pi8SS6AM4rLJiU1J7MstUjfLoEr4+W+TUwFC8QrjnYuZ2xgbBfqYuTk
	kBAwkZg+uYUNwhaTuHBvPZDNxSEksJRRYvPf7UwwRfOeL2eGSCxilPi84AEzSEJI4DWjxI2N
	ASA2r4CWxKOdU8EaWARUJab33WQFsdmA4vtf3ADbICoQJrFy+hUWiHpBiR+T74HZIgIqEpdP
	TWcEWcAssIpZounDCbBBwgKxEutm7mOE2LyAUaJjTxOQw8HBKaAt0bJVCaSGWUBHYn/rNDYI
	W15i85q3YJdKCOzgkFhy+wkjxEUCEt8mH2IB6ZUQkJXYdIAZ4jNJiYMrbrBMYBSbheSmWUjG
	zkIydgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwARw+t+z3h2Mtw9YH2JMBlo5kVlK
	NDkfmEDySuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoFx5b05rgHH3sYe3jzTqONVXaFM00fhc553Js4LXq2qsubNxw72fzunFCmbXHkRsXHXPUvH
	b5Xy/817ulofWEzlqXriYrTjQmLX3sg3qZY81oyMy51iMsMcO/jqFYKcG48dkZ163vr7uaBT
	r47NiJT+p2zB8FMm0Ngx9Z2R5j7v15q6zfz7k22UWIozEg21mIuKEwHetrO/FgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAd2cA/7BBou+mFncfX6Y0WL+kXOs
	Fv1vFrJanHu1ktHiQdMqJoveBVfZLDY9vsZqsbBtCYvFvCPvWCwu75rDZjHj/D4mi6XXLzJZ
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxYHQY8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ5
	3Lm2B8hbUu/Rt2UVo8fnTXIBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QL8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDNe7tvEVLBAvOJo53LGBsZ2oS5GTg4JAROJec+XM0PYYhIX7q1n62Lk4hASWMQo8XnBA7CE
	kMBrRokbGwNAbF4BLYlHO6cygdgsAqoS0/tusoLYbEDx/S9usIHYogJhEiunX2GBqBeU+DH5
	HpgtIqAicfnUdEaQBcwCq5glmj6cABskLBArsW7mPkaIzQsYJTr2NAE5HBycAtoSLVuVQGqY
	BXQk9rdOY4Ow5SU2r3nLPIFRYBaSHbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5y
	fu4mRnB6eSa9g3FVg8UhRgEORiUeXs7ffsFCrIllxZW5hxglOJiVRHib1/sHC/GmJFZWpRbl
	xxeV5qQWH2JMBgbBRGYp0eR8YOrLK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJanZq
	akFqEcwWJg5OqQZGhczuNMNCJo6i2e84+jbPTJ1mI98bfraXx+Nqc4JmS3/0Uf6ow4envZJc
	vWaT1JspvpMuvucSc2gyFntpfD+5buuJ33v6kyz/PG9YURW9ea/SMiW23IPbLz6y1imXlzWS
	bTN4u4S/07W0oH4t45JVt1kM5ZtvWz4SFlR6wyc4ifv8o1lbzs9VYinOSDTUYi4qTgQAylC+
	+nMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/16/2014 08:49 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 16.04.2014 12:11, Chanwoo Choi wrote:
>> This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
>> special clock ('sclk_tsadc') for ADC which provide clock to internal ADC.
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Cc: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   .../devicetree/bindings/arm/samsung/exynos-adc.txt   | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> index 5d49f2b..7532ec3 100644
>> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> @@ -14,6 +14,8 @@ Required properties:
>>                   for exynos4412/5250 controllers.
>>               Must be "samsung,exynos-adc-v2" for
>>                   future controllers.
>> +            Must be "samsung,exynos-adc-v3" for
>> +                for exynos3250 controllers.
> 
> I don't think adc-v3 is correct here. It looks like a normal V2 with additional special clock input. Possibly "samsung,exynos3250-adc-v2" or "samsung,exynos-adc-v2-sclk" would be better choices.

OK, I'll fix it with following compatible
- "samsung,exynos-adc-v2-sclk"

> 
>>   - reg:            Contains ADC register address range (base address and
>>               length) and the address of the phy enable register.
>>   - interrupts:         Contains the interrupt information for the timer. The
>> @@ -21,7 +23,11 @@ Required properties:
>>               the Samsung device uses.
>>   - #io-channel-cells = <1>; As ADC has multiple outputs
>>   - clocks        From common clock binding: handle to adc clock.
>> +            From common clock binding: handle to sclk_tsadc clock
>> +            if using Exynos3250.
>>   - clock-names        From common clock binding: Shall be "adc".
>> +            From common clock binding: Shall be "sclk_tsadc"
>> +            if using Exynos3250.
>>   - vdd-supply        VDD input supply.
>>
>>   Note: child nodes can be added for auto probing from device tree.
>> @@ -41,6 +47,20 @@ adc: adc@12D10000 {
>>       vdd-supply = <&buck5_reg>;
>>   };
>>
>> +If Exynos3250 uses ADC,
> 
> Please keep proper formatting:
> 
> Example: Node for ADC of Exynos3250 with additional special clock

Thanks, I'll fix it.

Best regards,
Chanwoo Choi
