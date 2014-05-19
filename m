Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaESFRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:17:11 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:47236 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaESFRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <1399288539-1793-3-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
	<1399288539-1793-3-git-send-email-b.zolnierkie@samsung.com>
Date: Mon, 19 May 2014 10:47:08 +0530
Message-ID: <CADGdYn7uWgU_Cj7t3rFDchWyk+0GGYNGMHqhjeWEu2STAkeDFw@mail.gmail.com>
Subject: Re: [PATCH 02/10] thermal: exynos: remove unused defines
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On 5/5/14, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu_data.h | 27 +--------------------------
>  1 file changed, 1 insertion(+), 26 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h
> b/drivers/thermal/samsung/exynos_tmu_data.h
> index 06c4345..d4eeddb 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -42,20 +42,8 @@
>  /* Exynos4210 specific registers */
>  #define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
>  #define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
> -#define EXYNOS4210_TMU_REG_TRIG_LEVEL1	0x54
> -#define EXYNOS4210_TMU_REG_TRIG_LEVEL2	0x58
> -#define EXYNOS4210_TMU_REG_TRIG_LEVEL3	0x5C
> -#define EXYNOS4210_TMU_REG_PAST_TEMP0	0x60
> -#define EXYNOS4210_TMU_REG_PAST_TEMP1	0x64
> -#define EXYNOS4210_TMU_REG_PAST_TEMP2	0x68
> -#define EXYNOS4210_TMU_REG_PAST_TEMP3	0x6C
> -
This removal looks fine as 4210 is an old soc.
> -#define EXYNOS4210_TMU_TRIG_LEVEL0_MASK	0x1
> -#define EXYNOS4210_TMU_TRIG_LEVEL1_MASK	0x10
> -#define EXYNOS4210_TMU_TRIG_LEVEL2_MASK	0x100
> -#define EXYNOS4210_TMU_TRIG_LEVEL3_MASK	0x1000
> +
>  #define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
> -#define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
>
>  /* Exynos5250 and Exynos4412 specific registers */
>  #define EXYNOS_TMU_TRIMINFO_CON	0x14
> @@ -69,8 +57,6 @@
>  #define EXYNOS_TMU_RISE_INT_SHIFT	0
>  #define EXYNOS_TMU_FALL_INT_MASK	0x111
>  #define EXYNOS_TMU_FALL_INT_SHIFT	12
> -#define EXYNOS_TMU_CLEAR_RISE_INT	0x111
> -#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
> @@ -82,8 +68,6 @@
>  #define EXYNOS_TMU_INTEN_RISE2_SHIFT	8
>  #define EXYNOS_TMU_INTEN_RISE3_SHIFT	12
>  #define EXYNOS_TMU_INTEN_FALL0_SHIFT	16
> -#define EXYNOS_TMU_INTEN_FALL1_SHIFT	20
> -#define EXYNOS_TMU_INTEN_FALL2_SHIFT	24
I suggest to retain this generic soc macros as they might be used in future.
>
>  #define EXYNOS_EMUL_TIME	0x57F0
>  #define EXYNOS_EMUL_TIME_MASK	0xffff
> @@ -107,13 +91,11 @@
>  #define EXYNOS5440_TMU_S0_7_TH0			0x110
>  #define EXYNOS5440_TMU_S0_7_TH1			0x130
>  #define EXYNOS5440_TMU_S0_7_TH2			0x150
> -#define EXYNOS5440_TMU_S0_7_EVTEN		0x1F0
>  #define EXYNOS5440_TMU_S0_7_IRQEN		0x210
>  #define EXYNOS5440_TMU_S0_7_IRQ			0x230
>  /* exynos5440 common registers */
>  #define EXYNOS5440_TMU_IRQ_STATUS		0x000
>  #define EXYNOS5440_TMU_PMIN			0x004
> -#define EXYNOS5440_TMU_TEMP			0x008
>
>  #define EXYNOS5440_TMU_RISE_INT_MASK		0xf
>  #define EXYNOS5440_TMU_RISE_INT_SHIFT		0
> @@ -124,13 +106,6 @@
>  #define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
>  #define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
>  #define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
> -#define EXYNOS5440_TMU_INTEN_FALL1_SHIFT	5
> -#define EXYNOS5440_TMU_INTEN_FALL2_SHIFT	6
> -#define EXYNOS5440_TMU_INTEN_FALL3_SHIFT	7
> -#define EXYNOS5440_TMU_TH_RISE0_SHIFT		0
> -#define EXYNOS5440_TMU_TH_RISE1_SHIFT		8
> -#define EXYNOS5440_TMU_TH_RISE2_SHIFT		16
> -#define EXYNOS5440_TMU_TH_RISE3_SHIFT		24
5440 is an old soc so can be removed.
>  #define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
>  #define EXYNOS5440_EFUSE_SWAP_OFFSET		8
>
> --
> 1.8.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
