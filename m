Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3FJHKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:10:15 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:44199 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3FJHKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:10:14 -0400
MIME-Version: 1.0
From: =?UTF-8?B?5Yav5Yqb?= <lifeng1519@gmail.com>
Date: Mon, 10 Jun 2013 15:09:43 +0800
Message-ID: <CAEK8JBBKfNaUVkk7nvHki4TDiLFExkoGR5QTxDujxgtk4QyvkQ@mail.gmail.com>
Subject: [PATCH] fs/cepth compile error
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I try to compile kernel v3.9.2 v3.9.5, It outputs couldn't find fs/cepth/ioctl.o
Go to the dir and couldn't find the ioctl.c,only a ioctl.h file.But
the ioctl.h isn't included by other file.
So simply remove ioctl.o from the Makefile to fix.

Thanks

commit d8e29a9f5a2474ac0dcb26baa3cf29075f3ce980
Author: vonnyfly <lifeng1519@gmail.com>
Date:   Mon Jun 10 14:53:38 2013 +0800

    fix ioctl.o not find error
---
 fs/ceph/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
index bd35212..e0d2294 100644
--- a/fs/ceph/Makefile
+++ b/fs/ceph/Makefile
@@ -4,7 +4,7 @@

 obj-$(CONFIG_CEPH_FS) += ceph.o

-ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
+ceph-y := super.o inode.o dir.o file.o locks.o addr.o \
        export.o caps.o snap.o xattr.o \
        mds_client.o mdsmap.o strings.o ceph_frag.o \
        debugfs.o

--
Thanks and Best Regards,
vonnyfly

Cell:13401157876
Email :lifeng1519@gmail.com
Addr: Rm. 911,DaYunCun,Zhichun Road,Haidian Districts Beijing,100191
