Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3DZFJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:09:16 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57982 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3DZFJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:09:14 -0400
X-AuditID: 9c93016f-b7c3dae000000592-90-517a0bf794dc
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>
Subject: [PATCH -next] x86, doc: Add LZ4 magic number for the new compression
Date: Fri, 26 Apr 2013 14:08:53 +0900
Message-Id: <1366952933-31331-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/x86/boot.txt is updated to list the LZ4 magic number.
This LZ4 magic number is used for the new compression format.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Yann Collet <yann.collet.73@gmail.com>
---
 Documentation/x86/boot.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 3840b6f..fc66d42 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -657,9 +657,10 @@ Protocol:	2.08+
   uncompressed data should be determined using the standard magic
   numbers.  The currently supported compression formats are gzip
   (magic numbers 1F 8B or 1F 9E), bzip2 (magic number 42 5A), LZMA
-  (magic number 5D 00), and XZ (magic number FD 37).  The uncompressed
-  payload is currently always ELF (magic number 7F 45 4C 46).
-  
+  (magic number 5D 00), XZ (magic number FD 37), and LZ4 (magic number
+  02 21).  The uncompressed payload is currently always ELF (magic
+  number 7F 45 4C 46).
+
 Field name:	payload_length
 Type:		read
 Offset/size:	0x24c/4
-- 
1.8.1.1

