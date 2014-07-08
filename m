Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaGHNGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:06:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12626 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaGHNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:06:45 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-f1-53bbece22eb9
Message-id: <53BBECC3.9020202@samsung.com>
Date: Tue, 08 Jul 2014 15:06:11 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] clk: samsung: Make of_device_id array const
References: <1403784006-17605-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1403784006-17605-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xy7qP3uwONji7ytri9QtDi94FV9ks
	Nj2+xmpxedccNosZ5/cxWTydcJHNgc3jzrU9bB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqR
	vl0CV8aEdXuYC1azVlxqbmVtYJzP0sXIySEhYCLR+WcpO4QtJnHh3nq2LkYuDiGBpYwSe69s
	ASsSEvjMKPH2JweIzSugJdH7pwmoiIODRUBVonthHkiYTUBN4nPDIzYQmx+oZE3TdRaQElGB
	CInHF4QgOgUlfky+BzZRROAVo8Thh04gtrCAu8TGWweYIDa5S6xsnsAIYnMKeEhMmfwC7DRm
	AR2J/a3T2CBseYnNa94yT2AUmIVk7CwkZbOQlC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpec
	n7uJERLIX3YwLj5mdYhRgINRiYdXo3Z3sBBrYllxZe4hRgkOZiUR3i+ngEK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYw1XWSnc7/JqqG75Shff0xdfui4sNPlveOJuo8lim3+7wnPPX5Znq1so2
	Jyw+Ky0r/lBrEtPx/uMuC9ZE5E25bNHTeyc6KD7kzVeD2TemLt4nuPOI+YIJZ6PtZX/7P7z9
	O+PDYo/D8esq2C/JXKgLPre+6dsy4ZYdzEu/zW/9y1M899v2BTVddkosxRmJhlrMRcWJAIKw
	aDNCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 26.06.2014 14:00, Krzysztof Kozlowski wrote:
> Array of struct of_device_id may be be const as expected by
> of_match_table field and of_find_matching_node_and_match() function.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/clk/samsung/clk-exynos4.c    | 2 +-
>  drivers/clk/samsung/clk-exynos5250.c | 2 +-
>  drivers/clk/samsung/clk-exynos5420.c | 2 +-
>  drivers/clk/samsung/clk-exynos5440.c | 2 +-
>  drivers/clk/samsung/clk.c            | 2 +-
>  drivers/clk/samsung/clk.h            | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 

Thanks for the patch. Will apply.

Best regards,
Tomasz
