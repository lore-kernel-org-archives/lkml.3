Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab3AQDCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:02:00 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48752 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903Ab3AQCyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:55 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 85/86] mm: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:54:17 -0800
Message-Id: <1358391258-1771-86-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Jan Beulich <JBeulich@novell.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 278e3ab..308fdca 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1,6 +1,6 @@
 config SELECT_MEMORY_MODEL
 	def_bool y
-	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
+	depends on ARCH_SELECT_MEMORY_MODEL
 
 choice
 	prompt "Memory model"
-- 
1.7.9.5

