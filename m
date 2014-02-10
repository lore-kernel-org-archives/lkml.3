Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaBJUT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:19:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34559 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaBJTli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 015/124] serial: add support for 200 v3 series Titan card
Date: Mon, 10 Feb 2014 11:39:15 -0800
Message-Id: <1392061264-28124-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yegor Yefremov <yegorslists@googlemail.com>

commit 48c0247d7b7bf58abb85a39021099529df365c4d upstream.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/8250/8250_pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 67950ca..1a890a9 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1298,6 +1298,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_TITAN_800E	0xA014
 #define PCI_DEVICE_ID_TITAN_200EI	0xA016
 #define PCI_DEVICE_ID_TITAN_200EISI	0xA017
+#define PCI_DEVICE_ID_TITAN_200V3	0xA306
 #define PCI_DEVICE_ID_TITAN_400V3	0xA310
 #define PCI_DEVICE_ID_TITAN_410V3	0xA312
 #define PCI_DEVICE_ID_TITAN_800V3	0xA314
@@ -3801,6 +3802,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200EISI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_oxsemi_2_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200V3,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_bt_2_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400V3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_921600 },
-- 
1.8.3.2

