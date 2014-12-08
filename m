Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaLHWyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:54:13 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49864 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLHWyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:54:11 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Borislav Petkov <bp@suse.de>, linux-doc@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH] x86-64, doc: update to account for file shuffling
Date: Mon,  8 Dec 2014 14:54:01 -0800
Message-Id: <1418079241-4362-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

While at it, also refer to the 32 bit entry file.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 Documentation/x86/entry_64.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
index bc7226e..4796392 100644
--- a/Documentation/x86/entry_64.txt
+++ b/Documentation/x86/entry_64.txt
@@ -7,9 +7,11 @@ http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
 The x86 architecture has quite a few different ways to jump into
 kernel code.  Most of these entry points are registered in
 arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
-and arch/x86/ia32/ia32entry.S.
+for 64-bit, arch/x86/kernel/entry_32.S for 32-bit and finally
+arch/x86/ia32/ia32entry.S which allows to run legacy 32-bit programs
+under a 64-bit kernel.
 
-The IDT vector assignments are listed in arch/x86/include/irq_vectors.h.
+The IDT vector assignments are listed in arch/x86/include/asm/irq_vectors.h.
 
 Some of these entries are:
 
-- 
2.1.1

