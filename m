Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaF3WQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:16:24 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:44043 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaF3WPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:15:47 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/4] ARM: configs: enable SMP in bcm_defconfig
Date: Mon, 30 Jun 2014 17:15:38 -0500
Message-Id: <1404166540-4457-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404166540-4457-1-git-send-email-elder@linaro.org>
References: <1404166540-4457-1-git-send-email-elder@linaro.org>
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
index dcfc559..0339c5e 100644
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

