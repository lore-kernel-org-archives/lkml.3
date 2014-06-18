Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbaFRIyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:54:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60942 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132AbaFRIye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:54:34 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-1a-53a153c71c93
Message-id: <53A153C6.1030703@samsung.com>
Date: Wed, 18 Jun 2014 17:54:30 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
 <1403058061-24271-4-git-send-email-cw00.choi@samsung.com>
 <53A14F4D.7080204@gmail.com>
In-reply-to: <53A14F4D.7080204@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42JZI2JSoHs8eGGwwdsTbBZ3nx9mtJh/5Byr
	Rf+bhawW516tZLR40LSKyaJ3wVU2i4VtS1gs5h15x2JxedccNosZ5/cxWSy9fpHJYsL0tSwW
	b+9MZ7Fo3XuE3eLkn15Gi/UzXrNYrNr1h9FB0GPNvDWMHpf7epk8ds66y+6xcvkXNo/NK7Q8
	Nq3qZPO4c20Pm0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBl7PlwjLlgqWjFn8sXmRoY2wS7
	GDk5JARMJGZs+8cKYYtJXLi3nq2LkYtDSGApo8TtNzsZYYp2ffzDApGYzijxZdYmKOc1o0Tf
	rJdgVbwCWhI3e7+zgdgsAqoSF9avALPZgOL7X9wAs0UFwiRWTr/CAlEvKPFj8j0wW0RAXeLb
	lH52EJtZYBqzRMssHxBbWCBW4vTJe+wQyxYwSiz8cBRsGaeApkRfdyMrRIOOxP7WaWwQtrzE
	5jVvmUEaJATWckicv9fCCHGRgMS3yYeAtnEAJWQlNh1ghnhNUuLgihssExjFZiG5aRaSsbOQ
	jF3AyLyKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzAJnP73rG8H480D1ocYk4FWTmSWEk3O
	ByaRvJJ4Q2MzIwtTE1NjI3NLM9KElcR5Fz1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	aPH23JPMFIkpNv7JVdpsxedPry5gaWm4o1Eqqll3quFKe8vrgpfcvjJfj03JC1yyQ05TYQGT
	WuTawx8ZUtwt7G5VZK37rF79YNH30swqZbuzjw6KP0jgjVh2QdvupmO+cP2Cb++l4o7tPdFr
	t647wuH84edn1tyILzxs2P1WOuA1F2v8TatHSizFGYmGWsxFxYkAGt7pQxgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQd1jwQuDDRY32VjcfX6Y0WL+kXOs
	Fv1vFrJanHu1ktHiQdMqJoveBVfZLBa2LWGxmHfkHYvF5V1z2CxmnN/HZLH0+kUmiwnT17JY
	vL0zncWide8RdouTf3oZLdbPeM1isWrXH0YHQY8189Ywelzu62Xy2DnrLrvHyuVf2Dw2r9Dy
	2LSqk83jzrU9bB59W1YxenzeJBfAGdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkD9IySQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMWPPh2PMBUtFK/5cvsjUwNgm2MXIySEhYCKx6+MfFghbTOLCvfVsXYxcHEIC0xklvsza
	xALhvGaU6Jv1khGkildAS+Jm73c2EJtFQFXiwvoVYDYbUHz/ixtgtqhAmMTK6VdYIOoFJX5M
	vgdmiwioS3yb0s8OYjMLTGOWaJnlA2ILC8RKnD55jx1i2QJGiYUfjoIt4xTQlOjrbmSFaNCR
	2N86jQ3ClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMEp5pn0DsZVDRaHGAU4GJV4eDlyFwQLsSaWFVfmHmKU4GBWEuGd4rkwWIg3JbGyKrUoP76o
	NCe1+BBjMjAIJjJLiSbnA9NfXkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwZnW//F+16mZT74FU3eUrXBtygpiMn9gGB1Xbzq4JZ21YdDQ1SKun9NYlrpWC
	GoyRTAufHivKU1e7uPb0zvyuLunjIeZWL/abh03WTpgfxn1BWDl3b8scM68Y3pxAq9t2q3yt
	HOQXePrncT+a57izV0K5R3LlQs9EMctcdR8/Q/YIjarGX0osxRmJhlrMRcWJAP/YyBV1AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 06/18/2014 05:35 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 18.06.2014 04:21, Chanwoo Choi wrote:
>> This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
>> special clock ('sclk_tsadc') for ADC which provide clock to internal ADC.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt   | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> index 5d49f2b..3a5af82 100644
>> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> @@ -14,6 +14,8 @@ Required properties:
>>  				for exynos4412/5250 controllers.
>>  			Must be "samsung,exynos-adc-v2" for
>>  				future controllers.
>> +			Must be "samsung,exynos3250-adc-v2" for
>> +				for exynos3250 controllers.
> 
> You might change the last line for:
> 
> for controllers compatible with ADC of Exynos3250.
> 
> This is to make it also account for possible future SoCs which need
> exactly the same handling.

OK, I'll modify it as folloiwng according to your comment:

>> +			Must be "samsung,exynos3250-adc-v2" for
>> +				for controllers compatible with ADC of Exynos3250.

> 
> 
>>  - reg:			Contains ADC register address range (base address and
>>  			length) and the address of the phy enable register.
>>  - interrupts: 		Contains the interrupt information for the timer. The
>> @@ -21,7 +23,11 @@ Required properties:
>>  			the Samsung device uses.
>>  - #io-channel-cells = <1>; As ADC has multiple outputs
>>  - clocks		From common clock binding: handle to adc clock.
>> +			From common clock binding: handle to sclk_tsadc clock
>> +			if using Exynos3250.
> 
> This is not clear. It might sound like the "sclk_tsadc" clock is used on
> Exynos3250 and "adc" on remaining SoCs. I'd write this simply as:
> 
>>From common clock bindings: handles to clocks specified in "clock-names"
> property, in the same order.

I'll modify it.

> 
>>  - clock-names		From common clock binding: Shall be "adc".
>> +			From common clock binding: Shall be "sclk_tsadc"
>> +			if using Exynos3250.
> 
> This is also not clear. I'd recommend something like:
> 
>>From common clock bindings: list of clock input names used by ADC block:
>     - "adc" : ADC bus clock,
>     - "sclk_tsadc" : ADC special clock (only for Exynos3250 and
> compatible ADC blocks).

I'll modify it.

Best Regards,
Chanwoo Choi
