Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaDNQz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:55:59 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:59777 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaDNQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:55:56 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial 2/2] Kconfig.debug: Grammar s/addition/additional/
Date: Mon, 14 Apr 2014 18:55:50 +0200
Message-Id: <1397494550-22252-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397494550-22252-1-git-send-email-geert@linux-m68k.org>
References: <1397494550-22252-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 lib/Kconfig.debug |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 140b66a874c1..3da1ba468305 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -576,8 +576,8 @@ config DEBUG_HIGHMEM
 	bool "Highmem debugging"
 	depends on DEBUG_KERNEL && HIGHMEM
 	help
-	  This options enables addition error checking for high memory systems.
-	  Disable for production systems.
+	  This option enables additional error checking for high memory
+	  systems.  Disable for production systems.
 
 config HAVE_DEBUG_STACKOVERFLOW
 	bool
-- 
1.7.9.5

