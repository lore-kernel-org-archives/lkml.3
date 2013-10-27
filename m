Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3J0XvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 19:51:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34657 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3J0XvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 19:51:14 -0400
X-AuditID: cbfee68f-b7f836d000001b39-a7-526da6f09ebe
Message-id: <526DA6F0.6060005@samsung.com>
Date: Mon, 28 Oct 2013 08:51:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 2/4] charger-manager: Use IIO subsystem to read battery
 temperature instead of legacy method
References: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
 <1382446317-32613-3-git-send-email-cw00.choi@samsung.com>
 <20131027111739.GC2437@xo-6d-61-c0.localdomain>
In-reply-to: <20131027111739.GC2437@xo-6d-61-c0.localdomain>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkWPfDstwgg29nFCwObtW0mH/kHKvF
	xJWTmS0O/NnBaHG26Q27xeVdc9gsbjeuYLO4e+oom8XhFQeYHDg9Fny+wu4xof8To8fmFVoe
	d67tYfPo27KK0WPF6u/sHp83yQWwR3HZpKTmZJalFunbJXBltN+7wlwwRaDicOM5xgbGGzxd
	jJwcEgImEivWnGSHsMUkLtxbz9bFyMUhJLCUUaKlYw0rTNGpG3ehEosYJd4s/ckI4bxilJh7
	aj4zSBWvgJbE2d3fwWwWAVWJjdfawcayAcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7YLaIgLzE
	1r4VzCBDmQXOMUr0PNvNCJIQFiiSWPLkIzvEts2MEqdndINN4hSwkfj6tA/MZhbQkdjfOg3K
	lpfYvOYt2CQJgZfsEvv3TWGDOElA4tvkQ0DrOIASshKbDjBD/CYpcXDFDZYJjGKzkBw1C8nY
	WUjGLmBkXsUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGKGn/z3r38F494D1IcZkoJUTmaVE
	k/OBEZ5XEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhhPnrnDksD8ZZnAssfXbkpPerNx0upLE0VTCr9k6PpfEpXXOLer69Jqq3tBix8s0V5gKjPP
	5dKTKWwtHYo3/i7TaFr4viY0f9fa5g8fGatDmRec0Lnj8DpLZ8rCvlz+l6E259Ifd7brfsxg
	vllY7LHu8b6IYJcJzW51PwIFrK84v5DvsuFTrT6nxFKckWioxVxUnAgAvHRBNuYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAd0Py3KDDK5MlLQ4uFXTYv6Rc6wW
	E1dOZrY48GcHo8XZpjfsFpd3zWGzuN24gs3i7qmjbBaHVxxgcuD0WPD5CrvHhP5PjB6bV2h5
	3Lm2h82jb8sqRo8Vq7+ze3zeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMaP93hXmgikCFYcbzzE2MN7g6WLk5JAQMJE4deMuG4QtJnHh3nogm4tDSGARo8SbpT8Z
	IZxXjBJzT81nBqniFdCSOLv7O5jNIqAqsfFaOzuIzQYU3//iBtgkUYEwiZXTr7BA1AtK/Jh8
	D8wWEZCX2Nq3ghlkKLPAOUaJnme7GUESwgJFEkuefGSH2LaZUeL0jG6wSZwCNhJfn/aB2cwC
	OhL7W6dB2fISm9e8ZZ7AKDALyZJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM4/p9J72Bc1WBxiFGAg1GJh1cjNCdIiDWxrLgy9xCjBAezkggvX0VukBBvSmJlVWpRfnxR
	aU5q8SHGZGAYTGSWEk3OB6amvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphak
	FsFsYeLglGpgrKjY+/e39td7dnmdC9emFV55uXnhfFspwyt/9DoK7GoSbdSPmiZtvigyMX9z
	S/hpiaWnDe4JP39rXfqXOT+Rz+Ba2uvHD87LMa8yDKhccKNY6rxU/O7Dm6Vemr/YomiusGXh
	la2fZOPUM8ICPIJc5jUJLfhRLTL/0rEjUTfMnrv6aEtf7xIOV2Ipzkg01GIuKk4EANz7M01D	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 10/27/2013 08:17 PM, Pavel Machek wrote:
> Hi!
> 
>> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
>> index e6f92b4..6700191 100644
>> --- a/drivers/power/Kconfig
>> +++ b/drivers/power/Kconfig
>> @@ -309,6 +309,7 @@ config CHARGER_MANAGER
>>  	bool "Battery charger manager for multiple chargers"
>>  	depends on REGULATOR && RTC_CLASS
>>  	select EXTCON
>> +	select IIO
>>  	help
>>            Say Y to enable charger-manager support, which allows multiple
>>            chargers attached to a battery and multiple batteries attached to a
> 
> Umm. Are there charger-manager users that don't have temperature sensor on IIO?

I'll remove tightly coupled dependency between IIO and Charger-manager.

> 
>> +	if (desc->channel) {
>> +		temp = iio_read_channel_raw(desc->channel, last_temp_mC);
>> +
>> +		/*
>> +		 * The charger-manager use IIO subsystem to read ADC raw data
>> +		 * from IIO ADC device drvier. The each device driver has
>> +		 * own non-standard ADC table. If user of charger-manager
>> +		 * would like to get correct temperature value, have to convert
>> +		 * 'last_temp_mC' variable according to proper calculation
>> +		 * method and own ADC table.
>> +		 */
>> +
>> +		if (*last_temp_mC >= desc->iio_adc_overheat)
>> +			temp = CM_TEMP_NORMAL;	/* Overheat */
>> +		else if (*last_temp_mC <= desc->iio_adc_cold)
>> +			temp = CM_TEMP_COLD;	/* Cold */
>> +		else
>> +			temp = CM_TEMP_NORMAL;	/* Normal */
> 
> Something is definitely wrong here.

I'll fix it as below:
temp = CM_TEMP_NORMAL;	/* Overheat */
-> temp = CM_TEMP_OVERHEAT;	/* Overheat */

Also, as you mentioned, this patch haven't included the converting sequence
from ADC value to correct temperature because currently iio driver haven't
support this feature. So, I'm going to discuss this issue on following mailing thread:
- https://lkml.org/lkml/2013/10/26/42

If I find proper method to get temperature on IIO driver, I'll modify it.

Thanks for your comment.

Best Regards,
Chanwoo Choi

