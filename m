Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaIOMgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:36:48 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:61560 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbaIOMgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:36:46 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Marek <mmarek@suse.cz>, David Woodhouse <dwmw2@infradead.org>,
        Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv2 1/2] Documentation/kbuild/headers_install.txt: remove obsolete instructions
Date: Sun, 14 Sep 2014 22:27:00 +0200
Message-Id: <b5181cf7604baa454c11f7aa92d07dd05349ce46.1410712841.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410712841.git.ydroneaud@opteya.com>
References: <cover.1410712841.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1410712841.git.ydroneaud@opteya.com>
References: <cover.1410712841.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noted by Sam Ravnborg in reply [1] to "[PATCHv1 2/2]
Documentation/kbuild/headers_install.txt: update documentation" [2],
all architectures support exporting userspace headers (while 'um'
being a special case), so there's no need to list them.

This patch removes the obsolete shell commands to list
architectures with a dedicated 'asm' directory.

[1] http://lkml.kernel.org/r/20140713212608.GB16496@ravnborg.org
[2] http://lkml.kernel.org/r/3e0d73d0ca3ead75624b552105ce8adf3d63684e.1405246009.git.ydroneaud@opteya.com

Link: http://lkml.kernel.org/r/cover.1410712841.git.ydroneaud@opteya.com
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Marek <mmarek@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 Documentation/kbuild/headers_install.txt | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
index 951eb9f1e040..0d8fe5e871c4 100644
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
1.9.3

