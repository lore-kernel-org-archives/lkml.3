Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463Ab3IEArt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 20:47:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:48509 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3IEArs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:47:48 -0400
X-Spam-Score: -100.9
Message-ID: <5227D472.1010100@asianux.com>
Date: Thu, 05 Sep 2013 08:46:42 +0800
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
Subject: [PATCH trivial v2] UAPI: Kbuild: add/modify comments for "uapi/Kbuild"
 and "uapi/linux/Kbuild"
References: <52005571.4080704@asianux.com> <1375810303.2424.28.camel@joe-AO722> <1375860749.8422.25@driftwood> <520209FA.70409@asianux.com> <5202FEC3.4010408@asianux.com> <52145F5C.9090907@asianux.com> <521739B3.9050001@asianux.com> <52257A3E.7040001@asianux.com>
In-Reply-To: <52257A3E.7040001@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"include/uapi/" is the whole Linux kernel API, it is important enough
to get more global explanations by comments.

In "include/uapi/Kbuild", "Makefile..." and "non-arch..." comments are
meaningless for current 'Kbuild', so delete them.

And add more explanations for "include/uapi/" in "include/uapi/Kbuild",


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/uapi/Kbuild |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 81d2106..287e8d0 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -1,7 +1,8 @@
 # UAPI Header export list
-# Top-level Makefile calls into asm-$(ARCH)
-# List only non-arch directories below
-
+#
+# UAPI means "Userspace API" which will be installed to "/usr/include".
+# Except "linux/", the other current level directories are for compatibility.
+# It will not accept the new additional current level directories or files.
 
 header-y += asm-generic/
 header-y += linux/
-- 
1.7.7.6
