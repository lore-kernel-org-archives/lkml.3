Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaAAVPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 16:15:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35099 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaAAVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 16:15:39 -0500
From: Erik Ekman <erik@kryo.se>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Erik Ekman <erik@kryo.se>
Subject: [PATCH] PCI: Update documentation 00-INDEX file
Date: Wed,  1 Jan 2014 22:15:25 +0100
Message-Id: <1388610925-12850-1-git-send-email-erik@kryo.se>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI-DMA-mapping.txt moved to general docs and became DMA-API-HOWTO.txt in 5e07c2c73
Add new file about PCI Express I/O Virtualization

Signed-off-by: Erik Ekman <erik@kryo.se>
---
 Documentation/PCI/00-INDEX | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/PCI/00-INDEX b/Documentation/PCI/00-INDEX
index 812b17f..147231f 100644
--- a/Documentation/PCI/00-INDEX
+++ b/Documentation/PCI/00-INDEX
@@ -2,12 +2,12 @@
 	- this file
 MSI-HOWTO.txt
 	- the Message Signaled Interrupts (MSI) Driver Guide HOWTO and FAQ.
-PCI-DMA-mapping.txt
-	- info for PCI drivers using DMA portably across all platforms
 PCIEBUS-HOWTO.txt
 	- a guide describing the PCI Express Port Bus driver
 pci-error-recovery.txt
 	- info on PCI error recovery
+pci-iov-howto.txt
+	- the PCI Express I/O Virtualization HOWTO
 pci.txt
 	- info on the PCI subsystem for device driver authors
 pcieaer-howto.txt
-- 
1.8.4.2

