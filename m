Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab3HMUWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:22:48 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13011 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab3HMUUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:21 -0400
Message-ID: <201308132020.r7DKKJvU022742@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 14:00:04 -0400
Subject: [PATCH] tile: use asm-generic version of <asm/local64.h>
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 4c0b3c2..c5737f1 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -16,6 +16,7 @@ generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += local.h
+generic-y += local64.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
-- 
1.8.3.1

