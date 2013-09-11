Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3IKTbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:31:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41956 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3IKTbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:31:32 -0400
Date: Wed, 11 Sep 2013 12:30:40 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>, Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Jiri Kosina <jkosina@suse.cz>,
        Jan Beulich <jbeulich@suse.com>, Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] vsprintf: drop comment claiming %n is ignored
Message-ID: <20130911193040.GA16688@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The %n format is not ignored, so remove the incorrect comment about it.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/vsprintf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..d25d1f8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1576,7 +1576,6 @@ qualifier:
  *   case.
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
- * %n is ignored
  *
  * ** Please update Documentation/printk-formats.txt when making changes **
  *
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
