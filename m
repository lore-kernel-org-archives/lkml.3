Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaELBeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:34:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30811 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaELBeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:34:08 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-cd-5370250d138b
Message-id: <53702956.6060607@samsung.com>
Date: Mon, 12 May 2014 10:52:22 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/6] Introducing Exynos ChipId driver
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <CAOesGMi9J=03NY+0FFTusMnMG_Xu--zLnX=QbiG=ym2n=tn8ow@mail.gmail.com>
In-reply-to: <CAOesGMi9J=03NY+0FFTusMnMG_Xu--zLnX=QbiG=ym2n=tn8ow@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zQ11e1YJgg6e7FSz+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+JotT1z+zWSza+oXdYv2M1ywOHB6/f01i9Ni8pN7jyokmVo++LasY
	PT5vkgtgjeKySUnNySxLLdK3S+DKWDetn72gR7Ji3pNPLA2MfSJdjJwcEgImEq/mn2KCsMUk
	Ltxbz9bFyMUhJLCMUWLBz2MsMEWb772GSkxnlPi38xU7hPOaUWL6wh9gVbwCWhL//r1nBLFZ
	BFQlXu5sZgWx2QR0JZ68n8sMYosKhElsmt7HClEvKPFj8j2wXhEBZYknbZeYQYYyC3xkkvg8
	8wxYg7CAjcSK7vXMENtaGCWOPDoGluAUCJa4f/A12CRmATOJRy3rmCFseYnNa96CNUgIXGOX
	+HNiMTPESQIS3yYfAlrHAZSQldh0gBniN0mJgytusExgFJuF5KhZSMbOQjJ2ASPzKkbR1ILk
	guKk9CJTveLE3OLSvHS95PzcTYyQKJy4g/H+AetDjMlAKycyS4km5wOjOK8k3tDYzMjC1MTU
	2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDeUOFrF6Kl7+KxJFxVm
	PLD+nU/Rq/1LPCfeCXdQbI6ebbXIaNO/5b7JSn1vmR9a9Md8//mHYUrnHN8T/flS+i6XGezF
	62zW3dZdtXd3zN/jCj88Si6b3vqx7ecnWfbOg+sLt65ZVSryWSi4aaWg+OfJ8TP3rCmY2bvU
	86CNXc3R3cK6z06ppyqxFGckGmoxFxUnAgAn5Fla2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQV1e1YJgg+nXpC3+TjrGbtG74Cqb
	xabH11gtLu+aw2Yx4/w+JotT1z+zWSza+oXdYv2M1ywOHB6/f01i9Ni8pN7jyokmVo++LasY
	PT5vkgtgjWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBukVJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLFuWj97QY9kxbwn
	n1gaGPtEuhg5OSQETCQ233vNBmGLSVy4tx7I5uIQEpjOKPFv5yt2COc1o8T0hT9YQKp4BbQk
	/v17zwhiswioSrzc2cwKYrMJ6Eo8eT+XGcQWFQiT2DS9jxWiXlDix+R7YL0iAsoST9ouMYMM
	ZRb4yCTxeeYZsAZhARuJFd3rmSG2tTBKHHl0DCzBKRAscf/ga7BJzAJmEo9a1jFD2PISm9e8
	ZZ7AKDALyZJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4xp9J72Bc1WBx
	iFGAg1GJh/cDQ0GwEGtiWXFl7iFGCQ5mJRHeySxAId6UxMqq1KL8+KLSnNTiQ4zJwDCYyCwl
	mpwPTD95JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAY9v3z
	7T2tToUhEnzPg2t+THhlIPQla+6jnLqQ7XsSWOSfT1z5+lze/Uy7HqHbL+Z211zQKrcM0+xR
	Lr728uUlt5PpYc6PAriaKsyeMEmHm3GpBh60Kzhrt+T0cfWKvoYnt9btLNDsTjn57dtBVo67
	18IXO711sqs6+ql5taQ4j/+iCftd8pYosRRnJBpqMRcVJwIAHlivIjUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 04:12 PM, Olof Johansson wrote:
> Hi,
>
> On Sat, May 10, 2014 at 12:18 AM,  <y@samsung.com> wrote:
>> From: Pankaj Dubey <pankaj.dubey@samsung.com>
>>
>> This patch series attempts to get rid of soc_is_exynosXXXX macros
>> and eventually with the help of this series we can probably get
>> rid of CONFIG_SOC_EXYNOSXXXX in near future.
>> Each Exynos SoC has ChipID block which can give information about
>> SoC's product Id and revision number. Currently we have single
>> DT binding information for this as "samsung,exynos4210-chipid".
>> But Exynos4 and Exynos5 SoC series have one small difference in
>> chip Id, with resepect to product id bit-masks. So it means we
>> should have separate compatible string for these different series
>> of SoCs. So I have added second compatible string for handling
>> this difference.
>> This patch series is based on Kukjin Kim's for-next (3.14_rc1 tag)
>> and prepared on top of following patch series and it's dependent
>> patch series.
>>
>> [1]: Map SYSRAM through generic SRAM bindings by Sachin Kamat.
>>          http://www.spinics.net/lists/arm-kernel/msg327677.html
>> [2]: Exynos PMU cleanup and refactoring.
>>          https://lkml.org/lkml/2014/4/30/44
>> [3]: Introduce drivers/soc and add QCOM GSBI driver.
>>          https://lkml.org/lkml/2014/4/24/520
>>
>> Revision 2 and it's discussion can be found here
>>   - https://lkml.org/lkml/2014/5/6/100
> As I just realized when I commented on the last patch in the patchset
> (the cpufreq section): I think you can, and should, use
> of_machine_is_compatible() for most of these cases, instead of using a
> new API through a chipid driver. Since all boards based on an SoC
> should have that in the string of compatibles, it's a shared and easy
> way to handle this without adding custom drivers per manufacturer.
I am sorry, I could not see your comments in my last patch-set.

Anyway, thanks for review. During first version of this patch, I had
discussion with Arnd [1], and it looks like he do not like idea of using
"of_machine_is_compatible".

[1]: https://lkml.org/lkml/2014/5/5/126
       and
https://lkml.org/lkml/2014/5/5/335

So my proposal was till we get generic solution for all files
under mach-exynos let's use chip-id driver provided APIs.

Also chip-id driver is not only for providing this API but also
to provide SoC specific information as a sysfs entry to userspace.
So even though we do not want to use chipid driver API's
for identifying SoCs we can keep this driver.

So let us discuss again and decide which will be best way
(at the same time less overhead) solution for removing usage
of soc_is_exynosXYZ and related CONFIG macros from exynos.

@Arnd and Tomasz, I would appreciate if you spent some time
to review this series as I have addressed many of your
review comments.

> There will possibly be some cases where it doesn't fit well, but for
> nearly all cases it should be sufficient.
>
> (The patchset contains some other good cleanups, of course you should
> keep those).

Thanks and sure, I would like those should get merged.

>
> -Olof
>


-- 
Best Regards,
Pankaj Dubey

