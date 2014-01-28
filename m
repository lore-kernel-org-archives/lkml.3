Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaA1Pbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:31:34 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:34704 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbaA1Pbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:31:33 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jan 2014 10:31:32 EST
From: Francois-Xavier Le Bail <fx.lebail@yahoo.com>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] doc: fix headers_install.txt
Date: Tue, 28 Jan 2014 16:01:43 +0100
Message-Id: <1390921303-4731-1-git-send-email-fx.lebail@yahoo.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- The default location for installed headers is : ./usr
- Using INSTALL_HDR_PATH=/usr/include give /usr/include/include

Signed-off-by: Francois-Xavier Le Bail <fx.lebail@yahoo.com>
---
 Documentation/make/headers_install.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/make/headers_install.txt b/Documentation/make/headers_install.txt
index 951eb9f..b6c16bc 100644
--- a/Documentation/make/headers_install.txt
+++ b/Documentation/make/headers_install.txt
@@ -24,7 +24,7 @@ The "make headers_install" command can be run in the top level directory of the
 kernel source code (or using a standard out-of-tree build).  It takes two
 optional arguments:
 
-  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
+  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr
 
 ARCH indicates which architecture to produce headers for, and defaults to the
 current architecture.  The linux/asm directory of the exported kernel headers
@@ -34,7 +34,7 @@ the command:
   ls -d include/asm-* | sed 's/.*-//'
 
 INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
-"./usr/include".
+"./usr".
 
 The command "make headers_install_all" exports headers for all architectures
 simultaneously.  (This is mostly of interest to distribution maintainers,
