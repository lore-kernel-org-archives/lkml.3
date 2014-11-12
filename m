Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaKLCuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:50:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054AbaKLBnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 114/203] x86, iosf: Added Quark MBI identifiers
Date: Wed, 12 Nov 2014 10:16:24 +0900
Message-Id: <20141112011547.906640242@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ong Boon Leong <boon.leong.ong@intel.com>

commit 7ef1def800e907edd28ddb1a5c64bae6b8749cdd upstream.

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
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/iosf_mbi.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

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


