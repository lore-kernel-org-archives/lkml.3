Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3KLTm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:42:59 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:60490 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3KLTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>, linux-am33-list@redhat.com
Subject: [PATCH 04/17] mn10300: Use Kbuild logic to include <asm-generic/sections.h>
Date: Tue, 12 Nov 2013 20:42:14 +0100
Message-Id: <1384285347-13506-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-am33-list@redhat.com
---
 arch/mn10300/include/asm/Kbuild     |    1 +
 arch/mn10300/include/asm/sections.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 arch/mn10300/include/asm/sections.h

diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 74742dc6a3da..cd33bcfc49d8 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += preempt.h
diff --git a/arch/mn10300/include/asm/sections.h b/arch/mn10300/include/asm/sections.h
deleted file mode 100644
index 2b8c5160388f..000000000000
--- a/arch/mn10300/include/asm/sections.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sections.h>
-- 
1.7.9.5

