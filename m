Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaIIMOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:14:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30087 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbaIIMOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:14:48 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-2f-540eef35ee47
Message-id: <540EEF33.9010207@gmail.com>
Date: Tue, 09 Sep 2014 14:14:43 +0200
From: Krzysztof Kozlowski <k.kozlowski.k.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, naushad@samsung.com
Subject: Re: [PATCH] clk: samsung: exynos3250: fix width and shift of
 div_spi0_isp clock
References: <1410263697-768-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1410263697-768-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7qm7/lCDF4utLDoXXCVzWLT42us
	Fpd3zWGzmHF+H5PF0wkX2Sw+Hf3ParFo6xd2i8Nv2lktVu36w+jA6bFz1l12jzvX9rB5bF5S
	79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZX6Y9ZC74x1Fxtm8DSwPjKfYuRk4OCQETifXb
	ZrBA2GISF+6tZ+ti5OIQEljKKHHkaQcThPOZUaLvw1LWLkYODl4BDYnPjy1BGlgEVCVub74J
	NohNwFKip/ciM4gtKhAm8ezXQSYQm1dAUOLH5HssIHNEBKYxSly8dBusgVmgTGLhjWlgRcIC
	URKH3h1mBLGFBNwklvzeCFbDKeAu8fTgajaIejOJLy8Ps0LY8hKb17xlnsAoMAvJjllIymYh
	KVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyTwv+xgXHzM6hCjAAejEg9vQwZfiBBr
	YllxZe4hRgkOZiURXusXQCHelMTKqtSi/Pii0pzU4kOMTBycUg2M0pEs824FPTxrvL76t+V7
	+c/XNstuXW8t5eu55UD0rrsnL2Tlz5MrPh70N+W90kr+xoPpsxvTdmX7xvBwth665ZSXJr+i
	sWZWpYsYI0t0zH0zj1XRAfNW1cheSjc8WyJ6ftkGG2aRvXNfXNpzYsrFDfqfT/5MYZaI29kj
	cbN6z7m3vK+ezS+PVWIpzkg01GIuKk4EAKl6fhxaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.2014 13:54, Pankaj Dubey wrote:
> Update shift and width field of div_spi0_isp clock as per Exynos3250
> user manual.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos3250.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

>
> diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
> index ba8f073f..a3dee34 100644
> --- a/drivers/clk/samsung/clk-exynos3250.c
> +++ b/drivers/clk/samsung/clk-exynos3250.c
> @@ -406,7 +406,7 @@ static struct samsung_div_clock div_clks[] __initdata = {
>   	DIV(CLK_DIV_SPI1_ISP, "div_spi1_isp", "mout_spi1_isp", DIV_ISP, 16, 4),
>   	DIV_F(CLK_DIV_SPI0_ISP_PRE, "div_spi0_isp_pre", "div_spi0_isp",
>   		DIV_ISP, 8, 8, CLK_SET_RATE_PARENT, 0),
> -	DIV(CLK_DIV_SPI0_ISP, "div_spi0_isp", "mout_spi0_isp", DIV_ISP, 0, 4),
> +	DIV(CLK_DIV_SPI0_ISP, "div_spi0_isp", "mout_spi0_isp", DIV_ISP, 4, 4),
>
>   	/* DIV_FSYS0 */
>   	DIV_F(CLK_DIV_TSADC_PRE, "div_tsadc_pre", "div_tsadc", DIV_FSYS0, 8, 8,
>

