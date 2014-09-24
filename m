Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaIXSUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:20:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39112 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaIXSUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:20:41 -0400
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: qcom: Update SoC compatibles we support
Date: Wed, 24 Sep 2014 13:20:38 -0500
Message-Id: <1411582838-24159-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to just using the SoC name in the compatible list so we don't need
to update this for every board going forward.  Also added "qcom,msm8974"
to the list as we support "qcom,apq8074" already (the modemless version
of "qcom,msm8974").

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/mach-qcom/board.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-qcom/board.c b/arch/arm/mach-qcom/board.c
index 6d8bbf7..e3e44aa 100644
--- a/arch/arm/mach-qcom/board.c
+++ b/arch/arm/mach-qcom/board.c
@@ -16,12 +16,13 @@
 
 static const char * const qcom_dt_match[] __initconst = {
 	"qcom,apq8064",
-	"qcom,apq8074-dragonboard",
+	"qcom,apq8074",
 	"qcom,apq8084",
 	"qcom,ipq8062",
 	"qcom,ipq8064",
-	"qcom,msm8660-surf",
-	"qcom,msm8960-cdp",
+	"qcom,msm8660",
+	"qcom,msm8960",
+	"qcom,msm8974",
 	NULL
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

