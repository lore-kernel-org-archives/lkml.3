Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaJ2CFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:05:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57014 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJ2CFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:05:06 -0400
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
X-AuditID: cbfee691-f79b86d000004a5a-8b-54504b4e5672
Content-transfer-encoding: 8BIT
Message-id: <54504B4E.2070208@samsung.com>
Date: Wed, 29 Oct 2014 11:05:02 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: =?EUC-KR?B?wK/H0bDm?= <hankyung.yu@lge.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chanho Min'" <chanho.min@lge.com>, "'Chris Ball'" <chris@printf.net>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "'Seungwon Jeon'" <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'HyoJun Im'" <hyojun.im@lge.com>, gunho.lee@lge.com,
        "'CPGS'" <cpgs@samsung.com>
Subject: Re: [PATCH] mmc:core: fix hs400 timing selection
References: <1413946555-1266-1-git-send-email-chanho.min@lge.com>
 <544F1DB3.9050204@samsung.com> <00b601cff30a$3c57e710$b507b530$@lge.com>
In-reply-to: <00b601cff30a$3c57e710$b507b530$@lge.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsWyRsSkUNfPOyDE4MlyK4uP1y6wW0y4vJ3R
	4uUhTYsL0xYyW+x7P4XR4vP1JnaLG7/aWC0u75rDZnHkfz+jxYf7F5ktjq8Nd+D26Hp7hcnj
	zrU9bB43Xi1k8ujbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mk68fMhVMlK24s8WsgXGSeBcj
	J4eEgInEk+brTBC2mMSFe+vZuhi5OIQEljJKzF02ixWm6EvHSUYQW0hgOqPEsReKIDavgKDE
	j8n3WLoYOTiYBeQljlzKBgkzC2hITH19Gqr8NaNExxZriHItid9rl7CA2CwCqhIf1p0G28sm
	oCOx/dtxMFtUIEziUNs8MFtE4DOjxMNdMRAzexglDp4UA7GFBSwl+m9uYYe4Eyjef+0dG0iC
	U8BMoufvP0aQhITAS3aJVc9mQ20TkPg2+RDYoRICshKbDjBD/CUpcXDFDZYJjGKzkLwzC+Gd
	WUjeWcDIvIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMCpP/3s2cQfj/QPWhxgFOBiVeHgN
	HvqFCLEmlhVX5h5iNAU6YiKzlGhyPjD280riDY3NjCxMTUyNjcwtzZTEeXWkfwYLCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYJSIk9l2qPtjkZtZRIEDz3abb0tm/nhzhcGrcp4C4xXHPbpx
	sTyHOS/tucU6p0WA2eFDl34Px5Kpz1+++rwte8LMw/yi70x+R6x0+VL2yuhRbmcP6/GZPkXr
	s+p+tjOyc8yNvSefvkoy7SC/3rr6mTrPu36L9kxYobdgtqV/WNxptz9tJt95jZRYijMSDbWY
	i4oTAfeZHE/FAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV0/74AQg5ZfBhYfr11gt5hweTuj
	xctDmhYXpi1kttj3fgqjxefrTewWN361sVpc3jWHzeLI/35Giw/3LzJbHF8b7sDt0fX2CpPH
	nWt72DxuvFrI5NG3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM06+fshUMFG24s4WswbGSeJdjJwcEgImEl86TjJC2GISF+6tZwOxhQSmM0oce6EIYvMK
	CEr8mHyPpYuRg4NZQF7iyKVskDCzgIbE1NenGSHKXzNKdGyxhijXkvi9dgkLiM0ioCrxYd1p
	JhCbTUBHYvu342C2qECYxKG2eWC2iMBnRomHu2IgZvYwShw8KQZiCwtYSvTf3MLexcgFNB8o
	3n/tHdhtnAJmEj1//zFOYBSYheS8WQjnzUJy3gJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwTH/THoH46oGi0OMAhyMSjy8hg/9QoRYE8uKK3MPMUpwMCuJ8O4wDwgR4k1JrKxKLcqP
	LyrNSS0+xGgK9N1EZinR5HxgOsoriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliSmp2aWpBa
	BNPHxMEp1cBov9Rj/dJ7zR//du6JZdtz+vD32ZaJk9p/HrSPmbd8mtCeor9xxauau86wGR4z
	2STjMjNVQIH34Raet9sPOLcJsnkUZbzouBiRcUlkonzUgRCpqHu/AzIWNy3RKFvFd0T9YHtO
	5Mbi1RbJbdK/n6m9mB176PTrmpWsGjuYnmiFb+DRidSOludVYinOSDTUYi4qTgQAyjj9rQ8D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/29/2014 08:52 AM, À¯ÇÑ°æ wrote:
