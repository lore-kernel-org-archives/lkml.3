Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbaCTJn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:43:27 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48534 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129AbaCTJnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:43:22 -0400
Subject: [PATCH 29/33] Automake files for the doc folder
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:13:07 +0530
Message-ID: <20140320094307.14878.16907.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-0260-0000-0000-000004919C0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automake files for both gencore command and gencore API.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 Makefile.am     |    2 +-
 configure.ac    |    2 +-
 doc/Makefile.am |    2 ++
 src/coredump.c  |    0 
 4 files changed, 4 insertions(+), 2 deletions(-)
 create mode 100644 doc/Makefile.am
 mode change 100755 => 100644 src/coredump.c

diff --git a/Makefile.am b/Makefile.am
index dfa49b2..8b31e4f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,2 +1,2 @@
 AUTOMAKE_OPTIONS = foreign
-SUBDIRS = src
+SUBDIRS = src doc
diff --git a/configure.ac b/configure.ac
index 8c785cd..9e130e0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,4 +4,4 @@ AM_INIT_AUTOMAKE([-Wall -Werror foreign])
 AC_CONFIG_HEADERS([config.h])
 AC_PROG_CC
 AC_CONFIG_FILES(Makefile)
-AC_OUTPUT(src/Makefile)
+AC_OUTPUT(src/Makefile doc/Makefile)
diff --git a/doc/Makefile.am b/doc/Makefile.am
new file mode 100644
index 0000000..a1cf9b5
--- /dev/null
+++ b/doc/Makefile.am
@@ -0,0 +1,2 @@
+man1_MANS = gencore.1
+man3_MANS = gencore.3
diff --git a/src/coredump.c b/src/coredump.c
old mode 100755
new mode 100644

