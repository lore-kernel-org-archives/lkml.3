Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaAOR4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:56:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44902 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaAORzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:55:40 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, <devicetree@vger.kernel.org>
Subject: [PATCH v2 6/7] devicetree: bindings: Document Krait performance monitor units (PMU)
Date: Wed, 15 Jan 2014 09:55:34 -0800
Message-Id: <1389808535-23852-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the Krait PMU compatible string.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/pmu.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
index 3e1e498fea96..ce731441e64f 100644
--- a/Documentation/devicetree/bindings/arm/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/pmu.txt
@@ -16,7 +16,14 @@ Required properties:
 	"arm,arm11mpcore-pmu"
 	"arm,arm1176-pmu"
 	"arm,arm1136-pmu"
-- interrupts : 1 combined interrupt or 1 per core.
+	"qcom,krait-pmu"
+- interrupts : 1 combined interrupt or 1 per core. If the interrupt is a per-cpu
+               interrupt (PPI) then 1 interrupt should be specified.
+
+Optional properties:
+
+- qcom,no-pc-write : Indicates that this PMU doesn't support the 0xc and 0xd
+                     events.
 
 Example:
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

