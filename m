Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaGOEOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:14:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35452 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaGOEOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:14:48 -0400
X-AuditID: cbfee68f-b7fef6d000003970-a0-53c4aab5a2bf
Message-id: <53C4AAB5.4070700@samsung.com>
Date: Tue, 15 Jul 2014 13:14:45 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
        Chris Ball <chris@printf.net>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, ulf.hansson@linaro.org,
        tgih.jun@samsung.com, aaron.lu@intel.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jackey.shen@amd.com,
        gregkh@linuxfoundation.org
Subject: Re: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com>
 <53B57B23.4020607@linux.intel.com> <53B61403.7040602@samsung.com>
 <53B968EB.60401@linux.intel.com> <53BC164E.4040900@linux.intel.com>
 <86zjgcjckz.fsf@void.printf.net> <53C497FD.2070000@linux.intel.com>
In-reply-to: <53C497FD.2070000@linux.intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkRHfrqiPBBv9vS1hs6vvNZjHh8nZG
	i+bF64GsexNZLW78amO1uLxrDpvFkf/9jBYf7l9ktji+Ntyi/dJFZgcuj9ZLf9k8Fu95yeRx
	59oeNo95JwM99s9dw+5x49VCJo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DK2Nq4malgvUDF
	1IZDbA2M03m7GDk5JARMJPae+88MYYtJXLi3nq2LkYtDSGApo8TO1afZYYqOPjnEApFYxCix
	bcJ9VgjnNaPEwvZusHZeAS2Jhqt/GUFsFgFVibkNfWDdbAI6Etu/HWcCsUUFwiQOtc1jgqgX
	lPgx+R4LiC0i4C+x/fw1ZpChzAK3GCXad+0FuoODQ1hARWLuW36IZf8YJRb1PwZr4BTQl2iZ
	8gjMZgZasL91GhuELS+xec1bsEESAj/ZJQ5dvcQKcZGAxLfJID9wACVkJTYdgPpZUuLgihss
	ExjFZiG5aRaSsbOQjF3AyLyKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzBmT/971r+D8e4B
	60OMyUArJzJLiSbnA2M+ryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwRt31X7Vxy7HzjdtEM9V+PFG9YFK9jLFQad9BvoSJh4XOJR0OZXjX0xS+
	/2RhbeamH+w/nvOpb3C7ez06e7uZ2ZlOocWbJkd8WN66KCZphtvP+yZXN03xulEc/atM5Vbs
	rIsVPrJKl3/Xbt2aksO7X+q5qqXmKYVPlwp3yZusN/zxa95Cs6J/B5VYijMSDbWYi4oTAV1b
	p7XvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7WVUeCDX6uFrDY1PebzWLC5e2M
	Fs2L1wNZ9yayWtz41cZqcXnXHDaLI//7GS0+3L/IbHF8bbhF+6WLzA5cHq2X/rJ5LN7zksnj
	zrU9bB7zTgZ67J+7ht3jxquFTB59W1YxenzeJBfAEdXAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKOSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYI
	Xd+QILgeIwM0kLCGMWNr42amgvUCFVMbDrE1ME7n7WLk5JAQMJE4+uQQC4QtJnHh3nq2LkYu
	DiGBRYwS2ybcZ4VwXjNKLGzvZgap4hXQkmi4+pcRxGYRUJWY29DHDmKzCehIbP92nAnEFhUI
	kzjUNo8Jol5Q4sfke2AbRAT8Jbafv8YMMpRZ4BajRPuuvUDrODiEBVQk5r7lh1j2j1FiUf9j
	sAZOAX2JlimPwGxmoAX7W6exQdjyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjOCE8k9rBuLLB4hCjAAejEg+vxLvDwUKsiWXFlbmHGCU4mJVEeD0W
	HwkW4k1JrKxKLcqPLyrNSS0+xGgKDIKJzFKiyfnAZJVXEm9obGJmZGlkbmhhZGyuJM57oNU6
	UEggPbEkNTs1tSC1CKaPiYNTqoHxWPDVGRzRfZGv933w+9hzM+10oHFz/PJnE7ZZqmz51pV8
	nOezIM9JDquH1+rNRXadP54o+aD0l/Bu/bnT96dqbuWp0zu8d7LGC91mUW+z6y6zp9nt6+Ep
	z39UUzQ5/OodTRP2Z56njNjs7H8oZEfHrHgqtuZ9YOOvQ0o6ARc7s9QYXrblMokrsRRnJBpq
	MRcVJwIA+5nkhR4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 11:54 AM, Fu, Zhonghui wrote:
> 
> Hi,
> 
> The data type of "host" is "struct mmc_host", and there is not "quirks" member in this structure.
Sorry for wrong typo.
You use the "host->caps2" instead of "host->quirks".


Best Regards,
Jaehoon Chung
> 
> 
> Thanks,
> Zhonghui
> 
> On 2014/7/14 21:26, Chris Ball wrote:
>> Hi Zhonghui,
>>
>> On Tue, Jul 08 2014, Fu, Zhonghui wrote:
>>> Why add "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" ?  How to fix this bug?
>>>
>>> Could you please give out some idea about this bug?
>> Jaehoon already gave you a patch to fix this bug.  Here it is again in
>> proper patch form.  Please can you test it and let us know whether it
>> fixes the crash?  Thanks.
>>
>>
>> From: Chris Ball <chris@printf.net>
>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>
>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>> the use of our own custom threaded IRQ handler, but left in an
>> unconditional wake_up_process() on that handler at resume-time.
>>
>> Reported-by: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
>> [Patch suggested by Jaehoon Chung]
>> Signed-off-by: Chris Ball <chris@printf.net>
>> ---
>>  drivers/mmc/core/sdio.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>> index e636d9e..2a128e2 100644
>> --- a/drivers/mmc/core/sdio.c
>> +++ b/drivers/mmc/core/sdio.c
>> @@ -992,7 +992,8 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>  		}
>>  	}
>>  
>> -	if (!err && host->sdio_irqs)
>> +	if (!err && host->sdio_irqs &&
>> +	    !(host->quirks & MMC_CAP2_SDIO_IRQ_NOTHREAD))
>>  		wake_up_process(host->sdio_irq_thread);
>>  	mmc_release_host(host);
>>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

