Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab3JPLDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:03:45 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:43989 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934112Ab3JPLDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/8] Documentation/zorro.txt: Update path to arch-specific header files
Date: Wed, 16 Oct 2013 13:03:18 +0200
Message-Id: <1381921405-11206-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
References: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Arch-specific headers were moved to arch/<arch/>/include/asm,
  - APUS support was dropped a long time ago

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-doc@vger.kernel.org
---
 Documentation/zorro.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/zorro.txt b/Documentation/zorro.txt
index d5829d14774a..d17670400564 100644
--- a/Documentation/zorro.txt
+++ b/Documentation/zorro.txt
@@ -95,7 +95,7 @@ The treatment of these regions depends on the type of Zorro space:
 -------------
 
 linux/include/linux/zorro.h
-linux/include/asm-{m68k,ppc}/zorro.h
+linux/arch/m68k/include/asm/zorro.h
 linux/include/linux/zorro_ids.h
 linux/drivers/zorro
 /proc/bus/zorro
-- 
1.7.9.5

