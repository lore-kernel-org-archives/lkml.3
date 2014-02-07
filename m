Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaBGNb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:31:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40926 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBGLYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 25/88] serial: add support for 200 v3 series Titan card
Date: Fri,  7 Feb 2014 11:22:22 +0000
Message-Id: <1391772205-22239-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yegor Yefremov <yegorslists@googlemail.com>

commit 48c0247d7b7bf58abb85a39021099529df365c4d upstream.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/8250/8250_pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 41c1db3..8e581dd 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1193,6 +1193,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_TITAN_800E	0xA014
 #define PCI_DEVICE_ID_TITAN_200EI	0xA016
 #define PCI_DEVICE_ID_TITAN_200EISI	0xA017
+#define PCI_DEVICE_ID_TITAN_200V3	0xA306
 #define PCI_DEVICE_ID_TITAN_400V3	0xA310
 #define PCI_DEVICE_ID_TITAN_410V3	0xA312
 #define PCI_DEVICE_ID_TITAN_800V3	0xA314
@@ -3529,6 +3530,9 @@ static struct pci_device_id serial_pci_tbl[] = {
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

