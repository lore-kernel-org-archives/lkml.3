Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3L2APq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 19:15:46 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57555 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3L2APp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 19:15:45 -0500
From: Hayato Suzuki <hytszk@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Hayato Suzuki <hytszk@gmail.com>
Subject: [PATCH 3/3] [trivial] treewide:Fix typo Kconfig
Date: Sun, 29 Dec 2013 09:15:29 +0900
Message-Id: <1388276129-2132-1-git-send-email-hytszk@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Kconfig.

Signed-off-by: Hayato Suzuki <hytszk@gmail.com>
---
 arch/powerpc/platforms/40x/Kconfig | 2 +-
 arch/x86/crypto/aesni-intel_avx.S  | 8 ++++----
 crypto/Kconfig                     | 2 +-
 init/Kconfig                       | 2 +-
 sound/oss/Kconfig                  | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index 6e287f1..e5fbb2c 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -82,7 +82,7 @@ config OBS600
 	select 405EX
 	select PPC40x_SIMPLE
 	help
-	  This option enables support for PlatHome OpenBlockS 600 server
+	  This option enables support for Platform OpenBlockS 600 server
 
 
 config PPC40x_SIMPLE
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
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 1a96402..fbf07e9 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -318,7 +318,7 @@ config SOUND_MSS
 	  made by Microsoft or Aztech SG 16 Pro (or NX16 Pro).  Also you may
 	  say Y in case your card is NOT among these:
 
-	  ATI Stereo F/X, AdLib, Audio Excell DSP16, Cardinal DSP16,
+	  ATI Stereo F/X, AdLib, Audio Excel DSP16, Cardinal DSP16,
 	  Ensoniq SoundScape (and compatibles made by Reveal and Spea),
 	  Gravis Ultrasound, Gravis Ultrasound ACE, Gravis Ultrasound Max,
 	  Gravis Ultrasound with 16 bit option, Logitech Sound Man 16,
-- 
1.8.4.2

