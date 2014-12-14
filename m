Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaLNUrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:47:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLNUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Devin Ryles <devin.ryles@intel.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.14 15/34] AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller
Date: Sun, 14 Dec 2014 12:20:53 -0800
Message-Id: <20141214201804.232849875@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201803.791392744@linuxfoundation.org>
References: <20141214201803.791392744@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Ryles <devin.ryles@intel.com>

commit 249cd0a187ed4ef1d0af7f74362cc2791ec5581b upstream.

This patch adds DeviceIDs for Sunrise Point-LP.

Signed-off-by: Devin Ryles <devin.ryles@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -322,6 +322,9 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x8c87), board_ahci }, /* 9 Series RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c8e), board_ahci }, /* 9 Series RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c8f), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x9d03), board_ahci }, /* Sunrise Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9d05), board_ahci }, /* Sunrise Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9d07), board_ahci }, /* Sunrise Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0xa103), board_ahci }, /* Sunrise Point-H AHCI */
 	{ PCI_VDEVICE(INTEL, 0xa103), board_ahci }, /* Sunrise Point-H RAID */
 	{ PCI_VDEVICE(INTEL, 0xa105), board_ahci }, /* Sunrise Point-H RAID */


