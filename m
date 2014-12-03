Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaLCFe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:34:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46265 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCFeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:34:24 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-76-547ea0ddcfac
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <547EA0DC.70800@samsung.com>
Date: Wed, 03 Dec 2014 14:34:20 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, kgene.kim@samsung.com, arnd@arndb.de,
        thomas.ab@samsung.com
Subject: Re: [PATCH] soc: samsung: pmu: split up SoC specific PMU data
References: <1417364162-29981-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1417364162-29981-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkUPfugroQgxWzRS0aroZY/J10jN1i
	44z1rBa9C66yWWx6fI3V4vKuOWwWM87vY7JYtPULu0XHMkYHTo/fvyYxemxeUu/Rt2UVo8fn
	TXIBLFFcNimpOZllqUX6dglcGa/3vmcp+ChV0TfbvIGxSayLkZNDQsBE4v6ihcwQtpjEhXvr
	2boYuTiEBJYySrRe+cYOU9R5fQdUYhGjxLyDN1lBErwCghI/Jt9jAbGZBdQlJs1bxAxhi0gc
	7N/CBmFrSyxb+BosLiTwmlHi0F5miF4NiS3Nf8F6WQRUJbafvwI2k01ATuJt0zdGEFtUIEzi
	6oTjYDUiQHM6L99jBTmCWeA+o8SF7tlgg4QF3CRm7f7HDrHAQ+Lsi89MIDangKfEkwf3mEEa
	JASusUscWTqBDWKbgMS3yYeApnIAJWQlNh2Ael9S4uCKGywTGMVnIfltFpLfZiH5bRaS3xYw
	sqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECIzV0/+eTdjBeO+A9SFGAQ5GJR5ei7i6ECHW
	xLLiytxDjKZAF01klhJNzgcmhLySeENjMyMLUxNTYyNzSzMlcd7XUj+DhQTSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTBaNGqtZUl5+Hl7maX8uzm3Fjl/UMm95XZAJ3uN78Zpp//s+Oj7Na6c
	Q9iszvXZlrC9nS8L8qruPkoMkuX/8cmGifPQ/+RMs2PR1qqn/P0mnlatmFWzc9qVQgHZ+UGr
	F3DscN5+6fbfd+eMtgj+uj55o5gS9zvlCLUfnpNnbltWsW/PDBOPmtBnSizFGYmGWsxFxYkA
	WrBwCtACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jAd27C+pCDM7+5rFouBpi8XfSMXaL
	jTPWs1r0LrjKZrHp8TVWi8u75rBZzDi/j8li0dYv7BYdyxgdOD1+/5rE6LF5Sb1H35ZVjB6f
	N8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcyYt/kSe8F9qYoPB+Yy
	NTB+EO1i5OSQEDCR6Ly+gw3CFpO4cG89kM3FISSwiFFi3sGbrCAJXgFBiR+T77F0MXJwMAvI
	Sxy5lA0SZhZQl5g0bxEziC0k8JpR4tBeZohyDYktzX9ZQGwWAVWJ7eevgI1hE5CTeNv0jRHE
	FhUIk7g64ThYjYiAtkTn5XusIHuZBe4zSlzong02SFjATWLW7n/sEAs8JM6++MwEYnMKeEo8
	eXCPeQKjwCwk581COG8WkvMWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO62fSOxhX
	NVgcYhTgYFTi4bWIqwsRYk0sK67MPcQowcGsJML7owUoxJuSWFmVWpQfX1Sak1p8iNEU6LuJ
	zFKiyfnAlJNXEm9obGJmZGlkbmhhZGyuJM5742ZuiJBAemJJanZqakFqEUwfEwenVAOj/nzL
	Bx/+vDr2dMebwMZL/6QesrLsduBuld3blHPRS7zjy7dD3m7rNe7EyT5a8cT/6C4DXnWNyn1a
	Ea+sJy5sXlrlfin0buXkmUdSv548w/7++ulk7oe3Hr1ja10SNpfNiTtxVkSyQnhl76pF79fP
	Mv3DN5tn1Wor10/3HRdO+2vet0qHc2priRJLcUaioRZzUXEiALF6nWwBAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 12월 01일 01:16, Pankaj Dubey wrote:

> This patch splits up exynos-pmu.c file, and moves PMU configuration data
> and functions handing those data into SoC specific PMU files, keeping
> driver structure and common functionality into exynos-pmu.c.
> 
> At the same time it also separates compilation of these different SoC PMU files
> based on CONFIG_ARM64 and CONFIG_ARM. This way we can reduce overhead of ARM64
> SoC's PMU getting compiled when kernel is built for ARM and vice-versa.
> 
> This patch also removes .owner field from exynos-pmu.c as it's redundant for
> drivers calling platform_driver_register to register platform_driver.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
> This patch is prepared on top of kgene/for-next and following patch [1] from
> Amit Daniel.
> 
> [1]: http://www.spinics.net/lists/linux-samsung-soc/msg39797.html
> 
> This patch tries to address some of concerns raised for using exynos-pmu.c for
> ARM and ARM64 based SoC at these threads [2], [3].
> 
> [2]: http://www.spinics.net/lists/linux-samsung-soc/msg39809.html
> [3]: https://lkml.org/lkml/2014/11/24/322
> 
> Since Exynos SoC's has similar PMU IP, and already existing bindings can be
> used, it makes sense to keep single driver for both ARM and ARM64 based SoCs.
> All common functionalties are in exynos-pmu.c whereas SoC specific data and 
> handling are moved into SoC specific exynosNNNN-pmu files.
> 
> All changes are compiled tested only. Any improvements/suggestions are most
> welcome.
> 
>  drivers/soc/samsung/Makefile         |    9 +-
>  drivers/soc/samsung/exynos-pmu.c     | 1293 +---------------------------------
>  drivers/soc/samsung/exynos-pmu.h     |   63 ++
>  drivers/soc/samsung/exynos3250-pmu.c |  176 +++++
>  drivers/soc/samsung/exynos4-pmu.c    |  223 ++++++
>  drivers/soc/samsung/exynos5250-pmu.c |  196 ++++++
>  drivers/soc/samsung/exynos5420-pmu.c |  298 ++++++++
>  drivers/soc/samsung/exynos7-pmu.c    |  441 ++++++++++++
>  8 files changed, 1412 insertions(+), 1287 deletions(-)
>  create mode 100644 drivers/soc/samsung/exynos-pmu.h
>  create mode 100644 drivers/soc/samsung/exynos3250-pmu.c
>  create mode 100644 drivers/soc/samsung/exynos4-pmu.c
>  create mode 100644 drivers/soc/samsung/exynos5250-pmu.c
>  create mode 100644 drivers/soc/samsung/exynos5420-pmu.c
>  create mode 100644 drivers/soc/samsung/exynos7-pmu.c
> 

...

> diff --git a/drivers/soc/samsung/exynos-pmu.h b/drivers/soc/samsung/exynos-pmu.h
> new file mode 100644
> index 0000000..4adc5a3
> --- /dev/null
> +++ b/drivers/soc/samsung/exynos-pmu.h
> @@ -0,0 +1,63 @@
> +/*
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Header for EXYNOS PMU Driver support
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __EXYNOSPMU_H
> +#define __EXYNOSPMU_H
> +
> +#include <linux/io.h>
> +
> +#define PMU_TABLE_END	(-1U)
> +
> +static void __iomem *pmu_base_addr;
> +

AFAIK, static variable in header file can't be used globally. It would be placed
in exynos-pmu.c or elsewhere and then only extern declaration is allowed here.
If I'm wrong, please let me know.

Thanks.
Jonghwa
