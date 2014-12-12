Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959AbaLLI2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:28:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38563 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbaLLI1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:27:55 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-fa-548aa6f6b969
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: kgene.kim@samsung.com, rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv3 7/7] ARM: dts: exynos: Add PPMU dt node to
 Exynos3250-based Rinato board
Date: Fri, 12 Dec 2014 17:27:32 +0900
Message-id: <1418372852-12454-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkSPfbsq4QgzN75S0er1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZay4
	uYql4CpXxf7WCWwNjOc4uhg5OSQETCQu39zEAmGLSVy4t56ti5GLQ0hgKaPEhpcNLDBF667/
	YIdILGKUuLv8A1RVE5PEuVn7mUGq2AS0JPa/uMEGYosImEvsWvoTrIhZ4BKTxPaZPUxdjBwc
	wgIJEgtna4DUsAioSvx5doMVxOYVcJW40vmMDWKbgsSy5TPB4pwCbhIvrm5gBGkVAqr5uaQO
	ZKSEwCl2iTVvVrJAzBGQ+Db5EAtIjYSArMSmA8wQYyQlDq64wTKBUXgBI8MqRtHUguSC4qT0
	IhO94sTc4tK8dL3k/NxNjMBIOf3v2YQdjPcOWB9iFOBgVOLhfZHaFSLEmlhWXJl7iNEUaMNE
	ZinR5HxgPOaVxBsamxlZmJqYGhuZW5opifO+lvoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoExo3L2hkMOXxkqjnyK+nym6nLb+09T5pi//KRk3/31HlfkvKCYpx9XHys+vXD2BrbTfN9U
	+b22CNRkBQT01kfLzZORtcosSZ3AyH6RKZnZd/Wb6xmXqsOidWdcmCZ9T+aoeMLxr11nbDJD
	D07y3y/DzBwb7Rytdoyv3NDjhOrMtOYN2dJcKyKVWIozEg21mIuKEwG/iD5ZjwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t9jAd1vy7pCDJ5eELd4vGYxk8XGGetZ
	La5/ec5qMf/IOVaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWtxtXsFk8
	XvGW3WLVrj+MDnweO2fdZfdYvOclk8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjFjxc1VLAVXuSr2t05ga2A8x9HFyMkhIWAise76D3YIW0zi
	wr31bF2MXBxCAosYJe4u/wDlNDFJnJu1nxmkik1AS2L/ixtsILaIgLnErqU/wYqYBS4xSWyf
	2cPUxcjBISyQILFwtgZIDYuAqsSfZzdYQWxeAVeJK53P2CC2KUgsWz4TLM4p4Cbx4uoGRpBW
	IaCan0vqJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHIfPpHYwrmywOMQowMGo
	xMP7IrUrRIg1say4MvcQowQHs5II798ooBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbnA1NE
	Xkm8obGJmZGlkbmhhZGxuZI4r5J9W4iQQHpiSWp2ampBahFMHxMHp1QDo7e9XX/2g2rFsKV+
	LkkbVrRE/fFZO6fi1yx35gOOy0sinM7O0lmzwmWZKtPEvcYexowiaQcqDUKeON2b/i3lqK/S
	4clz9GYL5Ciuucjw9HrFtAWW6gz9Hc1Tvb4WHbx709x6sdqMAp+aZ8p6Cx5Pv57oeorz1vLJ
	K25PWaa31NHTS1X3+P/4KUosxRmJhlrMRcWJAGlnZPPZAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato board. The PPMU dt node
is used to get the utilization of DMC0/DMC1/LEFTBUS/RIGHTBUS Block.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7789442..2888098 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -542,6 +542,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-dmc0-pmcnt3 {
+			event-name = "ppmu-dmc0-pmcnt3";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-dmc1-pmcnt3 {
+			event-name = "ppmu-dmc1-pmcnt3";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-leftbus-pmcnt3 {
+			event-name = "ppmu-leftbus-pmcnt3";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-rightbus-pmcnt3 {
+			event-name = "ppmu-rightbus-pmcnt3";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

