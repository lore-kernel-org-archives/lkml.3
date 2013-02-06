Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3BFM6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:58:25 -0500
Received: from multi.imgtec.com ([194.200.65.239]:18346 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3BFM6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:58:22 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Jonas Bonn <jonas@southpole.se>,
        <linux@openrisc.net>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 1/1] openrisc: remove CONFIG_SYMBOL_PREFIX
Date: Wed, 6 Feb 2013 12:58:08 +0000
Message-ID: <1360155488-12600-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_06_12_58_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the SYMBOL_PREFIX Kconfig symbol as it's empty anyway.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/openrisc/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 0ac66f6..35a4e5f 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -26,10 +26,6 @@ config OPENRISC
 config MMU
 	def_bool y
 
-config SYMBOL_PREFIX
-        string
-        default ""
-
 config HAVE_DMA_ATTRS
 	def_bool y
 
-- 
1.7.7.6


