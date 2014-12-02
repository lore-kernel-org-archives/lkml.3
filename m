Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbaLBBxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:53:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47943 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaLBBxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:53:35 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-f79b86d000004a5a-59-547d1b9cdd3e
Content-transfer-encoding: 8BIT
Message-id: <547D1B9C.9030900@samsung.com>
Date: Tue, 02 Dec 2014 10:53:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] clk: samsung: exynos4415: Fix build with PM_SLEEP disabled
References: <1417425174-26694-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1417425174-26694-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkRHeOdG2Iwbr1RhYbZ6xntXj9wtCi
	//FrZouzTW/YLTY9vsZqcXnXHDaLGef3MVmsPXKX3eLphItsFofftLNarNr1h9GB22PnrLvs
	HptWdbJ53Lm2h81j85J6j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mr4/OoHa8FCgYr2/Q/Z
	Gxhf8nYxcnJICJhI3G14yghhi0lcuLeeDcQWEljKKLH3iXoXIwdYzeTLYV2MXEDhRYwSF7qu
	MYPU8AoISvyYfI8FpIZZQF7iyKVskDCzgLrEpHmLmCHqXzNKPFr7HapeS2LetyksIDaLgKrE
	vPMv2EFsNqD4/hc3wPaKCoRJrJx+BaxGRMBQ4uDu7Uwgg5gF5jBLXD82hwkkISzgL9Ew5Rg7
	xKHuElf2d4E9wCngIbHg9kNWkAYJga/sEk82LmeH2CYg8W3yIRaIb2QlNh1ghnhYUuLgihss
	ExjFZiH5ZxbCP7OQ/LOAkXkVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmCEnv73bOIOxvsH
	rA8xCnAwKvHwnjhfEyLEmlhWXJl7iNEU6IiJzFKiyfnANJBXEm9obGZkYWpiamxkbmmmJM6r
	I/0zWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjmaXCp/dys/Nj4gwvTQt4IG8gzdk/SSiN
	e+6Fq4dq2zYyvLi626XMq/6CybrPRt8mlDcfW7HI4pP5SukPQR2f9mb0laXHMPwzMQ2f6la/
	MkbxVMrf2m9TPsxqPmpmenVyx9plp3SWrWv+6FVyzGu31+bj381ipK+0ZKr9Yz6tVH7SsrJB
	agm/EktxRqKhFnNRcSIA3HY/YssCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgO4c6doQg4nfNC02zljPavH6haFF
	/+PXzBZnm96wW2x6fI3V4vKuOWwWM87vY7JYe+Quu8XTCRfZLA6/aWe1WLXrD6MDt8fOWXfZ
	PTat6mTzuHNtD5vH5iX1Hn1bVjF6fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9q
	ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0npJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35Ag
	uB4jAzSQsIYx4/OrH6wFCwUq2vc/ZG9gfMnbxcjBISFgIjH5clgXIyeQKSZx4d56ti5GLg4h
	gUWMEhe6rjGDJHgFBCV+TL7HAlLPLCAvceRSNkiYWUBdYtK8RcwQ9a8ZJR6t/Q5VryUx79sU
	FhCbRUBVYt75F+wgNhtQfP+LG2wgtqhAmMTK6VfAakQEDCUO7t7OBDKIWWAOs8T1Y3OYQBLC
	Av4SDVOOgTULCbhLXNnfxQhicwp4SCy4/ZB1AqPALCT3zUK4bxaS+xYwMq9iFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECE4Az6R3MK5qsDjEKMDBqMTDe+J8TYgQa2JZcWXuIUYJDmYlEd7H
	ICHelMTKqtSi/Pii0pzU4kOMpkDfTWSWEk3OByanvJJ4Q2MTMyNLI3NDCyNjcyVx3hs3c0OE
	BNITS1KzU1MLUotg+pg4OKUaGEWWP/1pOcPZp/eq5SS//fmXJ/d3XGtynm57LEt+xZJnYd7y
	QZwWfZZajfsjnOd8+icUVJAfcvycjU9TSV+4oPKEyyce31mdsGif/qac/VpHdb98fr7MyPn9
	lU6mm9cZNjqcsLVZzSNh6ew9/0yKhP7l0hnOjSV3Hm2t/VziJ8LnsXH15c/C7kosxRmJhlrM
	RcWJALuUK/EWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 06:12 PM, Krzysztof Kozlowski wrote:
> Fix following build errors when PM_SLEEP is disabled (e.g. by disabling
> SUSPEND and HIBERNATION):
> 
> drivers/clk/samsung/clk-exynos4415.c: In function ‘exynos4415_cmu_init’:
> drivers/clk/samsung/clk-exynos4415.c:982:2: error: ‘exynos4415_ctx’ undeclared (first use in this function)
> drivers/clk/samsung/clk-exynos4415.c:982:2: note: each undeclared identifier is reported only once for each function it appears in
> drivers/clk/samsung/clk-exynos4415.c: In function ‘exynos4415_cmu_dmc_init’:
> drivers/clk/samsung/clk-exynos4415.c:1123:2: error: ‘exynos4415_dmc_ctx’ undeclared (first use in this function)
> make[3]: *** [drivers/clk/samsung/clk-exynos4415.o] Error 1
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/clk/samsung/clk-exynos4415.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos4415.c b/drivers/clk/samsung/clk-exynos4415.c
> index c7208c7a3add..2123fc251e0f 100644
> --- a/drivers/clk/samsung/clk-exynos4415.c
> +++ b/drivers/clk/samsung/clk-exynos4415.c
> @@ -118,12 +118,13 @@ enum exynos4415_plls {
>  	nr_plls,
>  };
>  
> +static struct samsung_clk_provider *exynos4415_ctx;
> +
>  /*
>   * Support for CMU save/restore across system suspends
>   */
>  #ifdef CONFIG_PM_SLEEP
>  static struct samsung_clk_reg_dump *exynos4415_clk_regs;
> -static struct samsung_clk_provider *exynos4415_ctx;
>  
>  static unsigned long exynos4415_cmu_clk_regs[] __initdata = {
>  	SRC_LEFTBUS,
> @@ -1031,9 +1032,10 @@ enum exynos4415_dmc_plls {
>  	nr_dmc_plls,
>  };
>  
> +static struct samsung_clk_provider *exynos4415_dmc_ctx;
> +
>  #ifdef CONFIG_PM_SLEEP
>  static struct samsung_clk_reg_dump *exynos4415_dmc_clk_regs;
> -static struct samsung_clk_provider *exynos4415_dmc_ctx;
>  
>  static unsigned long exynos4415_cmu_dmc_clk_regs[] __initdata = {
>  	MPLL_LOCK,
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
