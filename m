Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3JADWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:22:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49401 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3JADWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:22:12 -0400
X-Spam-Score: -100.7
Message-ID: <524A3FA1.4010805@asianux.com>
Date: Tue, 01 Oct 2013 11:21:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>, Joe Perches <joe@perches.com>,
        "'Jiri Kosina'" <trivial@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH trivial v4] include/uapi/Kbuild: modify comment to provide
 summary descriptions for Linux UAPI
References: <52005571.4080704@asianux.com> <1375810303.2424.28.camel@joe-AO722> <1375860749.8422.25@driftwood> <520209FA.70409@asianux.com> <5202FEC3.4010408@asianux.com> <52145F5C.9090907@asianux.com> <521739B3.9050001@asianux.com> <52257A3E.7040001@asianux.com> <5227D472.1010100@asianux.com> <5227D9BE.6060009@asianux.com>
In-Reply-To: <5227D9BE.6060009@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UAPI is whole Linux kernel API, it is important enough to get summary
descriptions by comments.

In "include/uapi/Kbuild", "Makefile..." and "non-arch..." comments are
historical, at present, they need be improved.

Also add more explanations for "include/uapi/" in "include/uapi/Kbuild".


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/uapi/Kbuild |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 81d2106..f396115 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -1,6 +1,15 @@
 # UAPI Header export list
-# Top-level Makefile calls into asm-$(ARCH)
-# List only non-arch directories below
+#
+# UAPI ("Userspace API") is in "include/uapi/" and "arch/*/include/uapi/",
+# which will be installed to "/usr/include".
+#
+# Linux generic (architecture independent) UAPI is at "include/uapi/".
+# Except "linux/", other current level sub-directories are for compatibility.
+# It will not accept new additional current level sub-directories or files.
+#
+# "Architecture Specific Mechanism" UAPI is at "arch/*/include/uapi/".
+# Each architecture must have "arch/*/include/uapi/asm" sub-directory.
+# If architecture permits, it can content additional sub-directories.
 
 
 header-y += asm-generic/
-- 
1.7.7.6

