Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3BEWNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:13:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3BEWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 84/93] ahci: Add identifiers for ASM106x devices
Date: Tue,  5 Feb 2013 20:07:13 -0200
Message-Id: <1360102042-10732-85-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 7b4f6ecacb14f384adc1a5a67ad95eb082c02bd1 upstream.

They don't always appear as AHCI class devices but instead as IDE class.

Based on an initial patch by Hiroaki Nito

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=42804
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/ata/ahci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5d0fb6b..71a4d04 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -406,7 +406,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
 	/* Asmedia */
-	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
-- 
1.7.9.5

