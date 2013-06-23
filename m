Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3FWCoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 22:44:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3FWCo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 22:44:29 -0400
Message-ID: <51C660F8.6050907@infradead.org>
Date: Sat, 22 Jun 2013 19:44:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs: fix new splice.c kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warning in fs/splice.c:

Warning(fs/splice.c:1298): No description found for parameter 'opos'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 fs/splice.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-310-rc7.orig/fs/splice.c
+++ lnx-310-rc7/fs/splice.c
@@ -1283,6 +1283,7 @@ static int direct_splice_actor(struct pi
  * @in:		file to splice from
  * @ppos:	input file offset
  * @out:	file to splice to
+ * @opos:	output file offset
  * @len:	number of bytes to splice
  * @flags:	splice modifier flags
  *
