Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3L3QnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:43:08 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59229 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab3L3QnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:43:07 -0500
From: Hayato Suzuki <hytszk@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Hayato Suzuki <hytszk@gmail.com>
Subject: [PATCH] [trivial] treewide:Fix typo Kconfig
Date: Tue, 31 Dec 2013 01:42:52 +0900
Message-Id: <1388421772-3149-1-git-send-email-hytszk@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <52BF72E1.9030207@infradead.org>
References: <52BF72E1.9030207@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Kconfig.

Signed-off-by: Hayato Suzuki <hytszk@gmail.com>
---
 arch/x86/crypto/aesni-intel_avx.S | 8 ++++----
 crypto/Kconfig                    | 2 +-
 init/Kconfig                      | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx.S b/arch/x86/crypto/aesni-intel_avx.S
index 522ab68..3f202c2 100644
--- a/arch/x86/crypto/aesni-intel_avx.S
+++ b/arch/x86/crypto/aesni-intel_avx.S
@@ -1282,7 +1282,7 @@ _zero_cipher_left\@:
 
         je      _multiple_of_16_bytes\@
 
-        # handle the last <16 Byte block seperately
+        # handle the last <16 Byte block separately
 
 
         vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
@@ -1308,7 +1308,7 @@ _only_less_than_16\@:
 
         je      _multiple_of_16_bytes\@
 
-        # handle the last <16 Byte block seperately
+        # handle the last <16 Byte block separately
 
 
         vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
@@ -2559,7 +2559,7 @@ _zero_cipher_left\@:
 
         je      _multiple_of_16_bytes\@
 
-        # handle the last <16 Byte block seperately
+        # handle the last <16 Byte block separately
 
 
         vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
@@ -2585,7 +2585,7 @@ _only_less_than_16\@:
 
         je      _multiple_of_16_bytes\@
 
-        # handle the last <16 Byte block seperately
+        # handle the last <16 Byte block separately
 
 
         vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7bcb70d..ceb085e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1120,7 +1120,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	  Keys are allowed to be from 0 to 256 bits in length, in steps
 	  of 8 bits.
 
-	  This module provides Serpent cipher algorithm that processes eigth
+	  This module provides Serpent cipher algorithm that processes eight
 	  blocks parallel using SSE2 instruction set.
 
 	  See also:
diff --git a/init/Kconfig b/init/Kconfig
index 8d402e3..46b5089 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -523,7 +523,7 @@ config CONTEXT_TRACKING_FORCE
 	  dynticks working.
 
 	  This option stands for testing when an arch implements the
-	  context tracking backend but doesn't yet fullfill all the
+	  context tracking backend but doesn't yet fulfill all the
 	  requirements to make the full dynticks feature working.
 	  Without the full dynticks, there is no way to test the support
 	  for context tracking and the subsystems that rely on it: RCU
-- 
1.8.4.2

