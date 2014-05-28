Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaE1VZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:25:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaE1VZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:25:08 -0400
Date: Wed, 28 May 2014 14:24:49 -0700
From: tip-bot for Ong Boon Leong <tipbot@zytor.com>
Message-ID: <tip-7ef1def800e907edd28ddb1a5c64bae6b8749cdd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boon.leong.ong@intel.com, david.e.box@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, david.e.box@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1399668248-24199-3-git-send-email-david.e.box@linux.intel.com>
References: <1399668248-24199-3-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, iosf: Added Quark MBI identifiers
Git-Commit-ID: 7ef1def800e907edd28ddb1a5c64bae6b8749cdd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ef1def800e907edd28ddb1a5c64bae6b8749cdd
Gitweb:     http://git.kernel.org/tip/7ef1def800e907edd28ddb1a5c64bae6b8749cdd
Author:     Ong Boon Leong <boon.leong.ong@intel.com>
AuthorDate: Fri, 9 May 2014 13:44:06 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 May 2014 14:57:08 -0700

x86, iosf: Added Quark MBI identifiers

Added all the MBI units below and their associated read/write
opcodes:
 - Host Bridge Arbiter
 - Host Bridge
 - Remote Management Unit
 - Memory Manager & eSRAM
 - SoC Unit

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Link: http://lkml.kernel.org/r/1399668248-24199-3-git-send-email-david.e.box@linux.intel.com
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/iosf_mbi.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
index 1a91a36..57995f0 100644
--- a/arch/x86/include/asm/iosf_mbi.h
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -50,6 +50,28 @@
 #define BT_MBI_PCIE_READ	0x00
 #define BT_MBI_PCIE_WRITE	0x01
 
+/* Quark available units */
+#define QRK_MBI_UNIT_HBA	0x00
+#define QRK_MBI_UNIT_HB	0x03
+#define QRK_MBI_UNIT_RMU	0x04
+#define QRK_MBI_UNIT_MM	0x05
+#define QRK_MBI_UNIT_MMESRAM	0x05
+#define QRK_MBI_UNIT_SOC	0x31
+
+/* Quark read/write opcodes */
+#define QRK_MBI_HBA_READ	0x10
+#define QRK_MBI_HBA_WRITE	0x11
+#define QRK_MBI_HB_READ	0x10
+#define QRK_MBI_HB_WRITE	0x11
+#define QRK_MBI_RMU_READ	0x10
+#define QRK_MBI_RMU_WRITE	0x11
+#define QRK_MBI_MM_READ	0x10
+#define QRK_MBI_MM_WRITE	0x11
+#define QRK_MBI_MMESRAM_READ	0x12
+#define QRK_MBI_MMESRAM_WRITE	0x13
+#define QRK_MBI_SOC_READ	0x06
+#define QRK_MBI_SOC_WRITE	0x07
+
 #if IS_ENABLED(CONFIG_IOSF_MBI)
 
 bool iosf_mbi_available(void);
