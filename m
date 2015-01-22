Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbbAVS55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:57:57 -0500
Received: from box2.japko.eu ([91.121.152.53]:41352 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbbAVS5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:57:55 -0500
Date: Thu, 22 Jan 2015 19:55:25 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: fix long lines in PCI device table
Message-ID: <20150122185524.GA18274@box2.japko.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coding style of PCI device table declaration.

Signed-off-by: Krzysztof Adamski <k@japko.eu>
---
 drivers/staging/dgnc/dgnc_driver.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index f610ae1..f04a693 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -98,11 +98,11 @@ static struct timer_list dgnc_poll_timer;
 
 
 static struct pci_device_id dgnc_pci_tbl[] = {
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	0 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	1 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	2 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	3 },
-	{0,}						/* 0 terminated list. */
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_DID), .driver_data = 0},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID), .driver_data = 1},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_DID), .driver_data = 2},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID), .driver_data = 3},
+	{0,}
 };
 MODULE_DEVICE_TABLE(pci, dgnc_pci_tbl);
 
-- 
1.7.10.4

