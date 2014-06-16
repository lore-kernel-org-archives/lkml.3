Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaFPKpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:45:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:65388 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaFPKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:45:35 -0400
From: Scott Weir <sjw0410@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: Fix sparse warnings for undeclared symbols
Date: Mon, 16 Jun 2014 20:44:51 +1000
Message-Id: <1402915491-10885-1-git-send-email-sjw0410@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sparse warnings in drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c:
sec_lproc.c:58:6: warning: symbol 'sec_flags2str' was not declared. Should it be static?

Signed-off-by: Scott Weir <sjw0410@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c b/drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c
index 1213621..1928bf5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c
@@ -55,7 +55,7 @@
 struct proc_dir_entry *sptlrpc_proc_root = NULL;
 EXPORT_SYMBOL(sptlrpc_proc_root);

-char *sec_flags2str(unsigned long flags, char *buf, int bufsize)
+static char *sec_flags2str(unsigned long flags, char *buf, int bufsize)
 {
 	buf[0] = '\0';

--
1.9.1

