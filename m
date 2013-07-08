Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3GHFKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 01:10:11 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57436 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3GHFKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 01:10:09 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: msalter@redhat.com, a-jacquiot@ti.com
Cc: linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] c6x: remove unused parameter in Kconfig
Date: Mon,  8 Jul 2013 07:09:51 +0200
Message-Id: <1373260191-23158-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the TMS320C6X_CACHES_ON kernel configuration
parameter defined in arch/c6x/Kconfig, but used nowhere
in the makefiles and source code.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/c6x/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index f6a3648..7d10256 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -106,10 +106,6 @@ menu "Processor type and features"
 
 source "arch/c6x/platforms/Kconfig"
 
-config TMS320C6X_CACHES_ON
-	bool "L2 cache support"
-	default y
-
 config KERNEL_RAM_BASE_ADDRESS
 	hex "Virtual address of memory base"
 	default 0xe0000000 if SOC_TMS320C6455
-- 
1.8.1.2

