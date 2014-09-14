Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaIOMgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:36:41 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:60958 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbaIOMgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:36:40 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Marek <mmarek@suse.cz>, David Woodhouse <dwmw2@infradead.org>,
        Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv2 2/2] Documentation/kbuild/headers_install.txt: update installation paths
Date: Sun, 14 Sep 2014 22:27:01 +0200
Message-Id: <60fe1d123c535a2f79841649b7f950de1863e63d.1410712841.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410712841.git.ydroneaud@opteya.com>
References: <cover.1410712841.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1410712841.git.ydroneaud@opteya.com>
References: <cover.1410712841.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation in kbuild/headers_install.txt is not up to date
regarding paths where the headers are installed.

This patch fixes the documention with the correct information.

Link: http://lkml.kernel.org/r/cover.1410712841.git.ydroneaud@opteya.com
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Marek <mmarek@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 Documentation/kbuild/headers_install.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
index 0d8fe5e871c4..72ed4d1bd408 100644
--- a/Documentation/kbuild/headers_install.txt
+++ b/Documentation/kbuild/headers_install.txt
@@ -24,20 +24,20 @@ The "make headers_install" command can be run in the top level directory of the
 kernel source code (or using a standard out-of-tree build).  It takes two
 optional arguments:
 
-  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
+  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr
 
 ARCH indicates which architecture to produce headers for, and defaults to the
-current architecture.  The linux/asm directory of the exported kernel headers
+current architecture.  Note: the asm/ directory of the exported kernel headers
 is platform-specific.
 
-INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
-"./usr/include".
+INSTALL_HDR_PATH indicates where to create include/ directory to install the
+headers. It defaults to "./usr/".
 
 The command "make headers_install_all" exports headers for all architectures
 simultaneously.  (This is mostly of interest to distribution maintainers,
 who create an architecture-independent tarball from the resulting include
 directory.)  You also can use HDR_ARCH_LIST to specify list of architectures.
-Remember to provide the appropriate linux/asm directory via "mv" or "ln -s"
+Remember to provide the appropriate asm/ directory via "mv" or "ln -s"
 before building a C library with headers exported this way.
 
 The kernel header export infrastructure is maintained by David Woodhouse
-- 
1.9.3

