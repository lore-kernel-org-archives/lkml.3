Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaIIMOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:14:19 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12423 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaIIMOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:14:17 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ad-540eef140149
Message-id: <540EEF0B.3040202@samsung.com>
Date: Tue, 09 Sep 2014 14:14:03 +0200
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, naushad@samsung.com
Subject: Re: [PATCH] clk: samsung: exynos3250: fix width field of mout_mmc0/1
References: <1409918081-2464-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1409918081-2464-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7oi7/lCDFpXCVq8fmFo0bvgKpvF
	psfXWC0u75rDZjHj/D4mi6cTLrJZfDr6n9Vi0dYv7BaH37SzWqza9YfRgctj56y77B53ru1h
	89i8pN6jb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4MhatbGApaOCsuHHrMVsD4zH2LkYODgkB
	E4mji3y6GDmBTDGJC/fWs3UxcnEICSxllFi16zgjhPOZUWLHtTNsIFW8AloSm5YtYgKxWQRU
	Jeb+7gCLswkYS2xevgTMFhUIk3j26yATRL2gxI/J91hABokITGOUuHjpNjtIglmgTGLhjWlg
	RcICvhK72k6B2UIC7hJzPzxhBbE5BTwk/m64xgJRbybx5eVhVghbXmLzmrfMExgFZiHZMQtJ
	2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihETAlx2Mi49ZHWIU4GBU4uFtyOAL
	EWJNLCuuzD3EKMHBrCTCa/0CKMSbklhZlVqUH19UmpNafIiRiYNTqoExKGj5MbHHRmmirs/6
	zr28bLp399Hvfj9taxsDe3xbWPPMb8vYm0l9dfnUImd0TkQ1tr+c1+phzNbtu4putzycuEjR
	T+/p6Xf6D8peCq1tl1pdY1qZWbn7wDf7nw/2X50/uZGX7Yq+nduGTUWXlhhq7iw0OrT3f0Fk
	Pu8NNq6PF5Sv/TGQu9ijxFKckWioxVxUnAgAqasTd14CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.2014 13:54, Pankaj Dubey wrote:
> As per Exynos3250 user manual mmc0/1 mux selection has 4 bit wide.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos3250.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

>
> diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
> index 7a17bd4..e1cb464 100644
> --- a/drivers/clk/samsung/clk-exynos3250.c
> +++ b/drivers/clk/samsung/clk-exynos3250.c
> @@ -335,8 +335,8 @@ static struct samsung_mux_clock mux_clks[] __initdata = {
>
>   	/* SRC_FSYS */
>   	MUX(CLK_MOUT_TSADC, "mout_tsadc", group_sclk_p, SRC_FSYS, 28, 4),
> -	MUX(CLK_MOUT_MMC1, "mout_mmc1", group_sclk_p, SRC_FSYS, 4, 3),
> -	MUX(CLK_MOUT_MMC0, "mout_mmc0", group_sclk_p, SRC_FSYS, 0, 3),
> +	MUX(CLK_MOUT_MMC1, "mout_mmc1", group_sclk_p, SRC_FSYS, 4, 4),
> +	MUX(CLK_MOUT_MMC0, "mout_mmc0", group_sclk_p, SRC_FSYS, 0, 4),
>
>   	/* SRC_PERIL0 */
>   	MUX(CLK_MOUT_UART1, "mout_uart1", group_sclk_p, SRC_PERIL0, 4, 4),
>

