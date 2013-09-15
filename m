Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3IOKBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 06:01:40 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:58201 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3IOKBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 06:01:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH TRIVIAL] mm/Kconfig: Grammar s/an/a/
Date: Sun, 15 Sep 2013 12:01:33 +0200
Message-Id: <1379239293-8272-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 026771a..ff6e820 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -20,7 +20,7 @@ config FLATMEM_MANUAL
 
 	  Some users of more advanced features like NUMA and
 	  memory hotplug may have different options here.
-	  DISCONTIGMEM is an more mature, better tested system,
+	  DISCONTIGMEM is a more mature, better tested system,
 	  but is incompatible with memory hotplug and may suffer
 	  decreased performance over SPARSEMEM.  If unsure between
 	  "Sparse Memory" and "Discontiguous Memory", choose
-- 
1.7.9.5

