Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3CATzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:55:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CATqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 44/46] ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs
Date: Fri,  1 Mar 2013 11:45:32 -0800
Message-Id: <20130301194436.880150496@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit aaa515277db9585eeb4fdeb4637b9f9df50a1dd9 upstream.

This patch adds the IDE-mode SATA DeviceIDs for the Intel Avoton SOC.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ata_piix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -331,6 +331,14 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (DH89xxCC) */
 	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f30, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f31, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 


