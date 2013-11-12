Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3KLToG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:44:06 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:35099 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3KLTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 09/17] microblaze: Remove duplicate declarations of _stext[] and _etext[]
Date: Tue, 12 Nov 2013 20:42:19 +0100
Message-Id: <1384285347-13506-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're already provided by <asm/sections.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
---
 arch/microblaze/include/asm/sections.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/microblaze/include/asm/sections.h b/arch/microblaze/include/asm/sections.h
index c07ed5d2a820..1b281d3ea734 100644
--- a/arch/microblaze/include/asm/sections.h
+++ b/arch/microblaze/include/asm/sections.h
@@ -16,7 +16,6 @@
 # ifndef __ASSEMBLY__
 extern char _ssbss[], _esbss[];
 extern unsigned long __ivt_start[], __ivt_end[];
-extern char _etext[], _stext[];
 
 extern u32 _fdt_start[], _fdt_end[];
 
-- 
1.7.9.5

