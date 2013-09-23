Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3IWMLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:11:13 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16074 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3IWMLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:11:08 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-74-52402fda2e0b
From: Tomasz Figa <t.figa@samsung.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH v2] irqchip: exynos-combiner: remove hard-coded irq_base
 value
Date: Mon, 23 Sep 2013 14:10:55 +0200
Message-id: <28750420.TCzZ6UT49K@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379937815-21746-1-git-send-email-chander.kashyap@linaro.org>
References: <1379937815-21746-1-git-send-email-chander.kashyap@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xq7q39B2CDPqfSFk8XH+TxaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBabN01ltjg2YwmjA7vHnWt72DzenTvH7rF5Sb1H35ZVjB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZay5cJO94BZLRdvJLuYGxnfMXYycHBICJhKvTkxkgrDFJC7cW8/W
	xcjFISSwlFFi3aSJzBBOF5PEu/+P2UCq2ATUJD43PAKzRQQMJNbtamIEsZkFNjNKHJ/KCmIL
	C4RItB37DxTn4GARUJW4OVsEJMwroCVx98oqsBJ+AXWJd9uegi0WFXCV+LRwIzuIzSngLbH3
	8m6wkUICXhKH3s5mgugVlPgx+R4LxCp5iX37IVYxA81cv/M40wRGwVlIymYhKZuFpGwBI/Mq
	RtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJDQ/7qDcekxq0OMAhyMSjy8EYn2QUKsiWXFlbmH
	GCU4mJVEeBcpOgQJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYEyL3dDNLnd/w45G6flnz4osnptQ
	tdTzT2zKo+I25XViv9Is/4TMztewvL9rnbKWv0xKtZuxyf2P77e93RRhd3fmqbfPZuzIud8X
	13XGWUF24eod/5Vclvq8Df+xSc/bYL2j48yC6G27laRlzk8vXZZveufcqY637hpG3fM6lbx+
	WnLNcmq6sUqJpTgj0VCLuag4EQAjZV3+WwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chander,

On Monday 23 of September 2013 17:33:35 Chander Kashyap wrote:
> Replace irq_domain_add_simple with "irq_domain_add_linear" in order to
> use linear irq domain, and to remove hardcoded irq_base_value.
> 
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> ---
> Changes since v1:
> 	- Replaced irq_domain_add_simple with irq_domain_add_linear,
> 	  as suggested by Tomasz
> 
>  drivers/irqchip/exynos-combiner.c |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

