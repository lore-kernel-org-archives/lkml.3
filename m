Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3KSOvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:51:47 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56702 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3KSOvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:51:44 -0500
MIME-Version: 1.0
In-Reply-To: <1384853812-15253-1-git-send-email-geyslan@gmail.com>
References: <1384853812-15253-1-git-send-email-geyslan@gmail.com>
Date: Tue, 19 Nov 2013 12:51:43 -0200
Message-ID: <CAGG-pUQqhc1hpNC9TdhCxQPaL00oGUfv5eE_6SzddxEB6nLgiQ@mail.gmail.com>
Subject: Fwd: [PATCH] fs: binfmt_elf: add ELF reference in header comment
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS...), linux-kernel@vger.kernel.org (open
	list)" <linux-fsdevel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the specification "System V Application Binary Interface"
reference to header comment.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/binfmt_elf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 571a423..18938f9 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2,9 +2,10 @@
  * linux/fs/binfmt_elf.c
  *
  * These are the functions used to load ELF format executables as used
- * on SVr4 machines.  Information on the format may be found in the book
- * "UNIX SYSTEM V RELEASE 4 Programmers Guide: Ansi C and Programming Support
- * Tools".
+ * on SVr4 machines. Information on the format may be found in the
+ * specification "System V Application Binary Interface" provided by SCO,
+ * as well as in the book "UNIX SYSTEM V RELEASE 4 Programmers Guide: Ansi C
+ * and Programming Support Tools".
  *
  * Copyright 1993, 1994: Eric Youngdale (ericy@cais.com).
  */
--
1.8.4.2
