Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaICCIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:08:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24357 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaICCIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:08:46 -0400
X-AuditID: cbfee68e-f79536d000000fd1-86-5406782c8aed
Message-id: <5406782B.9000408@samsung.com>
Date: Wed, 03 Sep 2014 11:08:43 +0900
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
 <53FFC051.7040907@samsung.com> <20140829192818.GB23645@developer>
In-reply-to: <20140829192818.GB23645@developer>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkWFengi3EYNMBJYuGqyEWG2esZ7W4
	+/wwo8Wa/T+ZLOZfucZq0bvgKpvF2aY37BabHgO5l3fNYbP43HuE0WLG+X1MFk8e9rE58Hjs
	nHWX3WPxnpdMHpuX1Hv0bVnF6HH8xnYmj8+b5ALYorhsUlJzMstSi/TtErgyph+4zVSwW6Si
	a/td9gbGLQJdjJwcEgImEqu2bmSCsMUkLtxbz9bFyMUhJLCUUeLWyhmMMEVzm1+ygthCAtMZ
	JU59sYQoes0osb11LjNIgldAS+LRrpksIDaLgKrEhRt32UFsNqD4/hc32EBsUYEwiZXTr7BA
	1AtK/Jh8D8wWAao5cWk72BXMAluZJNa8dQCxhQUKJFY8a2OEWNbOJNExuw9oEAcHp4C+xM6O
	UIh6HYn9rdPYIGx5ic1r3jKD1EsIfGSX2HL/FSPEQQIS3yYfYgHplRCQldh0gBniMUmJgytu
	sExgFJuF5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzAeD3971nfDsab
	B6wPMQpwMCrx8C4IYAsRYk0sK67MPcRoCnTFRGYp0eR8YFLIK4k3NDYzsjA1MTU2Mrc0UxLn
	TZD6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBscRzW81rhj0KZSfe1HU5/yi5b9Cr1rsh
	4++pX1b8rCG73HMEv9fHmARu1X9jEHW5zralJclm19fqNY1ftiQ7L1BtfW1ZIRp+UdXjeujR
	zxPvVMzx99QwbG7Ptpnfmi5aJBg6/1/n1enmfEKGjAfLDjMsPXv0m8XnbX8DUqd/ZVPNzhI4
	mvNeiaU4I9FQi7moOBEAWG2Q89ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoK5OBVuIwYzHUhYNV0MsNs5Yz2px
	9/lhRos1+38yWcy/co3VonfBVTaLs01v2C02PQZyL++aw2bxufcIo8WM8/uYLJ487GNz4PHY
	Oesuu8fiPS+ZPDYvqffo27KK0eP4je1MHp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA3aikUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxhzJh+4DZTwW6Riq7td9kbGLcIdDFyckgImEjMbX7JCmGLSVy4t54NxBYS
	mM4oceqLZRcjF5D9mlFie+tcZpAEr4CWxKNdM1lAbBYBVYkLN+6yg9hsQPH9L26ANYsKhEms
	nH6FBaJeUOLH5HtgtghQzYlL25lAbGaBrUwSa946gNjCAgUSK561MUIsa2eS6JjdBzSIg4NT
	QF9iZ0coRL2OxP7WaWwQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAhOBs+kdzCuarA4xCjAwajEw7sggC1EiDWxrLgy9xCjBAezkgivbyJQiDcl
	sbIqtSg/vqg0J7X4EKMpMAQmMkuJJucDE1VeSbyhsYmZkaWRuaGFkbG5kjjvwVbrQCGB9MSS
	1OzU1ILUIpg+Jg5OqQbGYJafQeKOM8+ecS7mLCx+Enzw4KekqC3P/SpjjS8anPNI5zLssNuj
	u+7MUcOv/rseSJwKrfIsmdzGvXeyT/bDyzed8o7xhSycszzCnOWRxpSwRzG2DLeVrZ5JS++p
	+MN470ML41UnE8Pp26vvlVvdM+U9rq/11tJAMYJ7nm/8V7WoHYW269mVWIozEg21mIuKEwEF
	mnk+HAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eduardo,

On 08/30/2014 04:28 AM, Eduardo Valentin wrote:
> Chanwoo,
> 
> On Fri, Aug 29, 2014 at 08:50:41AM +0900, Chanwoo Choi wrote:
>> Dear Eduardo,
>>
>> On 08/28/2014 11:53 PM, Eduardo Valentin wrote:
>>> On Thu, Aug 28, 2014 at 01:25:14PM +0900, Chanwoo Choi wrote:
>>>> Dear Eduardo,
>>>>
>>>> This patch is wrong. It is my mistake.
>>>>
>>>> Please ignore only this patch because
>>>> the offset calculation of 'case 0' is different from 'case 2'.
>>>
>>>
>>> Do patches 1 - 3 are still correct? Patch 1, from Barlomiej, seams to be
>>> a common agreement. 
> 
>>
>> Yes, patches 1 - 3 are correct.
>>
> 
> OK. I pulled patch 01 into my next branch.
> 
> Can you please update patches 02 and 03 based on my next brach? They are
> conflicting with the massive cleanups done by Bartlomiej (Thanks
> Bartlomiej). So, please, resend patches 02 and 03 only, refreshed onto
> my next branch.

OK, I'll send new patchset after rebase it.

Best Regards,
Chanwoo Choi

> 
> Cheers.
> 
>> Best Regards,
>> Chanwoo Choi
>>
>>>
>>>>
>>>> Best Regards,
>>>> Chanwoo Choi
>>>>
>>>> On 08/26/2014 10:31 AM, Chanwoo Choi wrote:
>>>>> This patch remove simply duplicate code when reading triminfo register of Exynos5440.
>>>>>
>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>> Cc: Zhang Rui <rui.zhang@intel.com>
>>>>> Cc: Eduardo Valentin <edubezval@gmail.com>
>>>>> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>>>> Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>>>> ---
>>>>>  drivers/thermal/samsung/exynos_tmu.c | 4 +---
>>>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>>>>> index 64c702a..5888467 100644
>>>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>>>> @@ -187,15 +187,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>>>>  		 */
>>>>>  		switch (data->id) {
>>>>>  		case 0:
>>>>> +		case 2:
>>>>>  			trim_info = readl(data->base +
>>>>>  			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>>>>>  			break;
>>>>>  		case 1:
>>>>>  			trim_info = readl(data->base + reg->triminfo_data);
>>>>>  			break;
>>>>> -		case 2:
>>>>> -			trim_info = readl(data->base -
>>>>> -			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>>>>>  		}
>>>>>  	} else {
>>>>>  		/* On exynos5420 the triminfo register is in the shared space */
>>>>>
>>>>
>>>
>>
> 

