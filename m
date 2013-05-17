Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3EQMSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:18:46 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:52122 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3EQMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:18:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scripts/mod: Spelling s/DEVICEVTABLE/DEVICETABLE/
Date: Fri, 17 May 2013 14:18:35 +0200
Message-Id: <1368793115-7175-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 scripts/mod/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 75d59fc..ae21b89 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -15,8 +15,8 @@ endef
 quiet_cmd_offsets = GEN     $@
 define cmd_offsets
 	(set -e; \
-	 echo "#ifndef __DEVICEVTABLE_OFFSETS_H__"; \
-	 echo "#define __DEVICEVTABLE_OFFSETS_H__"; \
+	 echo "#ifndef __DEVICETABLE_OFFSETS_H__"; \
+	 echo "#define __DEVICETABLE_OFFSETS_H__"; \
 	 echo "/*"; \
 	 echo " * DO NOT MODIFY."; \
 	 echo " *"; \
-- 
1.7.0.4

