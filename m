Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaCKCMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:12:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26970 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaCKCL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:11:58 -0400
X-AuditID: cbfee68e-b7f566d000002344-84-531e70ec3aac
Message-id: <531E74CF.7000602@samsung.com>
Date: Tue, 11 Mar 2014 11:28:31 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, sbkim73@samsung.com
Subject: Re: [PATCH] drivers: mfd: silence compiler warning in sec-core.c
References: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
 <20140310150700.GC13661@lee--X1>
In-reply-to: <20140310150700.GC13661@lee--X1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t8zY903BXLBBhdaZSzufz3KaHF51xw2
	i9PdrBYXV3xhcmDxuHNtD5vHvJOBHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVx4GoHU8FT
	nor3p1YzNzBu5epi5OSQEDCReHXmKguELSZx4d56ti5GLg4hgWWMEtNnrWaBKXp66w0TRGI6
	o0TDnC/MEM5rRolHWx6xg1TxCmhJrN+ymgnEZhFQlXjbsAWsm01AV+LJ+7nMILaoQJjEpul9
	rBD1ghI/Jt8DquHgEBFQkTj3xhwkzCzgIzHv9xawcmEBT4ntZzeBjRcSyJK4fmQB2EhOoJFL
	Tu9mhag3k3jUso4ZwpaX2LzmLdhtEgLr2CVWXX7ICHGPgMS3yYfAdkkIyEpsOsAM8ZikxMEV
	N1gmMIrNQnLRLCRjZyEZu4CReRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSCz17WC8ecD6
	EGMy0MqJzFKiyfnAWMwriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYxlbRaqyTMOrQy5KftGs1Lv6Mzfxy9KsP9YdGeq7xoL2x3lqWH7tzPIaNns
	kC29UGF+TuL8nvmuuQ7zoub2O5uqfZIP3mhzmf+9cPrndfIce2smc5jobNi0pSdZQu/s1Vsy
	kwSMbvppiX8vmrJs9bX1e44yKUg8v2/zxutq6oqTug+4n6sqNzIosRRnJBpqMRcVJwIAgrrn
	JrsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoO6bArlgg+2TJCzufz3KaHF51xw2
	i9PdrBYXV3xhcmDxuHNtD5vHvJOBHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYceBqB1PBU56K96dWMzcwbuXqYuTkkBAwkXh66w0ThC0mceHeerYu
	Ri4OIYHpjBINc74wQzivGSUebXnEDlLFK6AlsX7LarAOFgFVibcNW1hAbDYBXYkn7+cyg9ii
	AmESm6b3sULUC0r8mHwPqIaDQ0RAReLcG3OQMLOAj8S831vAyoUFPCW2n90ENl5IIEvi+pEF
	YCM5gUYuOb2bFaLeTOJRyzpmCFteYvOat8wTGAVmIdkwC0nZLCRlCxiZVzGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIER+ozqR2MKxssDjEKcDAq8fAG+MoFC7EmlhVX5h5ilOBgVhLhPW0B
	FOJNSaysSi3Kjy8qzUktPsSYDAyAicxSosn5wCSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbr
	QCGB9MSS1OzU1ILUIpgtTBycUg2MXlNNWbL7A0R2m5QGSca9edjRd/XRdOU/PBVqBzTi2Ns/
	/11jdFUqufDcwue/N51qzoi9WCoV2VDnlHw+LzRTQPt3y/ZJnLv8bq685XWbwflw4d8SvVM9
	R+32Ln10uZBh36Jl36rcJ++es8Pj6AzfHYqVOxcwuu/YKqmfdXyFIsNLo0dvY4WZlViKMxIN
	tZiLihMB+s+92xgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 12:07 AM, Lee Jones wrote:
>> When used 64bit compiler GCC warns as
>> drivers/mfd/sec-core.c:199:10: warning:
>> cast from pointer to integer of different size [-Wpointer-to-int-cast]
>>
>> This patch fixes this by type-casting "match->data" into "long" before
>> converting into "int"
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/mfd/sec-core.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
>> index a139798..2e7580bd 100644
>> --- a/drivers/mfd/sec-core.c
>> +++ b/drivers/mfd/sec-core.c
>> @@ -187,7 +187,7 @@ static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
>>   	if (i2c->dev.of_node) {
>>   		const struct of_device_id *match;
>>   		match = of_match_node(sec_dt_match, i2c->dev.of_node);
>> -		return (int)match->data;
>> +		return (int)(long)match->data;
> I think using an unsigned long would be better.

I could have done that but since "sec_i2c_get_driver_data" return type is
"int" for me it make sense to return "int", and it does not make much sense
to change this function signature as return value is used only for getting
variant type. Also same has been done in "max8998_i2c_get_driver_data", if
you still think it's better to typecast into "unsigned long" or
"kernel_ulong_t" please let me know I will change accordingly.

>>   	}
>>   #endif
>>   	return (int)id->driver_data;
> Doesn't this give you the same error?
>
No. As id->driver_data is of type "kernel_ulong_t" and not a pointer.


-- 
Best Regards,
Pankaj Dubey

