Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3LEXCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:02:01 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32541 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3LEXBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:01:55 -0500
X-IronPort-AV: E=Sophos;i="4.93,836,1378882800"; 
   d="scan'208";a="384576"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        ARM Linux List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH 2/2] ARM: bcm_defconfig: Unset CONFIG_CRYPTO_ANSI_CPRNG
Date: Thu, 5 Dec 2013 15:00:38 -0800
Message-ID: <1386284438-11099-3-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386284438-11099-1-git-send-email-tim.kryger@linaro.org>
References: <1386284438-11099-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not build the Pseudo Random Number Generation for Cryptographic
modules since it is not currently being used for this platform.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/configs/bcm_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defconfig
index 574e046..ef03bba 100644
--- a/arch/arm/configs/bcm_defconfig
+++ b/arch/arm/configs/bcm_defconfig
@@ -119,6 +119,7 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=110
 CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
 # CONFIG_FTRACE is not set
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_CCITT=y
 CONFIG_CRC_T10DIF=y
 CONFIG_CRC_ITU_T=y
-- 
1.8.0.1

