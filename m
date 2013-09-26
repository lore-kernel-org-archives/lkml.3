Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3IZIP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:15:28 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57217 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3IZIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:15:23 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/defconfig: Make NFS_V4 modular instead of builtin
Date: Thu, 26 Sep 2013 10:15:15 +0200
Message-Id: <1380183315-6704-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the kernel image size by ca. 100 KiB, while still allowing
NFS root.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/configs/amiga_defconfig    |    2 +-
 arch/m68k/configs/apollo_defconfig   |    2 +-
 arch/m68k/configs/atari_defconfig    |    2 +-
 arch/m68k/configs/bvme6000_defconfig |    2 +-
 arch/m68k/configs/hp300_defconfig    |    2 +-
 arch/m68k/configs/mac_defconfig      |    2 +-
 arch/m68k/configs/multi_defconfig    |    2 +-
 arch/m68k/configs/mvme147_defconfig  |    2 +-
 arch/m68k/configs/mvme16x_defconfig  |    2 +-
 arch/m68k/configs/q40_defconfig      |    2 +-
 arch/m68k/configs/sun3_defconfig     |    2 +-
 arch/m68k/configs/sun3x_defconfig    |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 8eb2251..fc6aa81 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -392,7 +392,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index faf811f..074ed30 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -349,7 +349,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index f24d9e9..b605928 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -376,7 +376,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 12a53ae..d0f1e8b 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -341,7 +341,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index ca786df..b552489 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -351,7 +351,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index afa3832..9c7414b 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -373,7 +373,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index ffafda8..434bfa7 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -453,7 +453,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index d0b8e1e..e92c449 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -341,7 +341,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 10fb00c..b953842 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -341,7 +341,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index cecf6d1..9f1ba13 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -365,7 +365,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 7f8c8e0..b43006d 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -343,7 +343,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 8f04709..d1343f9 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -343,7 +343,7 @@ CONFIG_QNX6FS_FS=m
 CONFIG_SYSV_FS=m
 CONFIG_UFS_FS=m
 CONFIG_NFS_FS=y
-CONFIG_NFS_V4=y
+CONFIG_NFS_V4=m
 CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_NFSD=m
-- 
1.7.9.5

