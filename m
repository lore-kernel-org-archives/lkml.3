Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaH1Xuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:50:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44077 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaH1Xuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:50:44 -0400
X-AuditID: cbfee68f-f797f6d000001173-cd-53ffc05154ad
Message-id: <53FFC051.7040907@samsung.com>
Date: Fri, 29 Aug 2014 08:50:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
Cc: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com,
        kgene.kim@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 4/4] thermal: exynos: Remove duplicate code when reading
 triminfo register of Exynos5440
References: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
 <1409016665-3824-5-git-send-email-cw00.choi@samsung.com>
 <53FEAF2A.1080400@samsung.com> <20140828145310.GC18194@developer>
In-reply-to: <20140828145310.GC18194@developer>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkSDfwwP9gg6vr5C0aroZYbJyxntXi
	7vPDjBZr9v9ksph/5RqrRe+Cq2wWZ5vesFtsegzkXt41h83ic+8RRosZ5/cxWTx52MfmwOOx
	c9Zddo/Fe14yeWxeUu/Rt2UVo8fxG9uZPD5vkgtgi+KySUnNySxLLdK3S+DKeHn3GnPBTP6K
	tnNZDYwzeLoYOTkkBEwk/r/5xw5hi0lcuLeerYuRi0NIYCmjxKb155lginZfu88OkVjEKHHy
	eSczhPOaUeLIgUesIFW8AloSn//MZAGxWQRUJVp//GEGsdmA4vtf3GADsUUFwiRWTr/CAlEv
	KPFj8j0wWwSo5sSl7WDbmAW2MkmseesAYgsLFEiseNbGCLHsMKPE65YnQMs4ODgF9CXOfTWA
	qNeR2N86jQ3ClpfYvOYt2HESAh/ZJRZcnMcIcZCAxLfJh1hAeiUEZCU2HWCG+ExS4uCKGywT
	GMVmITlpFpKxs5CMXcDIvIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMF5P/3vWv4Px7gHr
	Q4wCHIxKPLwOcf+ChVgTy4orcw8xmgJdMZFZSjQ5H5gU8kriDY3NjCxMTUyNjcwtzZTEeRdK
	/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLgr5Gne9klTq1Rc//8tFBOfovbgr2yW/MPQ
	szf+HD/w64JI75W+oKTaaxJmrNrMxn4bg0UY8iwmcXSql8XXreIuruRd+pll6qyWnKg1jVdC
	41TjPnCuCZFXeS/PySAzxfDEBveMqUHXZ3usefq8fNEq5Y3z+93Y9p1q+K5qz3Zv7f9lcolm
	pkosxRmJhlrMRcWJAMtRc37SAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgG7ggf/BBve2i1s0XA2x2DhjPavF
	3eeHGS3W7P/JZDH/yjVWi94FV9kszja9YbfY9BjIvbxrDpvF594jjBYzzu9jsnjysI/Ngcdj
	56y77B6L97xk8ti8pN6jb8sqRo/jN7YzeXzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKOSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYI
	Xd+QILgeIwM0kLCGMePl3WvMBTP5K9rOZTUwzuDpYuTkkBAwkdh97T47hC0mceHeerYuRi4O
	IYFFjBInn3cyQzivGSWOHHjEClLFK6Al8fnPTBYQm0VAVaL1xx9mEJsNKL7/xQ02EFtUIExi
	5fQrLBD1ghI/Jt8Ds0WAak5c2s4EYjMLbGWSWPPWAcQWFiiQWPGsjRFi2WFGidctT4CWcXBw
	CuhLnPtqAFGvI7G/dRobhC0vsXnNW+YJjAKzkKyYhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCk8Ez6R2MqxosDjEKcDAq8fA6xP0LFmJNLCuuzD3EKMHBrCTC2zvtf7AQ
	b0piZVVqUX58UWlOavEhRlNgCExklhJNzgcmqrySeENjEzMjSyNzQwsjY3Mlcd6DrdaBQgLp
	iSWp2ampBalFMH1MHJxSDYxej7oqTK/Nurcs71T8e3+Lew51Niu35i/ZLaxQKaj1+kGx4/IJ
	VvUt603sHWQ1K16+3HDi6BbpG1EM1cU8y1KFPR79lqm8cXqJdmjnZe3bK/OOdmlcttnSUcrt
	fuSLV93J3htVDJt6/pe2OQdwv7WrYeZork6s9AmVtv+ZNr9dc0FJr7f1LyWW4oxEQy3mouJE
	AK4/KYIcAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eduardo,

On 08/28/2014 11:53 PM, Eduardo Valentin wrote:
> On Thu, Aug 28, 2014 at 01:25:14PM +0900, Chanwoo Choi wrote:
>> Dear Eduardo,
>>
>> This patch is wrong. It is my mistake.
>>
>> Please ignore only this patch because
>> the offset calculation of 'case 0' is different from 'case 2'.
> 
> 
> Do patches 1 - 3 are still correct? Patch 1, from Barlomiej, seams to be
> a common agreement. 

Yes, patches 1 - 3 are correct.

Best Regards,
Chanwoo Choi

> 
>>
>> Best Regards,
>> Chanwoo Choi
>>
>> On 08/26/2014 10:31 AM, Chanwoo Choi wrote:
>>> This patch remove simply duplicate code when reading triminfo register of Exynos5440.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Zhang Rui <rui.zhang@intel.com>
>>> Cc: Eduardo Valentin <edubezval@gmail.com>
>>> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> ---
>>>  drivers/thermal/samsung/exynos_tmu.c | 4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>>> index 64c702a..5888467 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>> @@ -187,15 +187,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>>  		 */
>>>  		switch (data->id) {
>>>  		case 0:
>>> +		case 2:
>>>  			trim_info = readl(data->base +
>>>  			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>>>  			break;
>>>  		case 1:
>>>  			trim_info = readl(data->base + reg->triminfo_data);
>>>  			break;
>>> -		case 2:
>>> -			trim_info = readl(data->base -
>>> -			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>>>  		}
>>>  	} else {
>>>  		/* On exynos5420 the triminfo register is in the shared space */
>>>
>>
> 

