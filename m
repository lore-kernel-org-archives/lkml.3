Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaBZDs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:48:59 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35217 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBZDs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:48:57 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 25 Feb 2014 19:48:51 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] include/asm-generic/bug.h: Style fix:
 s/while(0)/while (0)/
Message-ID: <b37138855c05cbdd6184f74fbd2e2f17bff7fb74.1393385236.git.josh@joshtriplett.org>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
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

