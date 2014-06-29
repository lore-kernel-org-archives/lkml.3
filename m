Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaF2Xcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 19:32:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41426 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaF2Xct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 19:32:49 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-cd-53b0a21a4974
Message-id: <53B0A219.2000301@samsung.com>
Date: Mon, 30 Jun 2014 08:32:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv5 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
 <53AD54EC.2050606@gmail.com>
In-reply-to: <53AD54EC.2050606@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42JZI2JSoiu1aEOwwZW1hhZ3nx9mtJh/5Byr
	Rf+bhawW516tZLR40LSKyaJ3wVU2i7NNb9gt5h15x2JxedccNosZ5/cxWSy9fpHJYsL0tSwW
	b+9MZ7Fo3XuE3eLkn15Gi/UzXrNYrNr1h9FB0GPNvDWMHpf7epk8ds66y+6xcvkXNo/NK7Q8
	Nq3qZPO4c20Pm0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBl3HnFUvCTt2L5jxtMDYwt3F2M
	nBwSAiYSn5+uYIewxSQu3FvP1sXIxSEksJRR4sXlTSxdjBxgRdt3FUPEpzNKzN+8nxnCec0o
	Mef2G0aQIl4BLYkVDeUgg1gEVCWO9BxlBbHZgML7X9xgA7FFBcIkVk6/wgJi8woISvyYfA/M
	FhFQl/g2pZ8dZCazwDRmiWXzJ4BdJCwQIfH83l5mEFtIIEWic+opJhCbU0BToufBMbAFzAI6
	Evtbp7FB2PISm9e8BTtOQmAPh8SfY9vYIS4SkPg2+RDUN7ISmw4wQ3wsKXFwxQ2WCYxis5Dc
	NAvJ2FlIxi5gZF7FKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERj/p/89693BePuA9SHGZKCV
	E5mlRJPzgekjryTe0NjMyMLUxNTYyNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoY14nubC++wGf5LLPCQPmTRWzfb/MSXuGAXfxl0+tFlHedePf3zoRebpX5Bf4Rjk0Z
	0X1rmeZmnGzY6eQoZxwclaVn+mjO3Fst1seLwyy2fXomK7RDO6lzykurv+abHlYk6L7l17v3
	asGdVw5L5M/8ndl+77mvjOk+b91T7WFr2x78/vx7vs4ZJZbijERDLeai4kQAPuC1GRUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQV2pRRuCDR6f17C4+/wwo8X8I+dY
	LfrfLGS1OPdqJaPFg6ZVTBa9C66yWZxtesNuMe/IOxaLy7vmsFnMOL+PyWLp9YtMFhOmr2Wx
	eHtnOotF694j7BYn//QyWqyf8ZrFYtWuP4wOgh5r5q1h9Ljc18vksXPWXXaPlcu/sHlsXqHl
	sWlVJ5vHnWt72Dz6tqxi9Pi8SS6AM6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ
	0sJcSSEvMTfVVsnFJ0DXLTMH6BklhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGENY8adVywFP3krlv+4wdTA2MLdxcjBISFgIrF9V3EXIyeQKSZx4d56ti5GLg4hgemMEvM3
	72eGcF4zSsy5/YYRpIFXQEtiRUM5SAOLgKrEkZ6jrCA2G1B4/4sbbCC2qECYxMrpV1hAbF4B
	QYkfk++B2SIC6hLfpvSzg8xkFpjGLLFs/gR2kISwQITE83t7mUFsIYEUic6pp5hAbE4BTYme
	B8fAFjAL6Ejsb53GBmHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4OTyTGoH48oGi0OMAhyMSjy8N4zXBwuxJpYVV+YeYpTgYFYS4RWq2xAsxJuS
	WFmVWpQfX1Sak1p8iNEUGAQTmaVEk/OBiS+vJN7Q2MTMyNLI3NDCyNhcSZz3QKt1oJBAemJJ
	anZqakFqEUwfEwenVAOj8GNbFonFHouYPu/Wfji5vsdh4lT/e76rv608qJB4dUdj167T7sae
	M+/wf9yiKRpRkF9qIia+5Ngu51fyt6zq/9inmEwvn7rzD8dzrh81zkZbgxy+T1xzctGn+N0z
	OkR3rTCQbso/fm4r50nPoqBXorI7ffnfx/OK33Rgs3aqfhX6yTTss9JSJZbijERDLeai4kQA
	kC1rG0QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 06/27/2014 08:26 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 27.06.2014 06:30, Chanwoo Choi wrote:
>> Changes from v4:
>> - Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
>>   and remove enum variable of ADC version
>> - Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
>> - Add reviewed message by Naveen Krishna Chatradhi
>> - Add functions for ADC clock control
>>
>> Changes from v3:
>> - Add new 'exynos_adc_ops' structure to improve readability according to
>>  Tomasz Figa comment[1]
>>  [1] https://lkml.org/lkml/2014/4/16/238
>> - Add new 'exynos3250-adc-v2' compatible string to support Exynos3250 ADC
>> - Fix wrong compaitlbe string of ADC in Exynos3250 dtsi file
>>
>> Changes from v2:
>> - Check return value of clock function to deal with error exception
>> - Fix minor coding style to improve readability
>>
>> Changes from v1:
>> - Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
>> - Add a patch about DT binding documentation
>>
>> Chanwoo Choi (4):
>>   iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
>>   iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
>>   iio: devicetree: Add DT binding documentation for Exynos3250 ADC
>>   ARM: dts: Fix wrong compatible string for Exynos3250 ADC
>>
>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |  26 +-
>>  arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
>>  drivers/iio/adc/exynos_adc.c                       | 326 +++++++++++++++------
>>  3 files changed, 268 insertions(+), 88 deletions(-)
>>
> 
> For the whole series:
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi

