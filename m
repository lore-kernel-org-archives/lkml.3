Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaG1LSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:18:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60942 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaG1LSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:18:46 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-38-53d631934c17
Message-id: <53D63193.1020506@samsung.com>
Date: Mon, 28 Jul 2014 20:18:43 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: jic23@kernel.org, ch.naveen@samsung.com, arnd@arndb.de,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: adc: exynos_adc: add support for s3c64xx adc
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
 <1405995074-3271-2-git-send-email-cw00.choi@samsung.com>
 <53D549A2.1000900@gmx.de>
In-reply-to: <53D549A2.1000900@gmx.de>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkRHey4bVgg+uzFSz+TjrGbnH3+WFG
	i/lHzrFaPGhaxWTRu+Aqm8Wu/2+YLc42vWG32PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	1s94zeLA6/H71yRGjw8f4zw2repk89i8pN6jb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4Mv5M
	ncpScF+kovncO8YGxgbBLkZODgkBE4nLi44wQ9hiEhfurWcDsYUEljJKzHnlCVPzYN57xi5G
	LqD4IkaJub/Os0M4rxklPl1sAevgFdCS2P3nHSuIzSKgKjH1YScTiM0GFN//4gZYjahAmMTK
	6VdYIOoFJX5MvgdmiwioSDyb8YQJZCizwEEmif6H38FOEhbwkjg2bQvUttmMEh0vuhhBEpwC
	ahInf80DK2IW0JV417KZFcKWl9i85i0zSIOEQCOHRMfSP4wQJwlIfJt8CGgdB1BCVmLTAaif
	JSUOrrjBMoFRbBaSo2YhGTsLydgFjMyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQKj9/S/
	Z307GG8esD7EmAy0ciKzlGhyPjD680riDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDo23kJc0XLxanf9E2FONWdZ5uHbjLedFDpf2f/szu+1y3qEI5
	81GcZvRMiyVuIb8etO+N51N0rNmnukL1zibL+JtcsiK93my7NPSuBm8/YhVbeeK40z5ZeY+1
	uTee2KxwWP3wdEHWV8PmdtnkrRtlzJ8lxi8MmSdTsPR7Ee/NgONflh7WLnpWr8RSnJFoqMVc
	VJwIAEVwg9L0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd3JhteCDTbdELf4O+kYu8Xd54cZ
	LeYfOcdq8aBpFZNF74KrbBa7/r9htjjb9IbdYtPja6wWC9uWsFjMO/KOxeLyrjlsFjPO72Oy
	WD/jNYsDr8fvX5MYPT58jPPYtKqTzWPzknqPvi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/J
	zEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpUSaEsMacUKBSQWFyspG+HaUJo
	iJuuBUxjhK5vSBBcj5EBGkhYw5jxZ+pUloL7IhXN594xNjA2CHYxcnJICJhIPJj3nhHCFpO4
	cG89WxcjF4eQwCJGibm/zrNDOK8ZJT5dbGEDqeIV0JLY/ecdK4jNIqAqMfVhJxOIzQYU3//i
	BliNqECYxMrpV1gg6gUlfky+B2aLCKhIPJvxhAlkKLPAQSaJ/offmUESwgJeEsembYHaNptR
	ouNFF9hNnAJqEid/zQMrYhbQlXjXspkVwpaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjByeGZ1A7GlQ0WhxgFOBiVeHgtgq8GC7EmlhVX5h5ilOBg
	VhLhnap/LViINyWxsiq1KD++qDQntfgQoykwDCYyS4km5wMTV15JvKGxiZmRpZG5oYWRsbmS
	OO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBsYjz/su2l75HpyncKKRbcbUy5w+PwSnWPy0M5aa
	V/LxaJ3QPk/fBatOi6zYvlc9+t3rjj9F7rJ6OSa7Gu6/8vBPUu25fkIrdNFNtW0HazpbPx0+
	fT1TX6/HoeVkmKhj+OPH+/kMz20v35947B0j09EMCRm/J2tl9qyV6jV4FRmdbxJl2RCdxaPE
	UpyRaKjFXFScCABC/g4mJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 03:49 AM, Hartmut Knaack wrote:
> Chanwoo Choi schrieb:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The ADC in s3c64xx is almost the same as exynosv1, but
>> has a different 'select' method. Adding this here will be
>> helpful to move over the existing s3c64xx platform from the
>> legacy plat-samsung/adc driver to the new exynos-adc.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |  2 ++
>>  drivers/iio/adc/exynos_adc.c                       | 32 +++++++++++++++++++++-
>>  2 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> index 6d34891..b6e3989 100644
>> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> @@ -16,6 +16,8 @@ Required properties:
>>  				future controllers.
>>  			Must be "samsung,exynos3250-adc" for
>>  				controllers compatible with ADC of Exynos3250.
>> +			Must be "samsung,s3c6410-adc" for
>> +				the ADC in s3c6410 and compatibles
>>  - reg:			Contains ADC register address range (base address and
>>  			length) and the address of the phy enable register.
>>  - interrupts: 		Contains the interrupt information for the timer. The
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index 87e0895..05bdd2f12 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -40,12 +40,16 @@
>>  #include <linux/iio/machine.h>
>>  #include <linux/iio/driver.h>
>>  
>> -/* EXYNOS4412/5250 ADC_V1 registers definitions */
>> +/* S3C/EXYNOS4412/5250 ADC_V1 registers definitions */
>>  #define ADC_V1_CON(x)		((x) + 0x00)
>> +#define ADC_V1_TSC(x)		((x) + 0x04)
>>  #define ADC_V1_DLY(x)		((x) + 0x08)
>>  #define ADC_V1_DATX(x)		((x) + 0x0C)
>> +#define ADC_V1_DATY(x)		((x) + 0x10)
>> +#define ADC_V1_UPDN(x)		((x) + 0x14)
>>  #define ADC_V1_INTCLR(x)	((x) + 0x18)
>>  #define ADC_V1_MUX(x)		((x) + 0x1c)
>> +#define ADC_V1_CLRINTPNDNUP(x)	((x) + 0x20)
>>  
>>  /* Future ADC_V2 registers definitions */
>>  #define ADC_V2_CON1(x)		((x) + 0x00)
>> @@ -61,6 +65,9 @@
>>  #define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
>>  #define ADC_V1_CON_STANDBY	(1u << 2)
>>  
>> +/* Bit definitions for S3C2410 ADC */
>> +#define ADC_S3C2410_CON_SELMUX(x) (((x) & 7) <<3)
> There is a whitespace missing.

OK, I'll fix it.

Best Regards,
Chanwoo Choi

