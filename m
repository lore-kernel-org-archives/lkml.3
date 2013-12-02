Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3LBTRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:17:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3LBTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Samir Benmendil <samir.benmendil@gmail.com>, Tejun Heo <tj@kernel.org>,
        Levente Kurusa <levex@linux.com>
Subject: [PATCH 3.12 055/212] ahci: add Marvell 9230 to the AHCI PCI device list
Date: Mon,  2 Dec 2013 11:14:06 -0800
Message-Id: <20131202191254.292282872@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samir Benmendil <samir.benmendil@gmail.com>

commit 6d5278a68a75891db1df5ae1ecf83d288fc58c65 upstream.

Tested with a DAWICONTROL DC-624e on 3.10.10

Signed-off-by: Samir Benmendil <samir.benmendil@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Levente Kurusa <levex@linux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -435,6 +435,8 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
+	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */


