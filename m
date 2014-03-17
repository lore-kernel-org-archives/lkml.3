Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaCQJT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:19:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29404 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbaCQJTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:19:31 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b4-5326be20f7b0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 2/3] mfd: sec-core: Add of_compatible strings for clock MFD
 cells
Date: Mon, 17 Mar 2014 10:19:17 +0100
Message-id: <1395047958-17953-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
References: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xq7oK+9SCDZYcNLXYOGM9q8XrF4YW
	Z5vesFvc/3qU0WLT42usFpd3zWGzmHF+H5PF2iN32S2eTrjIZnHyTy+jxeluVouLK74wWayf
	8ZrFov3vXjaLOdPfMTnwe9y5tofNY97JQI/NS+o9+rasYvT4vEkugDWKyyYlNSezLLVI3y6B
	K+PhsluMBevZK5bc283SwPiMtYuRk0NCwERi4rReZghbTOLCvfVsXYxcHEICSxklXje9YIRw
	+pgkdk3cDFbFJmAssXn5ErAqEYFmJol9Xx8zgTjMAm+ZJO4cuskOUiUsECZxtOkUG4jNIqAq
	8bPhHtg+XgF3iY5rF4EmcQDtU5CYM8kGxOQU8JD4tZkPpEIIqKJt4WSWCYy8CxgZVjGKppYm
	FxQnpeca6RUn5haX5qXrJefnbmKEhOfXHYxLj1kdYhTgYFTi4Z2grBYsxJpYVlyZe4hRgoNZ
	SYS3dBtQiDclsbIqtSg/vqg0J7X4ECMTB6dUAyOPrsLx/zFp2+qEegtbmrvPOqpJy63q8dgc
	Uxn6t4IzsyY+oPjW3EjTuRWBRXt/5gtklf234m8T3PKQ3TV49f8JTxWmzFK9NrOVd+q9lJPc
	Fz2V8m1l9xneOJimH3Iz7obB8s+FO8SD5msramc3bQ9VKK2aOlXGUiQos/TbSe4LN1ZH12v3
	KrEUZyQaajEXFScCAN4tuD4tAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_compatible strings for S5M8767 and S2MPS14 clock MFD cells.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index d163c66edebb..716606479235 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -59,6 +59,7 @@ static const struct mfd_cell s5m8767_devs[] = {
 		.name = "s5m-rtc",
 	}, {
 		.name = "s5m8767-clk",
+		.of_compatible = "samsung,s5m8767-clk",
 	}
 };
 
@@ -67,6 +68,7 @@ static const struct mfd_cell s2mps11_devs[] = {
 		.name = "s2mps11-pmic",
 	}, {
 		.name = "s2mps11-clk",
+		.of_compatible = "samsung,s2mps11-clk",
 	}
 };
 
@@ -77,6 +79,7 @@ static const struct mfd_cell s2mps14_devs[] = {
 		.name = "s2mps14-rtc",
 	}, {
 		.name = "s2mps14-clk",
+		.of_compatible = "samsung,s2mps14-clk",
 	}
 };
 
-- 
1.7.9.5

