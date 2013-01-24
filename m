Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945967Ab3AXVUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:20:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:40938 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab3AXVQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: [ 17/22] ahci: Add identifiers for ASM106x devices
Date: Thu, 24 Jan 2013 13:15:38 -0800
Message-Id: <20130124211510.218359497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 7b4f6ecacb14f384adc1a5a67ad95eb082c02bd1 upstream.

They don't always appear as AHCI class devices but instead as IDE class.

Based on an initial patch by Hiroaki Nito

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=42804
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -406,7 +406,10 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
 	/* Asmedia */
-	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },


