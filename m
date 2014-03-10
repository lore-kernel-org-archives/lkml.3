Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaCJMen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:34:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30975 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaCJMej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:34:39 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-02-531db15de225
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
Subject: [PATCH 2/3] mfd: sec-core: Add of_compatible strings for MFD cells
Date: Mon, 10 Mar 2014 13:34:17 +0100
Message-id: <1394454858-3139-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
References: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xq7qxG2WDDdY91LbYOGM9q8XrF4YW
	Z5vesFvc/3qU0WLT42usFpd3zWGzmHF+H5PF2iN32S2eTrjIZnHyTy+jxeluVouLK74wWayf
	8ZrFov3vXjaLOdPfMTnwe9y5tofNY97JQI/NS+o9+rasYvT4vEkugDWKyyYlNSezLLVI3y6B
	K2Pei3fsBTfZKq7/fczYwLiStYuRk0NCwERi8sOVzBC2mMSFe+vZuhi5OIQEljJKHD47jxnC
	6WOSuPntLRNIFZuAscTm5UvAqkQEmpkk9n19zATiMAu8ZZK4c+gmO0iVsIC3xOm/3WBzWQRU
	JbrmbwOzeQXcJD5tfA5UwwG0T0FiziQbkDCngLvE9Xnf2EBsIaCSCU/XMU5g5F3AyLCKUTS1
	NLmgOCk910ivODG3uDQvXS85P3cTIyRAv+5gXHrM6hCjAAejEg/vgbcywUKsiWXFlbmHGCU4
	mJVEeDMXywYL8aYkVlalFuXHF5XmpBYfYmTi4JRqYNyik3hqzReblMKiwN8b/p2XOMi8t9cr
	WEoioXq3btaH+1NEfQU/Fst9Vyzi2Wd3R2q+2ex+rZ7lPJ+uCGkfd3B04/deKlB5dfvtE/lb
	J6hFP1praqPzMkhy7rsHfepmanq/cvNZWK9PeTHZ+8Id1XWzP7VdvN47QyJIj63Iw523cWWt
	dTy7sBJLcUaioRZzUXEiAKVw0k4uAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_compatible strings for S5M8767 RTC, S5M8767 clock and S2MPS14
clock MFD cells.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index d163c66edebb..e8ac2e3c1f58 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -57,8 +57,10 @@ static const struct mfd_cell s5m8767_devs[] = {
 		.name = "s5m8767-pmic",
 	}, {
 		.name = "s5m-rtc",
+		.of_compatible = "samsung,s5m8767-rtc",
 	}, {
 		.name = "s5m8767-clk",
+		.of_compatible = "samsung,s5m8767-clk",
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

