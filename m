Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3CLArq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:47:46 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:53807 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3CLAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:47:44 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH v3 5/7] coredump: remove trailling whitespaces
Date: Mon, 11 Mar 2013 21:48:09 -0300
Message-Id: <1363049291-946-5-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 fs/coredump.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index c647965..7dfb3b0 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -522,7 +522,7 @@ void do_coredump(siginfo_t *siginfo)
 
 	ispipe = format_corename(&cn, &cprm);
 
- 	if (ispipe) {
+	if (ispipe) {
 		int dump_count;
 		char **helper_argv;
 
@@ -576,10 +576,10 @@ void do_coredump(siginfo_t *siginfo)
 					NULL, &cprm);
 		argv_free(helper_argv);
 		if (retval) {
- 			printk(KERN_INFO "Core dump to %s pipe failed\n",
+			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       cn.corename);
 			goto close_fail;
- 		}
+		}
 	} else {
 		struct inode *inode;
 
-- 
1.8.1.5

