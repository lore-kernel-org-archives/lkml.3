Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaBCM4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:56:23 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41898 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaBCM4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:17 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v1 04/10] perf/x86/uncore: add PCI ids for SNB/IVB/HSW IMC
Date: Mon,  3 Feb 2014 13:55:36 +0100
Message-Id: <1391432142-18723-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391432142-18723-1-git-send-email-eranian@google.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PCI ids for the Intel SandyBridge,
IvyBridge, Haswell Client memory controller (IMC).

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/pci_ids.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 97fbecd..7399e6a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2531,6 +2531,9 @@
 
 #define PCI_VENDOR_ID_INTEL		0x8086
 #define PCI_DEVICE_ID_INTEL_EESSC	0x0008
+#define PCI_DEVICE_ID_INTEL_SNB_IMC	0x0100
+#define PCI_DEVICE_ID_INTEL_IVB_IMC	0x0154
+#define PCI_DEVICE_ID_INTEL_HSW_IMC	0x0c00
 #define PCI_DEVICE_ID_INTEL_PXHD_0	0x0320
 #define PCI_DEVICE_ID_INTEL_PXHD_1	0x0321
 #define PCI_DEVICE_ID_INTEL_PXH_0	0x0329
-- 
1.7.9.5

