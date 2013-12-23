Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3LWGQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:16:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45665 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LWGQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:16:15 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 1/1] sparc64: allow forced irq threading
Date: Mon, 23 Dec 2013 11:45:51 +0530
Message-Id: <1387779351-18409-1-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forced irq threading is a prerequisite for RT.
The following patch enables this on the sparc architecture.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
---
 arch/sparc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 554995d..aae5aa9 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -27,6 +27,7 @@ config SPARC
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_GENERIC_HARDIRQS
+	select IRQ_FORCED_THREADING
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select USE_GENERIC_SMP_HELPERS if SMP
-- 
1.7.10.4

