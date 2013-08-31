Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3HaLo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:44:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49664 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757078Ab3HaLoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:44:54 -0400
X-Sasl-enc: mv7zonGxoOgvSo62fGSjSWqd5NAiAQYvpF4mua3xPQOL 1377949389
Subject: [PATCH 09/10] autofs - update fs/autofs4/Makefile
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 Aug 2013 19:43:07 +0800
Message-ID: <20130831114307.11807.68114.stgit@perseus.themaw.net>
In-Reply-To: <20130831114133.11807.35953.stgit@perseus.themaw.net>
References: <20130831114133.11807.35953.stgit@perseus.themaw.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Makefile to build from source in fs/autofs instead of
fs/autofs4.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/autofs4/Makefile b/fs/autofs4/Makefile
index a811c1f..417dd72 100644
--- a/fs/autofs4/Makefile
+++ b/fs/autofs4/Makefile
@@ -4,4 +4,6 @@
 
 obj-$(CONFIG_AUTOFS4_FS) += autofs4.o
 
-autofs4-objs := init.o inode.o root.o symlink.o waitq.o expire.o dev-ioctl.o
+autofs4-objs := ../autofs/init.o ../autofs/inode.o ../autofs/root.o \
+	../autofs/symlink.o ../autofs/waitq.o ../autofs/expire.o \
+	../autofs/dev-ioctl.o

