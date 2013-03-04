Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3CDUQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:16:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55852 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab3CDUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:16:37 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 3/5] x86-64, docs, mm: Add vsyscall range to virtual address space layout
Date: Mon,  4 Mar 2013 21:16:18 +0100
Message-Id: <1362428180-8865-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1362428180-8865-1-git-send-email-bp@alien8.de>
References: <1362428180-8865-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the end of the virtual address space to its layout documentation.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 Documentation/x86/x86_64/mm.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index d6498e3cd713..881582f75c9c 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -13,7 +13,9 @@ ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
 ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
-ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space
+ffffffffa0000000 - ffffffffff5fffff (=1525 MB) module mapping space
+ffffffffff600000 - ffffffffffdfffff (=8 MB) vsyscalls
+ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
 
 The direct mapping covers all memory in the system up to the highest
 memory address (this means in some cases it can also include PCI memory
-- 
1.8.1.3.535.ga923c31

