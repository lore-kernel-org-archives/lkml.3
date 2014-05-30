Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbaE3W3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:29:48 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50711 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaE3W3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:29:04 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, jason@lakedaemon.net,
        lorenzo.pieralisi@arm.com, mark.rutland@arm.com, pawel.moll@arm.com,
        rdunlap@infradead.org, rjui@broadcom.com, robh+dt@kernel.org,
        rvaswani@codeaurora.org
Subject: [PATCH v4 RESEND 3/5] ARM: configs: enable SMP in bcm_defconfig
Date: Fri, 30 May 2014 17:28:54 -0500
Message-Id: <1401488936-21186-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401488936-21186-1-git-send-email-elder@linaro.org>
References: <1401488936-21186-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also explicitly set CONFIG_NR_CPUS to 2, limiting it to the most we
currently need.

Signed-off-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/configs/bcm_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 3df3f3a..af1f911 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -27,6 +27,7 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_ARCH_BCM=y
 CONFIG_ARCH_BCM_MOBILE=y
 CONFIG_ARM_THUMBEE=y
+CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
 # CONFIG_COMPACTION is not set
-- 
1.9.1

