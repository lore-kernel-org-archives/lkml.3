Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaAFDzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:55:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18404 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaAFDzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:55:46 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, davem@davemloft.net, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 2/4] sparc64: allow forced irq threading
Date: Mon,  6 Jan 2014 09:25:08 +0530
Message-Id: <1388980510-10190-3-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388980510-10190-1-git-send-email-allen.pais@oracle.com>
References: <1388980510-10190-1-git-send-email-allen.pais@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forced irq threading is a prerequisite for RT.
The following patch enables this on the sparc architecture.

Acked-by: David S. Miller <davem@davemloft.net>
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

