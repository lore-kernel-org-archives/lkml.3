Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaANBAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:00:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaANA11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Guinot <sguinot@lacie.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 46/62] ahci: add PCI ID for Marvell 88SE9170 SATA controller
Date: Mon, 13 Jan 2014 16:27:11 -0800
Message-Id: <20140114002711.773963498@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Guinot <sguinot@lacie.com>

commit e098f5cbe9d410e7878b50f524dce36cc83ec40e upstream.

This patch adds support for the PCI ID provided by the Marvell 88SE9170
SATA controller.

Signed-off-by: Simon Guinot <sguinot@lacie.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -427,6 +427,9 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_MARVELL_EXT, 0x9178,
+			 PCI_VENDOR_ID_MARVELL_EXT, 0x9170),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9170 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),


