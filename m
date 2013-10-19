Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3JSV46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:56:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43137 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3JSV44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:56:56 -0400
Message-ID: <52630027.2010501@infradead.org>
Date: Sat, 19 Oct 2013 14:56:55 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs/namei.c: fix new kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add @path parameter to fix kernel-doc warning.
Also fix a spello/typo.

Warning(fs/namei.c:2304): No description found for parameter 'path'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 fs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lnx-312-rc6.orig/fs/namei.c
+++ lnx-312-rc6/fs/namei.c
@@ -2294,10 +2294,11 @@ out:
  * path_mountpoint - look up a path to be umounted
  * @dfd:	directory file descriptor to start walk from
  * @name:	full pathname to walk
+ * @path:	pointer to container for result
  * @flags:	lookup flags
  *
  * Look up the given name, but don't attempt to revalidate the last component.
- * Returns 0 and "path" will be valid on success; Retuns error otherwise.
+ * Returns 0 and "path" will be valid on success; Returns error otherwise.
  */
 static int
 path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags)
