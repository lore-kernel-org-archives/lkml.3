Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaKZHwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:52:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13964 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKZHwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:52:51 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f0-547586d09161
Message-id: <547586D5.2040902@samsung.com>
Date: Wed, 26 Nov 2014 13:22:53 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS: use u8 for val[] in struct exynos_pmu_conf
References: <2379473.Yu7PYOQ3m0@amdc1032>
In-reply-to: <2379473.Yu7PYOQ3m0@amdc1032>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkRvdCW2mIwZTNNhYbZ6xntehdcJXN
	4mzTG3aLTY+vsVpc3jWHzWLG+X1MDmwem5fUe/RtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
	vGWbmAt2c1Z0tXxmb2Bczd7FyMkhIWAi0X3wFhOELSZx4d56ti5GLg4hgaWMEhumnGGDKZr0
	qYkZIrGIUWLV/JusEE4rk8TmOyuARnFw8ApoSWz/lA5isgioSky+lA3SyyagK/Hk/VxmEFtU
	IELiypo5jCA2r4CgxI/J91hAbBGBOImrT9YwgoxkFpgBtLjpEliDsICPxKX23WC2kICmRPeV
	42ANnECrvj7+BRZnFrCVWPB+HQuELS+xec1bsEMlBLaxS8z7sBGsiEVAQOLb5EMsIMdJCMhK
	bDrADPGYpMTBFTdYJjCKzUJy0ywkY2chGbuAkXkVo2hqQXJBcVJ6kZFecWJucWleul5yfu4m
	RmBcnf73rG8H480D1ocYBTgYlXh4I6RKQ4RYE8uKK3MPMZoCXTGRWUo0OR8YvXkl8YbGZkYW
	piamxkbmlmZK4rwJUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB29eQoTV+ik76kVEw4
	QfH9r6deq9UM7y3YfPvDha2nQ/Zf/HpSyDFfmUF26ZzPlTq2D0OnZCxdy75eTmhGZJ6xmeOM
	lxPlrN2dJy78pqfPrfbt/gZZ8bUaIeIClq9myxz+uuH029O79n7vWPPtS2WF8PzfDKdqLJa7
	HBReZlD+sbf85ROuuKPvlFiKMxINtZiLihMBAKsmcKYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAd0LbaUhBtf+G1tsnLGe1aJ3wVU2
	i7NNb9gtNj2+xmpxedccNosZ5/cxObB5bF5S79G3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhDWMGfOWbWIu2M1Z0dXymb2BcTV7FyMnh4SAicSkT03MELaY
	xIV769m6GLk4hAQWMUqsmn+TFcJpZZLYfGcFUAcHB6+AlsT2T+kgJouAqsTkS9kgvWwCuhJP
	3s8FmyMqECFxZc0cRhCbV0BQ4sfkeywgtohAnMTVJ2sYQUYyC8xglNjQdAmsQVjAR+JS+24w
	W0hAU6L7ynGwBk6gVV8f/wKLMwvYSix4v44FwpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxjBUftMegfjqgaLQ4wCHIxKPLwRUqUhQqyJZcWVuYcY
	JTiYlUR4TeqAQrwpiZVVqUX58UWlOanFhxhNgSEwkVlKNDkfmFDySuINjU3MTY1NLU0sTMws
	lcR5b9zMDRESSE8sSc1OTS1ILYLpY+LglGpgrP4o92P+kkbrTSXTPR4IptzfyDxxyqrG5Gqp
	h+cvNL2z+mkkoXY+31UuoLFm27bpv23PidjPUrrLv+yQc1G+o0LTx9n+bBO5r63j2LtSlvHo
	shlXVfiOOfgd8EosNNHp+Wf9d29VWltqp3GcaXBSyyvOI8lH/8w8ZqURsD00XVplyao3nHGS
	SizFGYmGWsxFxYkAjhqvnfACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartilomiej,


On Tuesday 08 July 2014 05:33 PM, Bartlomiej Zolnierkiewicz wrote:
> Values stored in val[] are never bigger than a byte.
>
>     text    data     bss     dec     hex filename
>     5264       4       4    5272    1498 arch/arm/mach-exynos/pmu.o.before
>     2992       4       4    3000     bb8 arch/arm/mach-exynos/pmu.o.after
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

I tested this patch and it's really helpful to reduce size.
How about resubmitting this change? As this will not get applied on 
current tree.

Thanks,
Pankaj Dubey

> ---
>   arch/arm/mach-exynos/common.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> index b850db4..55ff019 100644
> --- a/arch/arm/mach-exynos/common.h
> +++ b/arch/arm/mach-exynos/common.h
> @@ -101,7 +101,7 @@ enum sys_powerdown {
>
>   struct exynos_pmu_conf {
>   	void __iomem *reg;
> -	unsigned int val[NUM_SYS_POWERDOWN];
> +	u8 val[NUM_SYS_POWERDOWN];
>   };
>
>   extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
>
