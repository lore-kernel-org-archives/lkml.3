Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaBLIYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:24:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50227 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbaBLIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:05 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "George Spelvin" <linux@horizon.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.96645193@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 63/79] ahci: add an observed PCI ID for Marvell
 88se9172 SATA controller
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: George Spelvin <linux@horizon.com>

commit fcce9a35f8faaa1f52236c554ef1b15d99a7537e upstream.

A third possible PCI ID, as personally observed, and found in the
pci.ids list.

Signed-off-by: George Spelvin <linux@horizon.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -437,6 +437,8 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),

