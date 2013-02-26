Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3BZLEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:04:25 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58360 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab3BZLEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:04:14 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] metag: remove unused ARCH_NO_VIRT_TO_BUS
Date: Tue, 26 Feb 2013 11:04:02 +0000
Message-ID: <1361876642-10247-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
References: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_26_11_04_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the patch "arch Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS",
ARCH_NO_VIRT_TO_BUS has been removed in favour of architectures
selecting HAVE_VIRT_TO_BUS if they do provide the
virt_to_bus/bus_to_virt interfaces. Therefore remove the now superfluous
definition of ARCH_NO_VIRT_TO_BUS in arch/metag/Kconfig.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/metag/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index bc3de76..afc8973 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -33,9 +33,6 @@ config METAG
 	select OF_EARLY_FLATTREE
 	select SPARSE_IRQ
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
-- 
1.8.1.2


