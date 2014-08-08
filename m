Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaHHRya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:54:30 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51320 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaHHRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:54:29 -0400
From: microcai <microcaicai@gmail.com>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Wanzhao Cai <microcaicai@gmail.com>
Subject: [PATCH] mfd: lpc_ich: add support for Intel Z97 chipset
Date: Sat,  9 Aug 2014 01:55:19 +0800
Message-Id: <1407520519-1755-1-git-send-email-microcaicai@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanzhao Cai <microcaicai@gmail.com>

This patch adds the LPC Controller Device IDs found on ASUS Z97-A mother broad.

lspci output for this mother broad:

00:1f.0 ISA bridge [0601]: Intel Corporation 9 Series Chipset Family Z97 LPC Controller [8086:8cc4]
	Subsystem: ASUSTeK Computer Inc. Device [1043:8534]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
	DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
	<PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor
	Specific Information: Len=0c <?>
	Kernel driver in use: lpc_ich
	Kernel modules: lpc_ich

Signed-off-by: microcai <microcaicai@gmail.com>
---
 drivers/mfd/lpc_ich.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 7d8482f..e4b37c0 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -738,6 +738,7 @@ static const struct pci_device_id lpc_ich_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x1f3b), LPC_AVN},
 	{ PCI_VDEVICE(INTEL, 0x0f1c), LPC_BAYTRAIL},
 	{ PCI_VDEVICE(INTEL, 0x2390), LPC_COLETO},
+	{ PCI_VDEVICE(INTEL, 0x8cc4), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc1), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc2), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc3), LPC_WPT_LP},
-- 
2.0.4

