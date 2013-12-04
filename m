Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3LDSeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:34:04 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:37653 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755980Ab3LDSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:33:59 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 3/4] arm64: Enable system reset via arch Kconfig for X-Gene system.
Date: Wed,  4 Dec 2013 10:33:41 -0800
Message-Id: <1386182021-26678-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enable the system reset via arch Kconfig for X-Gene platforms.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..188e787 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -116,6 +116,7 @@ config ARCH_VEXPRESS
 
 config ARCH_XGENE
 	bool "AppliedMicro X-Gene SOC Family"
+	select POWER_RESET_XGENE
 	help
 	  This enables support for AppliedMicro X-Gene SOC Family
 
-- 
1.7.6.1

