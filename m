Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3GVAk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:40:28 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52791 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3GVAk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:40:27 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] MAINTAINERS: Fix incorrect status tag
Date: Mon, 22 Jul 2013 01:40:22 +0100
Message-Id: <1374453622-22925-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I removed myself from the xilinx drivers I used the wrong tag. Fix
it.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---

I'll merge this through my tree with my other MAINTAINERS changes.

 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1128d92..198f3cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4986,7 +4986,7 @@ F:	arch/powerpc/platforms/44x/
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
 L:	linuxppc-dev@lists.ozlabs.org
-S:	Unmaintained
+S:	Orphan
 F:	arch/powerpc/*/*virtex*
 F:	arch/powerpc/*/*/*virtex*
 
@@ -9294,7 +9294,7 @@ S:	Maintained
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX SYSTEMACE DRIVER
-S:	Unmaintained
+S:	Orphan
 F:	drivers/block/xsysace.c
 
 XILINX UARTLITE SERIAL DRIVER
-- 
1.8.1.2

