Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaCJBCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:02:07 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:47841 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaCJBCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:02:03 -0400
X-Originating-IP: 50.43.32.211
Date: Sun, 9 Mar 2014 18:01:57 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] include/asm-generic/bug.h: Style fix:
 s/while(0)/while (0)/
Message-ID: <45d1d28f74a37455110d254f3da596584e88da75.1394412745.git.josh@joshtriplett.org>
References: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v3: Patch unchanged from v2.
 include/asm-generic/bug.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7ecd398..2d54d8d 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -52,7 +52,7 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
 #endif
 
 /*
@@ -138,11 +138,11 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
+#define BUG() do {} while (0)
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
+#define BUG_ON(condition) do { if (condition) ; } while (0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
-- 
1.9.0

