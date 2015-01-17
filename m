Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbbAQXkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:40:22 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:40814 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbAQXkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:40:17 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2015 18:40:15 EST
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] scripts/recordmcount.pl: There is no -m32 option on Super-H
Date: Sun, 18 Jan 2015 00:36:15 +0100
Message-Id: <1421537778-29001-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 2.1.3
X-Originating-IP: 85.25.239.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-Off-By: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 scripts/recordmcount.pl | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 56ea99a..537c38c 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -255,7 +255,6 @@ if ($arch eq "x86_64") {
     # force flags for this arch
     $ld .= " -m shlelf_linux";
     $objcopy .= " -O elf32-sh-linux";
-    $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
     $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
-- 
2.1.3

