Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3CZRtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab3CZRtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:49:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] UAPI: Remove empty Kbuild files
To: torvalds@linux-foundation.org, arnd@arndb.de
From: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 17:48:53 +0000
Message-ID: <20130326174853.10144.36253.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove empty Kbuild files as they cause problems with the patch program which
removes files that become empty.

Should I also remove include/Kbuild as that now does nothing?  Or should it be
left as an anchor just in case we want it in future?

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/Kbuild         |    3 ---
 include/scsi/Kbuild    |    1 -
 include/scsi/fc/Kbuild |    0 
 include/video/Kbuild   |    0 
 4 files changed, 4 deletions(-)
 delete mode 100644 include/scsi/Kbuild
 delete mode 100644 include/scsi/fc/Kbuild
 delete mode 100644 include/video/Kbuild

diff --git a/include/Kbuild b/include/Kbuild
index 1dfd33e..bab1145 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -1,5 +1,2 @@
 # Top-level Makefile calls into asm-$(ARCH)
 # List only non-arch directories below
-
-header-y += video/
-header-y += scsi/
diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
deleted file mode 100644
index 562ff9d..0000000
--- a/include/scsi/Kbuild
+++ /dev/null
@@ -1 +0,0 @@
-header-y += fc/
diff --git a/include/scsi/fc/Kbuild b/include/scsi/fc/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/video/Kbuild b/include/video/Kbuild
deleted file mode 100644
index e69de29..0000000

