Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBLI03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:26:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50225 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbaBLIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:05 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Simon Guinot" <sguinot@lacie.com>,
        "Tejun Heo" <tj@kernel.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.229776295@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 65/79] ahci: add PCI ID for Marvell 88SE9170 SATA
 controller
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Guinot <sguinot@lacie.com>

commit e098f5cbe9d410e7878b50f524dce36cc83ec40e upstream.

This patch adds support for the PCI ID provided by the Marvell 88SE9170
SATA controller.

Signed-off-by: Simon Guinot <sguinot@lacie.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -435,6 +435,9 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_MARVELL_EXT, 0x9178,
+			 PCI_VENDOR_ID_MARVELL_EXT, 0x9170),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9170 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),

