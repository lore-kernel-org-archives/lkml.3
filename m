Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbaGDXJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:09:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760311AbaGDWPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scott Teel <scott.teel@hp.com>, Joe Handzik <joseph.t.handzik@hp.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.15 16/66] hpsa: add new Smart Array PCI IDs (May 2014)
Date: Fri,  4 Jul 2014 15:14:15 -0700
Message-Id: <20140704221423.576703727@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Handzik <joseph.t.handzik@hp.com>

commit 3b7a45e5ba85dc79c7714edd9eee9aaed730cd6b upstream.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -115,9 +115,15 @@ static const struct pci_device_id hpsa_p
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C3},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C4},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C5},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C6},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CA},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CB},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
@@ -165,9 +171,15 @@ static struct board_type products[] = {
 	{0x21C3103C, "Smart Array", &SA5_access},
 	{0x21C4103C, "Smart Array", &SA5_access},
 	{0x21C5103C, "Smart Array", &SA5_access},
+	{0x21C6103C, "Smart Array", &SA5_access},
 	{0x21C7103C, "Smart Array", &SA5_access},
 	{0x21C8103C, "Smart Array", &SA5_access},
 	{0x21C9103C, "Smart Array", &SA5_access},
+	{0x21CA103C, "Smart Array", &SA5_access},
+	{0x21CB103C, "Smart Array", &SA5_access},
+	{0x21CC103C, "Smart Array", &SA5_access},
+	{0x21CD103C, "Smart Array", &SA5_access},
+	{0x21CE103C, "Smart Array", &SA5_access},
 	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
 	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
 	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},


