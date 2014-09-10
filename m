Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaIJH6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:58:36 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60730 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIJH6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:58:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3c-541004a69937
Message-id: <541004A5.50802@samsung.com>
Date: Wed, 10 Sep 2014 09:58:29 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, Chander Kashyap <k.chander@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH] clk: samsung: exynos5260: fix typo in clock name
References: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7rLWARCDE4+srB4vGYxk8WqDUtY
	LF6/MLToXXCVzWLT42usFpd3zWGzmHF+H5PF0wkX2SwWbf3CbnH4TTurxapdfxgduD12zrrL
	7nHn2h42j81L6j36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEro+33QZaCVq6KfyuXsjYwHuTo
	YuTkkBAwkZg3fQ8LhC0mceHeerYuRi4OIYGljBLbz3xmh3A+M0ocffKKCaSKV0BD4vm+BWAd
	LAKqEvNef2cEsdkEPCSmfe9hBrFFBcIknv06CFUvKPFj8j0WkEEiAtMYJS5eug02lVlgG6PE
	9+1NQA4Hh7CAq8SGdVUgDUJAg7a1tbKB2JwCnhJvFk8AW8YsYCbx5eVhVghbXmLzmrfMExgF
	ZiHZMQtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihETDlx2Mi49ZHWIU4GBU
	4uEtvMgfIsSaWFZcmXuIUYKDWUmEd9YroBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGTc++/Yj1
	SrqsOSNtE+Mql6wZT0uyizd6nJwyf/HKde3s2088+b33afrmeC83lsfCn45Pred9Ly+loqlt
	s92BxbZm3/23v4Ju5T3Pbn6dKH236YvEgU27WsX02PYxrfrwtfxEza/VZxbVy66YsjBkAcud
	QPtdpj/NBRQe3CwJkY3h4njTMWfTGiWW4oxEQy3mouJEAHnpExVkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.09.2014 07:56, Pankaj Dubey wrote:
> From: Chander Kashyap <k.chander@samsung.com>
>
> The parent name added in parent list as
> mout_phyclk_mipi_dphy_4l_m_txbyte_clkhs_p, is different
> than the defined parent due to typo.
>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos5260.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

>
> diff --git a/drivers/clk/samsung/clk-exynos5260.c b/drivers/clk/samsung/clk-exynos5260.c
> index 64596ba..4db4e8d 100644
> --- a/drivers/clk/samsung/clk-exynos5260.c
> +++ b/drivers/clk/samsung/clk-exynos5260.c
> @@ -1579,7 +1579,7 @@ struct samsung_fixed_rate_clock fixed_rate_clks[] __initdata = {
>   	FRATE(PHYCLK_HDMI_LINK_O_TMDS_CLKHI, "phyclk_hdmi_link_o_tmds_clkhi",
>   			NULL, CLK_IS_ROOT, 125000000),
>   	FRATE(PHYCLK_MIPI_DPHY_4L_M_TXBYTECLKHS,
> -			"phyclk_mipi_dphy_4l_m_txbyteclkhs" , NULL,
> +			"phyclk_mipi_dphy_4l_m_txbyte_clkhs" , NULL,
>   			CLK_IS_ROOT, 187500000),
>   	FRATE(PHYCLK_DPTX_PHY_O_REF_CLK_24M, "phyclk_dptx_phy_o_ref_clk_24m",
>   			NULL, CLK_IS_ROOT, 24000000),
>

