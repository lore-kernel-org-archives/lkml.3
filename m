Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbaGOEku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:40:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53452 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaGOEkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:40:46 -0400
X-AuditID: cbfee68f-b7fef6d000003970-fc-53c4b0cb94df
Message-id: <53C4B0CA.1020504@samsung.com>
Date: Tue, 15 Jul 2014 13:40:42 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Jaehoon Chung <jh80.chung@samsung.com>,
        "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
        Chris Ball <chris@printf.net>
Cc: ulf.hansson@linaro.org, tgih.jun@samsung.com, aaron.lu@intel.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackey.shen@amd.com, gregkh@linuxfoundation.org
Subject: Re: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com>
 <53B57B23.4020607@linux.intel.com> <53B61403.7040602@samsung.com>
 <53B968EB.60401@linux.intel.com> <53BC164E.4040900@linux.intel.com>
 <86zjgcjckz.fsf@void.printf.net> <53C497FD.2070000@linux.intel.com>
 <53C4AAB5.4070700@samsung.com>
In-reply-to: <53C4AAB5.4070700@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkQPf0hiPBBndm8Fts6vvNZjHh8nZG
	i+bF64GsexNZLW78amO1uLxrDpvFkf/9jBYf7l9ktji+Ntyi/dJFZgcuj9ZLf9k8Fu95yeRx
	59oeNo95JwM99s9dw+5x49VCJo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DK2HP8HnPBXOmK
	y0dXsTUwLhXrYuTkkBAwkfh5ZQo7hC0mceHeerYuRi4OIYGljBKzP91ihCma8GAFE0RiEaPE
	w/VbGSGc14wS1yZvZgKp4hXQknh3rIUFxGYRUJX40XqSDcRmE9CR2P7tOFiNqECYxKG2eVD1
	ghI/Jt8DqxcRqJTovjsLbDWzwCZGiWVNN5i7GDk4hAVUJOa+5YdYNp9J4sexF2AncQpoSyyZ
	2wp2NzPQgv2t09ggbHmJzWveMoM0SAj8ZJeY//kMI8RFAhLfJh9iARkqISArsekAM8RrkhIH
	V9xgmcAoNgvJTbOQjJ2FZOwCRuZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIExe/rfs/4d
	jHcPWB9iTAZaOZFZSjQ5HxjzeSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qB0ftJRm77R9nUQO3zF3+5PmLbW7ND9iav3vQaZtbnqZFL/bqOxmh5
	iidxzXtxauKpPzV9JyKv8Wvmhx9xnrNFvLbqiNaJDV8ulv+ydA2dqGX388bJLJ9E1kJFx13H
	fzbnOfwMupvmOLH5yKknky87Rr3wUpW983CO1e1Ln7ey2ujf/VUzx5ZLUImlOCPRUIu5qDgR
	ANLZAeTvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7pDUeCDd7tZ7HY1PebzWLC5e2M
	Fs2L1wNZ9yayWtz41cZqcXnXHDaLI//7GS0+3L/IbHF8bbhF+6WLzA5cHq2X/rJ5LN7zksnj
	zrU9bB7zTgZ67J+7ht3jxquFTB59W1YxenzeJBfAEdXAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKOSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYI
	Xd+QILgeIwM0kLCGMWPP8XvMBXOlKy4fXcXWwLhUrIuRk0NCwERiwoMVTBC2mMSFe+vZuhi5
	OIQEFjFKPFy/lRHCec0ocW3yZrAqXgEtiXfHWlhAbBYBVYkfrSfZQGw2AR2J7d+Og9WICoRJ
	HGqbB1UvKPFj8j2wehGBSonuu7PANjALbGKUWNZ0g7mLkYNDWEBFYu5bfohl85kkfhx7wQjS
	wCmgLbFkbis7iM0MtGB/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEJ4RnUjsYVzZYHGIU4GBU4uGVeHc4WIg1say4MvcQowQHs5IIr8fi
	I8FCvCmJlVWpRfnxRaU5qcWHGE2BQTCRWUo0OR+YrPJK4g2NTcyMLI3MDS2MjM2VxHkPtFoH
	CgmkJ5akZqemFqQWwfQxcXBKNTDOlVP9uCE+q6xye+nhFQ93TF2xMdN+c8Sy5bw3JDSXzpuw
	vFmFcW38l2b+Q+nTDwizf1DMeOQ5d31oSf6VWsbVDL/Pn63ecuH/5ePbzd81mv2e/EavnMNi
	R4i+bMkOjZBs2/NHMtvWNYcvs0txft9VvrfOeeu7pAeN6rM/JS47Z220RUnveslFJZbijERD
	Leai4kQAV71DEh4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <chris@printf.net>
Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread

781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
the use of our own custom threaded IRQ handler, but left in an
unconditional wake_up_process() on that handler at resume-time.

Reported-by: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
[Patch suggested by Jaehoon Chung]
Signed-off-by: Chris Ball <chris@printf.net>
---
 drivers/mmc/core/sdio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index e636d9e..11cc4e0 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -992,7 +992,8 @@ static int mmc_sdio_resume(struct mmc_host *host)
 		}
 	}
 
-	if (!err && host->sdio_irqs)
+	if (!err && host->sdio_irqs &&
+			!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD))
 		wake_up_process(host->sdio_irq_thread);
 	mmc_release_host(host);
 
-- 
1.7.9.5

On 07/15/2014 01:14 PM, Jaehoon Chung wrote:
> On 07/15/2014 11:54 AM, Fu, Zhonghui wrote:
>>
>> Hi,
>>
>> The data type of "host" is "struct mmc_host", and there is not "quirks" member in this structure.
> Sorry for wrong typo.
> You use the "host->caps2" instead of "host->quirks".
> 
> 
> Best Regards,
> Jaehoon Chung
>>
>>
>> Thanks,
>> Zhonghui
>>
>> On 2014/7/14 21:26, Chris Ball wrote:
>>> Hi Zhonghui,
>>>
>>> On Tue, Jul 08 2014, Fu, Zhonghui wrote:
>>>> Why add "mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;" ?  How to fix this bug?
>>>>
>>>> Could you please give out some idea about this bug?
>>> Jaehoon already gave you a patch to fix this bug.  Here it is again in
>>> proper patch form.  Please can you test it and let us know whether it
>>> fixes the crash?  Thanks.
>>>
>>>
>>> From: Chris Ball <chris@printf.net>
>>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>>
>>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>>> the use of our own custom threaded IRQ handler, but left in an
>>> unconditional wake_up_process() on that handler at resume-time.
>>>
>>> Reported-by: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
>>> [Patch suggested by Jaehoon Chung]
>>> Signed-off-by: Chris Ball <chris@printf.net>
>>> ---
>>>  drivers/mmc/core/sdio.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>>> index e636d9e..2a128e2 100644
>>> --- a/drivers/mmc/core/sdio.c
>>> +++ b/drivers/mmc/core/sdio.c
>>> @@ -992,7 +992,8 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>>  		}
>>>  	}
>>>  
>>> -	if (!err && host->sdio_irqs)
>>> +	if (!err && host->sdio_irqs &&
>>> +	    !(host->quirks & MMC_CAP2_SDIO_IRQ_NOTHREAD))
>>>  		wake_up_process(host->sdio_irq_thread);
>>>  	mmc_release_host(host);
>>>  
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

