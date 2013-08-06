Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3HFBrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:47:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:20746 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3HFBr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:47:29 -0400
X-Spam-Score: -100.8
Message-ID: <52005571.4080704@asianux.com>
Date: Tue, 06 Aug 2013 09:46:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "'Jiri Kosina'" <trivial@kernel.org>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH trivial] UAPI: Kbuild: add/modify comments for "uapi/Kbuild"
 and "uapi/linux/Kbuild"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"include/uapi/" is the whole Linux kernel API, it is important enough
to get more global explanations by comments.

In "include/uapi/Kbuild", "Makefile..." and "non-arch..." comments are
meaningless for current 'Kbuild', so delete them.

And add more explanations for "include/uapi/" in "include/uapi/Kbuild",
also add more explanations for "include/uapi/linux/" in "include/uapi
/linux/Kbuild".


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/uapi/Kbuild       |    5 ++---
 include/uapi/linux/Kbuild |    2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 81d2106..c682891 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -1,7 +1,6 @@
 # UAPI Header export list
-# Top-level Makefile calls into asm-$(ARCH)
-# List only non-arch directories below
-
+# Except "linux/", UAPI means Universal API.
+# For "linux/", UAPI means User API which can be used by user mode.
 
 header-y += asm-generic/
 header-y += linux/
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 997f9f2..0025e07 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -1,4 +1,6 @@
 # UAPI Header export list
+# UAPI is User API which can be used by user mode.
+
 header-y += byteorder/
 header-y += can/
 header-y += caif/
-- 
1.7.7.6


