Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaG3DkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:40:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35452 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaG3DkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:40:21 -0400
X-AuditID: cbfee690-b7f526d000003627-e7-53d8691b1454
Message-id: <53D8691B.8080904@samsung.com>
Date: Wed, 30 Jul 2014 12:40:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
        Chris Ball <chris@printf.net>
Cc: ulf.hansson@linaro.org, tgih.jun@samsung.com, aaron.lu@intel.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackey.shen@amd.com, gregkh@linuxfoundation.org
Subject: Re: One bug of SDHCI driver
References: <53B249A4.2040404@linux.intel.com>
 <53B57B23.4020607@linux.intel.com> <53B61403.7040602@samsung.com>
 <53B968EB.60401@linux.intel.com> <53BC164E.4040900@linux.intel.com>
 <86zjgcjckz.fsf@void.printf.net> <53C497FD.2070000@linux.intel.com>
 <53C4AAB5.4070700@samsung.com> <53C4B0CA.1020504@samsung.com>
 <53CBD775.9000304@linux.intel.com> <53D125D6.3020203@linux.intel.com>
 <53D85CBF.3070409@linux.intel.com>
In-reply-to: <53D85CBF.3070409@linux.intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkUFcm80awwdcVjBab+n6zWUy4vJ3R
	onnxeiDr3kRWi8u75rBZHPnfz2jx4f5FZovja8Mt2i9dZHbg9Gi99JfNY/Gel0wed67tYfOY
	dzLQY//cNeweN14tZPLo27KK0ePzJrkAjigum5TUnMyy1CJ9uwSujP6edawFrYoVfzb1MTUw
	dkl3MXJySAiYSFy/dIsNwhaTuHBvPZDNxSEksJRR4sSed0AOB1jRywXVEPHpjBK790+BKnrN
	KPH+7zRWkG5eAS2JFZ9fgk1iEVCVaDk/gx3EZhPQkdj+7TgTiC0qECZxqG0eE0S9oMSPyfdY
	QGwRAX+J7eevMYMMZRbYxCixrOkGM8hmYQEViblv+SGWrWaWmHRkA9gCTgF9ib3/TjCC2MxA
	C/a3TmODsOUlNq95CzZIQuAru8TclgOMEBcJSHybfIgF4h1ZiU0HmCFelpQ4uOIGywRGsVlI
	bpqFZOwsJGMXMDKvYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiM09P/nk3YwXjvgPUhxmSg
	lROZpUST84FxnlcSb2hsZmRhamJqbGRuaUaasJI4r9qjpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjO4Pi74l6eclqO9bML3/Qez1k9fkTuQ/+a9UdKLOiFP1141NUmfsJ+WziGv+qd+Y
	GfbawPan1NLVTO+OvkkP7Yxl5E43jBf+tDrzBLdN6iSJmQdqHzFHskwq+nT49nudvzneIUoX
	uZMbXVq/rtxY9+Da9Z3un2edsVG9/mmtxV2JJT8enmYKy1RiKc5INNRiLipOBAAvGT+T6QIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoK505o1ggyPPzS029f1ms5hweTuj
	RfPi9UDWvYmsFpd3zWGzOPK/n9Hiw/2LzBbH14ZbtF+6yOzA6dF66S+bx+I9L5k87lzbw+Yx
	72Sgx/65a9g9brxayOTRt2UVo8fnTXIBHFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QOcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLr
	MTJAAwlrGDP6e9axFrQqVvzZ1MfUwNgl3cXIwSEhYCLxckF1FyMnkCkmceHeerYuRi4OIYHp
	jBK790+Bcl4zSrz/O40VpIpXQEtixeeXbCA2i4CqRMv5GewgNpuAjsT2b8eZQGxRgTCJQ23z
	mCDqBSV+TL7HAmKLCPhLbD9/jRlkKLPAJkaJZU03mEGuEBZQkZj7lh9i2WpmiUlHNoAt4BTQ
	l9j77wQjiM0MtGB/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEJ4Fn0jsYVzVYHGIU4GBU4uGd8f96sBBrYllxZe4hRgkOZiUR3q9yN4KF
	eFMSK6tSi/Lji0pzUosPMZoCg2Ais5Rocj4wQeWVxBsam5gZWRqZG1oYGZsrifMebLUOFBJI
	TyxJzU5NLUgtgulj4uCUamDMfuIs/a3pTEnbemV3ecGN9ftKJ8ldEr/Offd+7suzJo+37+S9
	MukEn0713uicTt4Yxsy57d/ZM248FpgVuS5L+FQb6yGn+ulhk1pnLOXn9m7W/Pr+WJ9NZ3c+
	Y+9WFhHFSd7lc55yzb7/LjPwRVOXstuqGJGObwfO7mtfH9xtUvfwVOgRtztKLMUZiYZazEXF
	iQCDyFYnGAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Zhonghui.

