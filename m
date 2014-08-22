Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaHVJsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:48:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64518 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaHVJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:46:49 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-76-53f71186d43d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCHv2 5/5] ARM: dts: Fix wrong compatible string of
 Exynos3250 RTC dt node
Date: Fri, 22 Aug 2014 18:46:42 +0900
Message-id: <1408700802-15673-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408700802-15673-1-git-send-email-cw00.choi@samsung.com>
References: <1408700802-15673-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkQLdN8HuwQddqC4slF6+yW8xZv4bN
	4vqX56wWvQuuslmcbXrDbnF51xw2ixnn9zFZ7O/sYHTg8Ngz8SSbx4kZv1k8+rasYvSYPu8n
	k8fnTXIBrFFcNimpOZllqUX6dglcGXv65rMX/GKrOHqipoHxEWsXIweHhICJxPF7Dl2MnECm
	mMSFe+vZuhi5OIQEljJKPDh3mhUiYSLxo3EyI0RiOqPEuZ0vmCCcJiaJKXd6GUGq2AS0JPa/
	uMEGYosISEgsmXMHrINZ4AajxMLFX8BGCQvES0z7sYAFZDWLgKrE444MkDCvgKvE8lkvmSG2
	yUl82POIHcTmFHCT6G/pZwIpFwKqufihBGSkhMAydonWX+1gI1kEBCS+TT7EAvGNrMSmA1Bj
	JCUOrrjBMoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwGA//e9Z3w7GmwesDzEm
	A42byCwlmpwPjJa8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUkt
	PsTIxMEp1cCoW5q6RuDlvf3V95QDfh84n2+WzJ0z6Ueuf6JKRITVtSUHlXdc+Mu2+ad88IpY
	S+cpkaqKjhtjfPZmXLlVUOlpmlHgF3L9xeY1hwuefZm8QP6T8P3WdEG1nnSVFVtXXm9bKbBS
	dVvWfd6U2MrtYvLePydLX/PPSorUSLHT/yKU9U9yb20Sz0olluKMREMt5qLiRACsf6gujAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jQd02we/BBi9m6lksuXiV3WLO+jVs
	Fte/PGe16F1wlc3ibNMbdovLu+awWcw4v4/JYn9nB6MDh8eeiSfZPE7M+M3i0bdlFaPH9Hk/
	mTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixp28+e8Evtoqj
	J2oaGB+xdjFyckgImEj8aJzMCGGLSVy4t56ti5GLQ0hgOqPEuZ0vmCCcJiaJKXd6warYBLQk
	9r+4wQZiiwhISCyZc4cRpIhZ4AajxMLFX8DGCgvES0z7sYCli5GDg0VAVeJxRwZImFfAVWL5
	rJfMENvkJD7secQOYnMKuEn0t/QzgZQLAdVc/FAygZF3ASPDKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgaHomvYNxVYPFIUYBDkYlHt6IL1+DhVgTy4orcw8xSnAwK4nw/uD7HizEm5JY
	WZValB9fVJqTWnyI0RToponMUqLJ+cBIzyuJNzQ2MTOyNDI3tDAyNlcS5z3Yah0oJJCeWJKa
	nZpakFoE08fEwSnVwLjcU3VFi6pTb/QZma3Tczl+h9wK3yXI8St2ylwrWZ/9K2+53F59lkEl
	ib/lwNW1Nmt5dwVu/bJvTs7/55aLBWUKbU7ry9eE1ApVl5+/z/3scESZR8VXF8OZ1c/tupfN
	c3v2PHDb0xWnRPzmKgcv5X7V5VvE07dF5v6Ej2LHrN5xSX17Edz2/IISS3FGoqEWc1FxIgDT
	rAokvAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix wrong compatible string of Exynos3250 RTC (Real-Time Clock) dt
node. The RTC of Exynos3250 must need additional source clock (XrtcXTI).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index cd6a69a..1be5ef8 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -192,7 +192,7 @@
 		};
 
 		rtc: rtc@10070000 {
-			compatible = "samsung,s3c6410-rtc";
+			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
 			interrupts = <0 73 0>, <0 74 0>;
 			status = "disabled";
-- 
1.8.0