> Hi I'm Hankyung Yu
> 
> I will answer instead Chanho Min
> 
> After mmc_set_timing(card->host, MMC_TIMING_MMC_HS); 
> 
> Host controller set to SDR transfer
> 
> so is to change to a DDR transfer mode.

As commit message was mentioned, I have checked the JEDEC v5.01 spec(6.6.5).
There is no mention that mode needs to change to DDR mode.

And i know HS400 mode is only support the 8bit buswidth.
If HS200 mode was set to 4bit buswidth, is HS400 working fine?

Best Regards,
Jaehoon Chung

> 
> 
> -----Original Message-----
> From: Jaehoon Chung [mailto:jh80.chung@samsung.com] 
> Sent: Tuesday, October 28, 2014 1:38 PM
> To: Chanho Min; Chris Ball; Ulf Hansson; Seungwon Jeon; Jaehoon Chung
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; HyoJun Im;
> gunho.lee@lge.com; Hankyung Yu; CPGS
> Subject: Re: [PATCH] mmc:core: fix hs400 timing selection
> 
> Hi, Chanho.
> 
> On 10/22/2014 11:55 AM, Chanho Min wrote:
>> According to JEDEC v5.01 spec (6.6.5), In order to switch to HS400 
>> mode, host should perform the following steps.
>>
>>  1. HS200 mode selection completed
>>  2. Set HS_TIMING to 0x01(High Speed)
>>  3. Host changes frequency to =< 52MHz  4. Set the bus width to DDR 
>> 8bit (CMD6)  5. Host may read Driver Strength (CMD8)  6. Set HS_TIMING 
>> to 0x03 (HS400)
>>
>> In current implementation, the order of 2 and 3 is reversed.
>> The HS_TIMING field should be set to 0x1 before the clock frequency is 
>> set to a value not greater than 52 MHz. Otherwise, Initialization of 
>> timing can be failed. Also, the host contoller's UHS timing mode 
>> should be set to DDR50 after the bus width is set to DDR 8bit.
>>
>> Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
>> Signed-off-by: Chanho Min <chanho.min@lge.com>
>> ---
>>  drivers/mmc/core/mmc.c |   13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c index 
>> a301a78..52f78e0 100644
>> --- a/drivers/mmc/core/mmc.c
>> +++ b/drivers/mmc/core/mmc.c
>> @@ -1061,9 +1061,6 @@ static int mmc_select_hs400(struct mmc_card *card)
>>  	 * Before switching to dual data rate operation for HS400,
>>  	 * it is required to convert from HS200 mode to HS mode.
>>  	 */
>> -	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
>> -	mmc_set_bus_speed(card);
>> -
>>  	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS,
>>  			   card->ext_csd.generic_cmd6_time, @@ -1074,6
> +1071,14 @@ static 
>> int mmc_select_hs400(struct mmc_card *card)
>>  		return err;
>>  	}
>>  
>> +	/*
>> +	 * According to JEDEC v5.01 spec (6.6.5), Clock frequency should
>> +	 * be set to a value not greater than 52MHz after the HS_TIMING
>> +	 * field is set to 0x1.
>> +	 */
>> +	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
>> +	mmc_set_bus_speed(card);
>> +
>>  	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			 EXT_CSD_BUS_WIDTH,
>>  			 EXT_CSD_DDR_BUS_WIDTH_8,
>> @@ -1084,6 +1089,8 @@ static int mmc_select_hs400(struct mmc_card *card)
>>  		return err;
>>  	}
>>  
>> +	mmc_set_timing(card->host, MMC_TIMING_MMC_DDR52);
>> +
> 
> I didn't know why timing is set to ddr50.
> 
> Best Regards,
> Jaehoon Chung
> 
>>  	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>>  			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS400,
>>  			   card->ext_csd.generic_cmd6_time,
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

