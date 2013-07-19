Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab3GSXAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:00:32 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:17915
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686Ab3GSXAa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:00:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z3e12hzc89bh8d0I70dIdbb0idbf2izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1d7338h1de098h17326ah1de097h1de096h1d68deh8275bh8275dhz2dh668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MQ7GHJ-02-0PP-02
X-M-MSG: 
From: Sherry Hurwitz <sherry.hurwitz@amd.com>
To: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>
CC: <linux-kernel@vger.kernel.org>, Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20linux-firmware/AMD=3A=20add=20readme=20files=20for=20amd-ucode?=
Date: Fri, 19 Jul 2013 17:43:52 -0500
Message-ID: <1374273832-5228-1-git-send-email-sherry.hurwitz@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File: README
File: microcode_amd.bin.README
File: microcode_amd_fam15h.bin.README

Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
---
 amd-ucode/README                          |   46 +++++++++++++++++++++++++++++
 amd-ucode/microcode_amd.bin.README        |   29 ++++++++++++++++++
 amd-ucode/microcode_amd_fam15h.bin.README |   13 ++++++++
 3 files changed, 88 insertions(+)
 create mode 100644 amd-ucode/README
 create mode 100644 amd-ucode/microcode_amd.bin.README
 create mode 100644 amd-ucode/microcode_amd_fam15h.bin.README

diff --git a/amd-ucode/README b/amd-ucode/README
new file mode 100644
index 0000000..a92831d
--- /dev/null
+++ b/amd-ucode/README
@@ -0,0 +1,46 @@
+This package provides latest microcode patches
+for AMD processor families >= 0x10.
+
+See http://www.amd64.org/support/microcode.html
+for details.
+
+Microcode patches are included in container files:
+- 'microcode_amd.bin' (for AMD CPU families 10h - 14h)
+- 'microcode_amd_fam15h.bin' (for AMD CPU family 15h)
+
+Please read the file INSTALL for install instructions.
+Please read the file LICENSE for licensing information.
+
+The container files include following microcode patches:
+
+    mc_patch_01000083_PUB-v4/mc_patch_01000083.asm
+    mc_patch_01000084_PUB-v4/mc_patch_01000084.asm
+    mc_patch_010000C7_PUB-v1/mc_patch_010000C7.asm
+    mc_patch_010000C8_PUB-v1/mc_patch_010000C8.asm
+    mc_patch_010000D9_PUB-v1/mc_patch_010000D9.asm
+    mc_patch_010000DA_PUB-v1/mc_patch_010000DA.asm
+    mc_patch_010000DB_PUB-v1/mc_patch_010000DB.asm
+    mc_patch_010000DC_PUB-v1/mc_patch_010000DC.asm
+    mc_patch_02000032_PUB-v3/mc_patch_02000032.asm
+    mc_patch_03000027_PUB-v1/mc_patch_03000027.asm
+    mc_patch_05000029_PUB-v1/mc_patch_05000029.asm
+    mc_patch_05000119_PUB-v1/mc_patch_05000119.asm
+    mc_patch_0600063D_PUB-v1/mc_patch_0600063D.asm
+    mc_patch_06000822_PUB-v1/mc_patch_06000822.asm
+    mc_patch_06001119_PUB-v2/mc_patch_06001119.asm
+
+***********************************************************************
+Copyright 2008-2013 ADVANCED MICRO DEVICES, INC.  All Rights Reserved.
+
+AMD is granting you permission to use this software and documentation
+(if any) (collectively, the “Materials”) pursuant to the terms and
+conditions of the Software License Agreement included with the
+Materials.  This header does NOT give you permission to use the
+Materials or any rights under AMD’s intellectual property.  Your use
+of any portion of these Materials shall constitute your acceptance of
+those terms and conditions.  If you do not agree to the terms and
+conditions of the Software License Agreement, you do not have
+permission to use any portion of these Materials.  If you do not have
+a copy of the Software License Agreement, contact your AMD
+representative for a copy.
+
diff --git a/amd-ucode/microcode_amd.bin.README b/amd-ucode/microcode_amd.bin.README
new file mode 100644
index 0000000..617d951
--- /dev/null
+++ b/amd-ucode/microcode_amd.bin.README
@@ -0,0 +1,29 @@
+;******************************************************************************
+; The associated microcode container file fixes the errata as documented in
+; Revision Guide for AMD Family 10h Processors, order #41322,
+; Revision Guide for AMD Family 11h Processors, order #41788,
+; Revision Guide for AMD Family 12h Processors, order #44739,
+; Revision Guide for AMD Family 14h Models 00h-0Fh Processors, order #47534,
+; for different revisions of AMD processors as follows:
+; 
+; CPUIDFn[0000_0001]_EAX; ID;         Errata fixed;
+;
+; 0x00100F22;             0x01000083; 244, 260, 280, 302, 308, 315, 342;
+; 0x00100F23;             0x01000083; 244, 260, 280, 302, 308, 315, 342;
+; 0x00100F2A;             0x01000084; 244, 260, 280, 302, 308, 315, 342;
+; 0x00100F42;             0x010000DB; 342, 440, 573;
+; 0x00100F43;             0x010000C8; 407, 440;
+; 0x00100F52;             0x010000DB; 342, 440, 573;
+; 0x00100F53;             0x010000C8; 407, 440;
+; 0x00100F62;             0x010000C7; 407, 440;
+; 0x00100F63;             0x010000C8; 407, 440;
+; 0x00100F80;             0x010000DA; 419, 440, 573;
+; 0x00100F81;             0x010000D9; #406, #407, #440, #573, #669;
+; 0x00100F91;             0x010000D9; #406, #407, #440, #573, #669;
+; 0x00100FA0;             0x010000DC; 438, 440, 573;
+; 0x00200F31;             0x02000032; 311, 316;
+; 0x00300F10;             0x03000027; #564, #573, #662, #686;
+; 0x00500F10;             0x05000029; #461, #564, #594, #595, #784;
+; 0x00500F20;             0x05000119; #461, #564, #594, #639, #662, #686, #784;
+;
+;******************************************************************************
diff --git a/amd-ucode/microcode_amd_fam15h.bin.README b/amd-ucode/microcode_amd_fam15h.bin.README
new file mode 100644
index 0000000..a688b84
--- /dev/null
+++ b/amd-ucode/microcode_amd_fam15h.bin.README
@@ -0,0 +1,13 @@
+;******************************************************************************
+; The associated microcode container file fixes the errata as documented in
+; Revision Guide for AMD Family 15h Models 00h-0Fh Processors, order #48063,
+; Revision Guide for AMD Family 15h Models 10h-1Fh Processors, order #48931,
+; for different revisions of AMD processors as follows:
+; 
+; CPUIDFn[0000_0001]_EAX; ID;         Errata fixed;
+;
+; 0x00600F12;             0x0600063D; #659, #660, #661, #671, #672, #673, #691, #709, #740, #759, #778;
+; 0x00600F20;             0x06000822; #691, #699, #704, #708, #709, #734, #740, #778;
+; 0x00610F01;             0x06001119; #671, #686, #697, #698, #699, #704, #709, #734, #740;
+;
+;******************************************************************************
-- 
1.7.9.5


