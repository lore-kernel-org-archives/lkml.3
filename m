Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaEUO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:59:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53107 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaEUO6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:58:06 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sboyd@codeaurora.org, rvaswani@codeaurora.org,
        davidb@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 3/4] ARM: qcom: Add APQ8084-MTP board to mach-qcom
Date: Wed, 21 May 2014 17:57:04 +0300
Message-Id: <1400684225-21381-4-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com>
References: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add board compatibility string to the board machine descriptors.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/mach-qcom/board.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-qcom/board.c b/arch/arm/mach-qcom/board.c
index bae617e..ae0a405 100644
--- a/arch/arm/mach-qcom/board.c
+++ b/arch/arm/mach-qcom/board.c
@@ -18,6 +18,7 @@ static const char * const qcom_dt_match[] __initconst = {
 	"qcom,msm8660-surf",
 	"qcom,msm8960-cdp",
 	"qcom,apq8074-dragonboard",
+	"qcom,apq8084-mtp",
 	NULL
 };
 
-- 
1.7.9.5

