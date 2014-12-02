Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbaLBE3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:29:30 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:36486 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932899AbaLBE31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:29:27 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: remove old information in headers_install.txt document
Date: Tue,  2 Dec 2014 13:28:53 +0900
Message-Id: <1417494533-24461-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch header directories "include/asm-*" were moved long before.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Documentation/kbuild/headers_install.txt | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
index 951eb9f..0d8fe5e 100644
--- a/Documentation/kbuild/headers_install.txt
+++ b/Documentation/kbuild/headers_install.txt
@@ -28,10 +28,7 @@ optional arguments:
 
 ARCH indicates which architecture to produce headers for, and defaults to the
 current architecture.  The linux/asm directory of the exported kernel headers
-is platform-specific, to see a complete list of supported architectures use
-the command:
-
-  ls -d include/asm-* | sed 's/.*-//'
+is platform-specific.
 
 INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
 "./usr/include".
-- 
1.9.1

