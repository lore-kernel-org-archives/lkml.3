Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaEHDt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:49:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27395 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaEHDtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:49:05 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-20-536afeae7755
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 1/4] clk: samsung: add new Kconfig for Samsung common clock
 option
Date: Thu, 08 May 2014 13:07:08 +0900
Message-id: <1399522031-3394-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t8zI911/7KCDQ7+lrDoXXCVzWLT42us
	Fpd3zWGzmHF+H5PF0wkX2SwWbf3CbrF+xmsWB3aPO9f2sHlsXlLv0bdlFaPH501yASxRXDYp
	qTmZZalF+nYJXBktv5uZC06xV1xe+ZC1gXEdWxcjJ4eEgInEtd1nWCFsMYkL99YDxbk4hASW
	MUr8eb2bHaZoy/MXjBCJ6YwSjzpnQTltTBIfr00Fa2cT0JV48n4uM4gtIpAtcaXxPjNIEbNA
	A6PEsn8nwIqEBcIl/tx8C2RzcLAIqEp8vOMBEuYVcJdY9mQdWFhCQEFiziQbEJNTwENi8klr
	kAohoIp3xzeDHSchMJldYnPzJ7CJLAICEt8mH2KBaJWV2HSAGeJmSYmDK26wTGAUXsDIsIpR
	NLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJLD7djDePGB9iDEZaNxEZinR5HxgZOSVxBsamxlZ
	mJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk4pYJgcfy40yeNXiK/9
	xMoX5uaz531T9LEQsGY/e+xYxqZvisurT3a3T2e8MvHwVZdnD1esZ7+pusJh70LJWV2Ol/gN
	BCf4uSguyb1pbbzjkwbv0kXtK40FHwgvPJ17lS/rsOi5Dg1xucnSXGxrlrxcaH3/qsyuY0/5
	D9dISbE+Xn1CKX2HBf8WrwlKLMUZiYZazEXFiQCtno8xggIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd11/7KCDebvFrHoXXCVzWLT42us
	Fpd3zWGzmHF+H5PF0wkX2SwWbf3CbrF+xmsWB3aPO9f2sHlsXlLv0bdlFaPH501yASxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzWn43MxecYq+4vPIhawPjOrYuRk4O
	CQETiS3PXzBC2GISF+6tB4pzcQgJTGeUeNQ5ixHCaWOS+HhtKitIFZuArsST93OZQWwRgWyJ
	K433mUGKmAUaGCWW/TsBViQsEC7x5+ZbIJuDg0VAVeLjHQ+QMK+Au8SyJ+vAwhICChJzJtmA
	mJwCHhKTT1qDVAgBVbw7vpltAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBcfNM
	agfjygaLQ4wCHIxKPLwZzlnBQqyJZcWVuYcYJTiYlUR4/ScDhXhTEiurUovy44tKc1KLDzEm
	A500kVlKNDkfGNN5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp
	1cB4RKbY99GE6Wtelkw6aO6hbKrf/Er65uxXz3ruNl3Rm2krpm2/2O+Cp7H90dyq478X7ZBn
	Ys6b5uRv0Hn4rd/EybfKkyy/XV1y7nxtov/2hEVar523pc2awN8jq7k4Rvtp8pL3y1w98qb0
	yTKeKs/yiV9pNudPabVxVd/qdJVZ5z1kiwwebXNUYinOSDTUYi4qTgQAAYftlN8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new Kconfig file for adding new COMMON_CLK_SAMSUNG option.
Samsung platforms can select this for using common clock infrastructure.

CC: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/Kconfig         |    2 ++
 drivers/clk/samsung/Kconfig |    3 +++
 2 files changed, 5 insertions(+)
 create mode 100644 drivers/clk/samsung/Kconfig

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 6f56d3a..ba24366 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -115,3 +115,5 @@ endmenu
 
 source "drivers/clk/bcm/Kconfig"
 source "drivers/clk/mvebu/Kconfig"
+
+source "drivers/clk/samsung/Kconfig"
diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
new file mode 100644
index 0000000..fc8696b
--- /dev/null
+++ b/drivers/clk/samsung/Kconfig
@@ -0,0 +1,3 @@
+config COMMON_CLK_SAMSUNG
+	bool
+	select COMMON_CLK
-- 
1.7.10.4

