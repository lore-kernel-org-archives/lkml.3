Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaF3Bvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:51:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47991 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaF3Bvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:51:46 -0400
X-AuditID: cbfee68f-b7fef6d000003970-97-53b0c2ace6cf
Message-id: <53B0C2AB.4030201@samsung.com>
Date: Mon, 30 Jun 2014 10:51:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: Jonathan Cameron <jic23@kernel.org>, ch.naveen@samsung.com,
        t.figa@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv5 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
 <53AFFD69.8060702@kernel.org>
In-reply-to: <53AFFD69.8060702@kernel.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsWyRsSkUHfNoQ3BBm83cFncfX6Y0WL+kXOs
	Fv1vFrJanHu1ktHiQdMqJoveBVfZLM42vWG3mHfkHYvF5V1z2CxmnN/HZLH0+kUmiwnT17JY
	vL0zncWide8RdouTf3oZLdbPeM3iIOCxZt4aRo/Lfb1MHiuXf2Hz2LxCy2PTqk42jzvX9rB5
	9G1ZxejxeZNcAEcUl01Kak5mWWqRvl0CV8bVZ/vYCqbyV7x++oO1gfEPdxcjJ4eEgInE7l2P
	WSBsMYkL99azgdhCAksZJTreWcDUPGjYDBTnAoovYpR4t+0DM4TzmlFi84z7zCBVvAJaEjeW
	3GMEsVkEVCVeHpoOFmcDiu9/cQNsqqhAmMTK6VdYIOoFJX5MvgdmiwhISjQ1/AEbyiwwiVni
	ytMXYIOEBSIknt/bC5TgANqWKtG3yQAkzAk089GFuawgNrOAjsT+1mlsELa8xOY1b8HmSAgs
	5JB40fIc6iABiW+TD7GAzJEQkJXYdIAZ4jNJiYMrbrBMYBSbheSkWUjGzkIydgEj8ypG0dSC
	5ILipPQiY73ixNzi0rx0veT83E2MwGg//e9Z/w7GuwesDzEmA62cyCwlmpwPTBZ5JfGGxmZG
	FqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRL9Igr2h78+ad
	mSeX7Njv0t+2i+NVkENt3u9e25pq7z+a+juzDvlbzpj8aUVdv7nVnctGaRKussqZbvdki/pn
	JfjN0VJQlYh/x3om/+qbJbzsir3qZoIMmUERE5WZKg8Fpa/QeKFftHNNlNnfa9djKvnFPRaV
	Fzy37/0oZ/1tybRGnYcMd5RYijMSDbWYi4oTATL57KAMAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd01hzYEG7x7zWhx9/lhRov5R86x
	WvS/Wchqce7VSkaLB02rmCx6F1xlszjb9IbdYt6RdywWl3fNYbOYcX4fk8XS6xeZLCZMX8ti
	8fbOdBaL1r1H2C1O/ulltFg/4zWLg4DHmnlrGD0u9/Uyeaxc/oXNY/MKLY9NqzrZPO5c28Pm
	0bdlFaPH501yARxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZK
	Lj4Bum6ZOUAvKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzrj7bx1Yw
	lb/i9dMfrA2Mf7i7GDk5JARMJB40bGaDsMUkLtxbD2RzcQgJLGKUeLftAzOE85pRYvOM+8wg
	VbwCWhI3ltxjBLFZBFQlXh6aDhZnA4rvf3EDbJKoQJjEyulXWCDqBSV+TL4HZosISEo0NfwB
	G8osMIlZ4srTF2CDhAUiJJ7f2wuU4ADalirRt8kAJMwJNPPRhbmsIDazgI7E/tZpbBC2vMTm
	NW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4mz6R2MK5s
	sDjEKMDBqMTDq7FsQ7AQa2JZcWXuIUYJDmYlEV6hOqAQb0piZVVqUX58UWlOavEhRlNgCExk
	lhJNzgcmurySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYwxEwJ4
	9vXe3H0xo+Laq+4VHEyPa/8xnflucfVL63U73oqw61OnnRJYbll8+ru3nVdcSemcmrunHQ7v
	19lqOL1K1LRarjpztX4F/4G3YgFM0swzo/bHszhNn3nT+IH2+1szs9ytf6Yt2ppXact2Z9v0
	yFe3qm+GT+w0eX1Gs0+k2tXn1tvlq24qsRRnJBpqMRcVJwIAffegmTwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

On 06/29/2014 08:50 PM, Jonathan Cameron wrote:
> On 27/06/14 05:30, Chanwoo Choi wrote:
>> Changes from v4:
>> - Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
>>    and remove enum variable of ADC version
>> - Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
>> - Add reviewed message by Naveen Krishna Chatradhi
>> - Add functions for ADC clock control
>>
>> Changes from v3:
>> - Add new 'exynos_adc_ops' structure to improve readability according to
>>   Tomasz Figa comment[1]
>>   [1] https://lkml.org/lkml/2014/4/16/238
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
>>    iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
>>    iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
>>    iio: devicetree: Add DT binding documentation for Exynos3250 ADC
>>    ARM: dts: Fix wrong compatible string for Exynos3250 ADC
>>
>>   .../devicetree/bindings/arm/samsung/exynos-adc.txt |  26 +-
>>   arch/arm/boot/dts/exynos3250.dtsi                  |   4 +-
>>   drivers/iio/adc/exynos_adc.c                       | 326 +++++++++++++++------
>>   3 files changed, 268 insertions(+), 88 deletions(-)
>>
> I am happy with this series, but given it touches some exynos bindings, I would
> like an ack from Kukjin Kim (or according to MAINTAINERS Ben Dooks) before taking it
> all through IIO.

Could you please review this patchset about exynos dtsi and bindings?

Best Regards,
Chanwoo Choi



