Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaG1LUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:20:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61082 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaG1LUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:20:16 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-8d-53d631edf96c
Message-id: <53D631ED.40803@samsung.com>
Date: Mon, 28 Jul 2014 20:20:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        heiko.stuebner@bq.com
Subject: Re: [PATCH 2/2] iio: adc: exynos_adc: Add support for S3C24xx ADC
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
 <1405995074-3271-3-git-send-email-cw00.choi@samsung.com>
 <5200888.DXoC06U953@wuerfel>
In-reply-to: <5200888.DXoC06U953@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsWyRsSkWPed4bVgg829zBZ/Jx1jt7j7/DCj
	xfwj51gt3p9dzWbxoGkVk0XvgqtsFmeb3rBbbHp8jdViYdsSFot5R96xWFzeNYfNYsb5fUwW
	62e8ZnHg9fj9axKjx4uW78wem1Z1snlsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBnr
	3x9gKdjPX/Fn9hrWBsa/3F2MnBwSAiYSx150sUDYYhIX7q1n62Lk4hASWMoosWrFM2aYol+H
	d7BCJBYxSnRd+MYM4bxmlGg/fpoRpIpXQEOi+8E5oHYODhYBVYlzu71BwmwCWhL7X9xgA7FF
	BcIkVk6/wgJRLijxY/I9MFtEQFFi6otnYDOZBU4ySeyc+JIJJCEs4CVxsfUC1EnzGCXuXT0P
	luAU0JRYsmIyWDezgI7E/tZpbBC2vMTmNW/BJkkItHJInOzZww6SYBEQkPg2+RALyHUSArIS
	mw5AvSYpcXDFDZYJjGKzkBw1C8nYWUjGLmBkXsUomlqQXFCclF5kpFecmFtcmpeul5yfu4kR
	GL+n/z3r28F484D1IcZkoJUTmaVEk/OB8Z9XEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLp
	iSWp2ampBalF8UWlOanFhxiZODilGhjDVs/Xn66wxWZd8xnftS7sz9fdXHOjdbVkr5j4b0Xv
	qId+s2y8wvceyRO0+rblytJeIUOhDx/8glVSd8TytWz/uIdHq83w1sc5tp/Cjwn4fistLjze
	sXf6lZDVbPdDZrz5k7lat1nO+fS64qkdN9JNxfwrg6YsipgRxXMoosOzIPuO25rZ7d1KLMUZ
	iYZazEXFiQDPMa259QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd23hteCDSb8tbT4O+kYu8Xd54cZ
	LeYfOcdq8f7sajaLB02rmCx6F1xlszjb9IbdYtPja6wWC9uWsFjMO/KOxeLyrjlsFjPO72Oy
	WD/jNYsDr8fvX5MYPV60fGf22LSqk81j85J6j74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYsf79AZaC/fwVf2avYW1g/MvdxcjJISFgIvHr8A5WCFtM
	4sK99WxdjFwcQgKLGCW6LnxjhnBeM0q0Hz/NCFLFK6Ah0f3gHFAVBweLgKrEud3eIGE2AS2J
	/S9usIHYogJhEiunX2GBKBeU+DH5HpgtIqAoMfXFM7CZzAInmSR2TnzJBJIQFvCSuNh6AWrz
	PEaJe1fPgyU4BTQllqyYDNbNLKAjsb91GhuELS+xec1b5gmMArOQLJmFpGwWkrIFjMyrGEVT
	C5ILipPSc430ihNzi0vz0vWS83M3MYKTwzPpHYyrGiwOMQpwMCrx8FoEXw0WYk0sK67MPcQo
	wcGsJMI7Vf9asBBvSmJlVWpRfnxRaU5q8SFGU2AQTGSWEk3OByauvJJ4Q2MTMyNLI3NDCyNj
	cyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjOrtUw21lxg5zzy9rv+X5IKUA3eszc5Nu/p6
	/7VIzxdyC1Y1TfxWprhmzYSMyzKrDlVLH9rv8z7R8/q3ovxpxhPPv1j5efILlxbnC7EPmWOL
	34Rk99XICH6Z2BTH4svOJWV9xfLkd1nOF9sP/lq4JJnba2FBwNZivj8FgQLK+/R+v/GIile8
	dVCJpTgj0VCLuag4EQAK2/njJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 05:39 PM, Arnd Bergmann wrote:
> On Tuesday 22 July 2014 11:11:14 Chanwoo Choi wrote:
>> This patch add support for s3c2410/s3c2416/s3c2440/s3c2443 ADC. The s3c24xx
>> is alomost same as ADCv1. But, There are a little difference as following:
>> - ADCMUX register address to select channel
>> - ADCDAT mask (10bit or 12bit ADC resolution according to SoC version)
> 
> Very good, thanks for doing this patch!
> 
> (adding Heiko to Cc, he's probably interested in seeing this as well.
> 
> One comment:
>  
>> @@ -101,12 +107,14 @@ struct exynos_adc {
>>  	struct completion	completion;
>>  
>>  	u32			value;
>> +	u32			value2;
>>  	unsigned int            version;
>>  };
>> ...
>> @@ -365,7 +448,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>  		ret = -ETIMEDOUT;
>>  	} else {
>>  		*val = info->value;
>> -		*val2 = 0;
>> +		*val2 = info->value2;
>>  		ret = IIO_VAL_INT;
>>  	}
>>  
>> @@ -377,9 +460,11 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>>  static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>>  {
>>  	struct exynos_adc *info = (struct exynos_adc *)dev_id;
>> +	u32 mask = info->data->mask;
>>  
>>  	/* Read value */
>> -	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
>> +	info->value = readl(ADC_V1_DATX(info->regs)) & mask;
>> +	info->value2 = readl(ADC_V1_DATY(info->regs)) & mask;
>>  
>>  	/* clear irq */
>>  	if (info->data->clear_irq)
> 
> If I understand it right, this would only be necessary if we want
> to do the touchscreen driver as a separate iio client using the
> in-kernel interfaces. As Jonathan Cameron commented, we probably
> don't want to do that though. Even if we do, it should be a separate
> patch and not mixed in with the s3c24xx support.

OK, I'll drop this sentence which reading DATY register.

Best Regards,
Chanwoo Choi

> 
> Aside from this:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> 	Arnd
> 

