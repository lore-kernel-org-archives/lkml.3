Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaC3XZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:25:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36214 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbaC3XY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yegor Yefremov" <yegorslists@googlemail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.105587340@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 011/200] serial: add support for 200 v3 series Titan card
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yegor Yefremov <yegorslists@googlemail.com>

commit 48c0247d7b7bf58abb85a39021099529df365c4d upstream.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/8250_pci.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1147,6 +1147,7 @@ pci_xr17c154_setup(struct serial_private
 #define PCI_DEVICE_ID_TITAN_800E	0xA014
 #define PCI_DEVICE_ID_TITAN_200EI	0xA016
 #define PCI_DEVICE_ID_TITAN_200EISI	0xA017
+#define PCI_DEVICE_ID_TITAN_200V3	0xA306
 #define PCI_DEVICE_ID_TITAN_400V3	0xA310
 #define PCI_DEVICE_ID_TITAN_410V3	0xA312
 #define PCI_DEVICE_ID_TITAN_800V3	0xA314
@@ -3469,6 +3470,9 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200EISI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_oxsemi_2_4000000 },
+	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200V3,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_bt_2_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400V3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_921600 },

