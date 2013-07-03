Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab3GCOmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:42:44 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:52872 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab3GCOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:42:42 -0400
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Michal Marek <mmarek@suse.cz>, Rob Landley <rob@landley.net>,
        cocci@systeme.lip6.fr, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Subject: [PATCH] Coccinelle: Update information about the minimal version required
Date: Wed,  3 Jul 2013 16:41:01 +0200
Message-Id: <1372862461-14633-1-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The naming convention of options has changed one year ago.
The options have been recently updated in the cocci file
and in scripts/coccicheck. This patch also adds this information
in the documentation.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 Documentation/coccinelle.txt |   19 ++++++++-----------
 scripts/coccicheck           |    5 +++++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index 81a329f..7f773d5 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -6,15 +6,17 @@ Copyright 2010 Gilles Muller <Gilles.Muller@lip6.fr>
  Getting Coccinelle
 ~~~~~~~~~~~~~~~~~~~~
 
-The semantic patches included in the kernel use the 'virtual rule'
-feature which was introduced in Coccinelle version 0.1.11.
+The semantic patches included in the kernel use features and options
+which are provided by Coccinelle version 1.0.0-rc11 and above.
+Using earlier versions will fail as the option names used by
+the Coccinelle files and coccicheck have been updated.
 
-Coccinelle (>=0.2.0) is available through the package manager
+Coccinelle is available through the package manager
 of many distributions, e.g. :
 
- - Debian (>=squeeze)
- - Fedora (>=13)
- - Ubuntu (>=10.04 Lucid Lynx)
+ - Debian
+ - Fedora
+ - Ubuntu
  - OpenSUSE
  - Arch Linux
  - NetBSD
@@ -36,11 +38,6 @@ as a regular user, and install it with
 
         sudo make install
 
-The semantic patches in the kernel will work best with Coccinelle version
-0.2.4 or later.  Using earlier versions may incur some parse errors in the
-semantic patch code, but any results that are obtained should still be
-correct.
-
  Using Coccinelle on the Linux kernel
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/scripts/coccicheck b/scripts/coccicheck
index d3757ad..bbf901a 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -1,5 +1,10 @@
 #!/bin/bash
 
+#
+# This script requires at least spatch
+# version 1.0.0-rc11.
+#
+
 SPATCH="`which ${SPATCH:=spatch}`"
 
 trap kill_running SIGTERM SIGINT
-- 
1.7.9.5

