Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaKLCuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:50:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:55320 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbaKLCub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:50:31 -0500
X-AuditID: cbfee68e-f79b46d000002b74-a9-5462caf58c57
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 0/2] ARM: dts: Fix the number of DMA channels for Exynos3250/4
Date: Wed, 12 Nov 2014 11:50:27 +0900
Message-id: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWyRsSkSPfbqaQQg3drmS0mrTvAZHH9y3NW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38fkwO7xd9ULZo/NS+o9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK+PRpGbmgsesFSu6G5kbGK+zdDFycEgImEhcafLvYuQEMsUkLtxbz9bFyMUh
	JLCUUeLwthfMEAkTibWrprFDJBYxSszbsoAJwmlikjizrw+sik1AS2L/ixtsILaIgKREU8Mf
	ZpAiZoEtjBLf9x9mB0kICwRI3Px4nAnEZhFQlZj0oIsN5AxeAReJHR85IbYpSCxbPpMVpFdC
	4DebxOkzO6HqBSS+TT4EdbasxKYDUNdJShxccYNlAqPgAkaGVYyiqQXJBcVJ6UVGesWJucWl
	eel6yfm5mxiBoXr637O+HYw3D1gfYhTgYFTi4c3YnBQixJpYVlyZe4jRFGjDRGYp0eR8YETk
	lcQbGpsZWZiamBobmVuaKYnzJkj9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKKQcFnmc
	Q62HlWmnHM82hq8dkfHcGgksLM/WWTpnStTNtV1YErDjV/XZe2ceq6oInGKY67dIZ/rpfRH+
	YlkmPyd/my0e5XWkUUimaH9cWQfjbcfNq4UrH7k3Nwr/vdtrsYHH9aJtpV7+45/fpVcbX5Dz
	a/XUt534UVFVPnFW99azrJV1KtxKLMUZiYZazEXFiQAXAx6dUAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xgO7XU0khBvMOW1hMWneAyeL6l+es
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/Jgd3j76oXzB6bl9R79G1ZxejxeZNcAEtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMR5OamQses1as6G5kbmC8ztLFyMkh
	IWAisXbVNHYIW0ziwr31bF2MXBxCAosYJeZtWcAE4TQxSZzZ18cMUsUmoCWx/8UNNhBbREBS
	oqnhDzNIEbPAFkaJ7/sPg40SFgiQuPnxOBOIzSKgKjHpQRdQAwcHr4CLxI6PnBDbFCSWLZ/J
	OoGRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Fh4Jr2DcVWDxSFGAQ5GJR7ejM1J
	IUKsiWXFlbmHGCU4mJVEeB8sBQrxpiRWVqUW5ccXleakFh9iNAVaPpFZSjQ5HxineSXxhsYm
	ZkaWRuaGFkbG5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGCMZNUQlZH+7CK96sfh5tHCY
	zHSeNaWyR7Mfb2oNSSvmfpgwZ9266vf7ZrK9O7c467kX3/a9p443HPw74eOauzHpv5acLArb
	JqnfLf3x8IWlRYwSqkcf8V9ZlrZafOE+9X16RnO8eYq63pbu37dE/8TPr5tD7khXn44+IlPd
	+992+rQtAqpxa3SUWIozEg21mIuKEwGM16lEmwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix minor issuse to correct the number of DMA channels for
Exynos3250 and Exynos4 series. The PL330 DMA of Exynos3250/Exynos4 support
16 channels simultaneously but, PL330 DMA driver don't use 'dma-channels'
property directly. This patchset fix the correct information
of Exynos3250/Exynos4's PL330 DMA simply.

Changes from v1:
- Fix the nubmer for DMA channesl for Exynos4415

Chanwoo Choi (2):
  ARM: dts: Fix the number of DMA channels for Exynos3250
  ARM: dts: Fix the number of DMA channels for Exynos4

 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 arch/arm/boot/dts/exynos4.dtsi    | 4 ++--
 arch/arm/boot/dts/exynos4415.dtsi | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
1.8.5.5

