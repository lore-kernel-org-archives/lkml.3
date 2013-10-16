Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab3JPMea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:34:30 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:41676 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934330Ab3JPMcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 11/16] m68k/UAPI: Move Apollo model definitions to <asm/bootinfo-apollo.h>
Date: Wed, 16 Oct 2013 14:31:28 +0200
Message-Id: <1381926693-6392-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/include/asm/apollohw.h             |   11 ++---------
 arch/m68k/include/uapi/asm/bootinfo-apollo.h |   12 ++++++++++++
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/include/asm/apollohw.h b/arch/m68k/include/asm/apollohw.h
index 6c19e0c22411..87fc899d32ee 100644
--- a/arch/m68k/include/asm/apollohw.h
+++ b/arch/m68k/include/asm/apollohw.h
@@ -5,18 +5,11 @@
 
 #include <linux/types.h>
 
-/*
-   apollo models
-*/
+#include <asm/bootinfo-apollo.h>
+
 
 extern u_long apollo_model;
 
-#define APOLLO_UNKNOWN (0)
-#define APOLLO_DN3000 (1)
-#define APOLLO_DN3010 (2)
-#define APOLLO_DN3500 (3)
-#define APOLLO_DN4000 (4)
-#define APOLLO_DN4500 (5)
 
 /*
    see scn2681 data sheet for more info.
diff --git a/arch/m68k/include/uapi/asm/bootinfo-apollo.h b/arch/m68k/include/uapi/asm/bootinfo-apollo.h
index 3a2051e822b0..69923697e131 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-apollo.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-apollo.h
@@ -13,4 +13,16 @@
 #define BI_APOLLO_MODEL		0x8000	/* model (u_long) */
 
 
+    /*
+     *  Apollo models (BI_APOLLO_MODEL)
+     */
+
+#define APOLLO_UNKNOWN		0
+#define APOLLO_DN3000		1
+#define APOLLO_DN3010		2
+#define APOLLO_DN3500		3
+#define APOLLO_DN4000		4
+#define APOLLO_DN4500		5
+
+
 #endif /* _UAPI_ASM_M68K_BOOTINFO_APOLLO_H */
-- 
1.7.9.5

