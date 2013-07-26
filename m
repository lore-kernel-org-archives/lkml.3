Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab3GZKqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:46:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47276 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3GZKqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:46:04 -0400
X-AuditID: cbfee68e-b7f276d000002279-51-51f2536ae55e
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Varun Sethi'" <Varun.Sethi@freescale.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1374766502-14823-1-git-send-email-a.motakis@virtualopensystems.com>
 <1374766502-14823-2-git-send-email-a.motakis@virtualopensystems.com>
In-reply-to: <1374766502-14823-2-git-send-email-a.motakis@virtualopensystems.com>
Subject: RE: [PATCH 2/2] iommu/exynos: Follow kernel coding style for
 __sysmmu_enable return type
Date: Fri, 26 Jul 2013 19:46:01 +0900
Message-id: <003101ce89ed$52317330$f6945990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJyudw5tQEnOpkvql9gjO3ecI9rNAJkZScGmBtCshA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zfd2s4E+BBjOnCFjcuXuO1WLBfmuL
	ztkb2C0+njrObrHp8TVWi8u75rBZzDi/j8ni5J9eRouZt9awOHB6PDk4j8nj3+F+Jo871/aw
	eZzftIbZY/OSeo/JN5YzenzeJOdx5egZpgCOKC6blNSczLLUIn27BK6MZVOuMxfs56mY/Psa
	WwPjJK4uRk4OCQETibmLv7ND2GISF+6tZ+ti5OIQEljGKNE//SYzTNH8/s9MEInpjBKdWw+z
	Qzh/GSXWXFnCAlLFJqAlsXrucUaQhIjACkaJwz9ug7UwC5xklPi64xZU/0xGiSO/p7CBtHAK
	BEu8evkUrF1YIFliUdcMRhCbRUBV4sjzu0wgNq+ApUTPr/nMELagxI/J98DqmYHWrd95nAnC
	lpfYvOYt1LEKEjvOvgabIyJgJfFv2lp2iBoRiX0v3oGdJyEwlUPi/btv7BDLBCS+TT4ENJQD
	KCErsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLjPSKE3OLS/PS
	9ZLzczcxQqK+bwfjzQPWhxiTgdZPZJYSTc4HJo28knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwD
	hQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCqCrFfZ1noo+307+qLZ5XMIX07HQ8Z6sgvK/jA
	8uv7Zqu1cfIWSy5YqMi8rg94sTXzs5bxopPzwxfsN+0VLZ/XWulyXe++vb/N3FMVPTIvJXxE
	DNRXL24w4f9t8oq53nz96vUztV+uXP/XU+PD8eZt0+eLvuKf/FNdbNL5YyedvNp57klbWM1S
	YinOSDTUYi4qTgQA0rZZ9xADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQd2s4E+BBv1TuS3u3D3HarFgv7VF
	5+wN7BYfTx1nt9j0+BqrxeVdc9gsZpzfx2Rx8k8vo8XMW2tYHDg9nhycx+Tx73A/k8eda3vY
	PM5vWsPssXlJvcfkG8sZPT5vkvO4cvQMUwBHVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwjrGjGVTrjMX7OepmPz7GlsD4ySuLkZODgkBE4n5/Z+ZIGwxiQv31rN1MXJxCAlM
	Z5To3HqYHcL5yyix5soSFpAqNgEtidVzjzOCJEQEVjBKHP5xmwnEYRY4ySjxdcctJoiWmYwS
	R35PYQNp4RQIlnj18ilYu7BAssSirhmMIDaLgKrEked3wZbzClhK9PyazwxhC0r8mHwPrJ4Z
	aN36nceZIGx5ic1r3jJDHKsgsePsa7A5IgJWEv+mrWWHqBGR2PfiHeMERqFZSEbNQjJqFpJR
	s5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnFKeSe1gXNlgcYhRgINRiYdXwelj
	oBBrYllxZe4hRgkOZiUR3uvenwKFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+Y7vJK4g2N
	TcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgVHvypILfKI/ZHnsp6SJ
	ynf/kzu+rZezwCc0Mebncf8efddNWV3ux7cuEtreeHprEuea0zzWz3qF/yh/vP8sMXwZY6Ai
	w+8/IWb/F6tPumFRZnVo2o5nXUZbLgsG9ce5Np3+GZj3ID53tuK/rjJRTYuZC+20V/0LMuJ9
	fuRNWtytv3cPlua1/FFiKc5INNRiLipOBAAawM6obQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Antonios Motakis [mailto:a.motakis@virtualopensystems.com]
> Sent: Friday, July 26, 2013 12:35 AM
> 
> On success, the __sysmmu_enable returns 1 instead of 0, which does not
> respect the convention described in Chapter 16 of the Linux kernel coding
> style.
> 
> In fact, this return value is propagated all the way up to
> iommu_attach_device() and iommu_attach_device() in drivers/iommu.c,
> which results into inconsistent behavior of the IOMMU API with Exynos
> systems, compared to other IOMMUs.
> 
> This patch replaces the return value with 0, which makes the Exynos'
> IOMMU driver behavior consistent with that of other IOMMUs.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/exynos-iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index c7dd4b5..4ea3abb 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -504,7 +504,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
> 
>  		dev_dbg(data->sysmmu, "Enabled\n");
>  	} else {
> -		ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
> +		ret = (pgtable == data->pgtable) ? 0 : -EBUSY;
> 
Ok.

__sysmmu_enable() must return 1 if it is called with the same page table.
I have fixed it exynos_iommu_attach_device() to always return zero on success
in the next patchset which I will post today.

Thank you.

>  		dev_dbg(data->sysmmu, "already enabled\n");
>  	}
> --
> 1.8.1.2