On 07/30/2014 11:47 AM, Fu, Zhonghui wrote:
> 
> Hi,
> 
> In the resume function, SDIO irq must be enabled, or the interrupts from devices on SDIO bus can't be acknowledged. I also uploaded this new patch to https://bugzilla.kernel.org/show_bug.cgi?id=80151.
> Could you please help to review it?
> 
> 
> 
> 
> Thanks,
> Zhonghui
> 
> On 2014/7/24 23:27, Fu, Zhonghui wrote:
>> Hi,
>>
>> Any comments for this new patch?
>>
>> Thanks,
>> Zhonghui
>> On 2014/7/20 22:51, Fu, Zhonghui wrote:
>>> Hi,
>>>
>>> Chris' patch is not enough to fix this bug. I made a patch as follows and verified it can work.  Could you please give out some comments about this patch?
>>>
>>>
>>> Thanks,
>>> Zhonghui
>>>
>>> >From 72d6f5b56fa04290fd3a055a3333de1d89e7c8d4 Mon Sep 17 00:00:00 2001
>>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>> Date: Sun, 20 Jul 2014 22:29:53 +0800
>>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>>
>>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>>> the use of our own custom threaded IRQ handler, but left in an
>>> unconditional wake_up_process() on that handler at resume-time.
>>>
>>> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>> ---
>>>  drivers/mmc/core/sdio.c |   14 ++++++++++++--
>>>  1 files changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>>> index e636d9e..8369e56 100644
>>> --- a/drivers/mmc/core/sdio.c
>>> +++ b/drivers/mmc/core/sdio.c
>>> @@ -992,8 +992,18 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>>  		}
>>>  	}
>>>  
>>> -	if (!err && host->sdio_irqs)
>>> -		wake_up_process(host->sdio_irq_thread);
>>> +	if (!err && host->sdio_irqs) {
>>> +		if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>> +			wake_up_process(host->sdio_irq_thread);
>>> +		} else {
>>> +			mmc_release_host(host);
>>> +			mmc_host_clk_hold(host);
>>> +			host->ops->enable_sdio_irq(host, 1);
>>> +			mmc_host_clk_release(host);
>>> +			mmc_claim_host(host);
>>> +		}
>>> +	}
If you enable the sdio_irq, I think it needs to check whether MMC_CAP_SDIO_IRQ is set or not.


Best Regards,
Jaehoon Chung
>>> +
>>>  	mmc_release_host(host);
>>>  
>>>  	host->pm_flags &= ~MMC_PM_KEEP_POWER;
>>> -- 1.7.1
>>>
>>>
>>>
>>> On 2014/7/15 12:40, Jaehoon Chung wrote:
>>>> From: Chris Ball <chris@printf.net>
>>>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>>>
>>>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>>>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>>>> the use of our own custom threaded IRQ handler, but left in an
>>>> unconditional wake_up_process() on that handler at resume-time.
>>>>
>>>> Reported-by: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
>>>> [Patch suggested by Jaehoon Chung]
>>>> Signed-off-by: Chris Ball <chris@printf.net>
>>>> ---
>>>>  drivers/mmc/core/sdio.c |    3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>>>> index e636d9e..11cc4e0 100644
>>>> --- a/drivers/mmc/core/sdio.c
>>>> +++ b/drivers/mmc/core/sdio.c
>>>> @@ -992,7 +992,8 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>>>  		}
>>>>  	}
>>>>  
>>>> -	if (!err && host->sdio_irqs)
>>>> +	if (!err && host->sdio_irqs &&
>>>> +			!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD))
>>>>  		wake_up_process(host->sdio_irq_thread);
>>>>  	mmc_release_host(host);
>>>>  
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

