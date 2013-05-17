Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3EQL5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:57:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31801 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3EQL5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:57:02 -0400
X-AuditID: cbfee68e-b7f276d000002279-6a-51961b0c6aa1
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51961B09.6030201@samsung.com>
Date: Fri, 17 May 2013 20:56:57 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V4 10/30] thermal: exynos: Support thermal tripping
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
 <1368525540-15034-11-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1368525540-15034-11-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkWJdHelqgwcx9PBYNV0Msfr2byW6x
	Zv9PJoveBVfZLC7vmsNm8bn3CKPFjPP7mCyePOxjc+Dw2DnrLrvH4j0vmTz6tqxi9Dh+YzuT
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZX46eZyxYKFVx+v8l5gbGk6JdjJwcEgImEgfXtTBD2GIS
	F+6tZ+ti5OIQEljKKLH2+TwWmKLFG78wQyQWASX+72ICSfAKCEr8mHwPrIhZQF1i0rxFzBC2
	iMTmr79YIWxtiWULX0M1v2SUePJpHxtEs5bE8jn/GUFsFgFViROXHrGD2GwCchJvm76BxUUF
	wiSuTjgOtkBEwFDi+IGlYOcxC7xhlNh5ZBbYIGEBd4lbt2eyQ2xoY5R4vGAdWIJTwFOi48pz
	sA4JgXvsEm8m32SDWCcg8W3yIaCxHEAJWYlNB6ABIClxcMUNlgmM4rOQfDcLyXezkHw3C8l3
	CxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIERu3pf8/6djDePGB9iDEZaP1EZinR5Hxg
	1OeVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbGT
	6W3DY4dpV//794osuhAzk+H2lHlSstxV6hmJsSFK0xWumHUu/Po6fM7yiTfOrbPuWzCBd1f7
	ah8bF33+sqTZ3wQZX6Z84Tonz1DQ5ppmbhl1U+Afk7h62QQpfwbmfZtLtcpZD6xfctLhTr+H
	sfLHhElLl3IenvqQu2SbjaK4iKKGaVlAkxJLcUaioRZzUXEiAFpEvGHwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAV0e6WmBBjMfMls0XA2x+PVuJrvF
	mv0/mSx6F1xls7i8aw6bxefeI4wWM87vY7J48rCPzYHDY+esu+wei/e8ZPLo27KK0eP4je1M
	Hp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYA3aKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzJh2ZT1TwW3Jih29
	+9gaGJtFuxg5OSQETCQWb/zCDGGLSVy4t56ti5GLQ0hgEaPE2v+7mEASvAKCEj8m32PpYuTg
	YBaQlzhyKRskzCygLjFp3iJmiPqXjBJPPu1jg6jXklg+5z8jiM0ioCpx4tIjdhCbTUBO4m3T
	N7C4qECYxNUJx1lAbBEBQ4njB5aCLWYWeMMosfPILLBBwgLuErduz2SH2NDGKPF4wTqwBKeA
	p0THledsExgFZiE5cBbCgbOQHLiAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnB8P5Pa
	wbiyweIQowAHoxIPr8LPKYFCrIllxZW5hxglOJiVRHiPf5waKMSbklhZlVqUH19UmpNafIgx
	Gei9icxSosn5wNSTVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MJz/W5euc9w7rub72Z4mYyJvDSzfsLDK/emnbVSVDZc342UtkTpQ1PiqY1hiRf+CVhJi4
	XsbkArOLkXbPk6oUS/UkBcxOOidpVcxcxHBQZfGHLdc5AgWdZu+S//D8+eceu+JJZWtPp606
	a9sovbHwKoffF/HpYT+PC35v+nzppMTeMEbetkd2SizFGYmGWsxFxYkA0FwT4TMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Amit
On 2013년 05월 14일 18:58, Amit Daniel Kachhap wrote:

> TMU urgently sends active-high signal (thermal trip) to PMU, and thermal
> tripping by hardware logic. Thermal tripping means that PMU cuts off the
> whole power of SoC by controlling external voltage regulator.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    8 +++++++-
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  2 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 5f8f189..479d61e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -84,6 +84,7 @@
>  #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
> +#define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
>  
>  #define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
>  #define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
> @@ -186,7 +187,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  {
>  	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata = data->pdata;
> -	unsigned int status, trim_info;
> +	unsigned int status, trim_info, con;
>  	unsigned int rising_threshold = 0, falling_threshold = 0;
>  	int ret = 0, threshold_code, i, trigger_levs = 0;
>  
> @@ -251,6 +252,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  					falling_threshold |=
>  						threshold_code << 8 * i;
>  			}
> +			if (pdata->trigger_type[i] != HW_TRIP)
> +				continue;


As you know, HW trip can be used when only the most last level of threshold
temperature is set. (exynos4412 : 4th, exynos 5440 : 5th threshold level). So it
wouldn't work properly, even if we enable HW trip according to pre-defined
trigger type not to HW trip threshold temperature. To enable HW trip, we just
need to check whether if HW trip threshold temperature level is defined.

if (trigger_level[HW_TRIP_LEVEL])
	enable HW trip

Thanks,
Jonghwa

> +			con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
> +			con |= (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
> +			writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
>  		}
>  
>  		writel(rising_threshold,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index ee6a3c9..6b937f5 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -64,6 +64,7 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
>  	.trigger_levels[0] = 85,
>  	.trigger_levels[1] = 103,
>  	.trigger_levels[2] = 110,
> +	.trigger_levels[3] = 120,
>  	.trigger_enable[0] = 1,
>  	.trigger_enable[1] = 1,
>  	.trigger_enable[2] = 1,
> @@ -71,6 +72,7 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
>  	.trigger_type[0] = 0,
>  	.trigger_type[1] = 0,
>  	.trigger_type[2] = 1,
> +	.trigger_type[3] = 2,
>  	.gain = 8,
>  	.reference_voltage = 16,
>  	.noise_cancel_mode = 4,


