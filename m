Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbbAVTWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:22:00 -0500
Received: from box2.japko.eu ([91.121.152.53]:38536 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbbAVTV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:21:56 -0500
Date: Thu, 22 Jan 2015 20:19:26 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: dgnc: fix long lines in PCI device table
Message-ID: <20150122191926.GA23922@box2.japko.eu>
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
 drivers/staging/dgnc/dgnc_driver.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index f610ae1..f177d3a 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -97,12 +97,12 @@ static uint		dgnc_poll_stop;				/* Used to tell poller to stop */
 static struct timer_list dgnc_poll_timer;
 
 
-static struct pci_device_id dgnc_pci_tbl[] = {
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	0 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	1 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	2 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	3 },
-	{0,}						/* 0 terminated list. */
+static const struct pci_device_id dgnc_pci_tbl[] = {
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_DID),     .driver_data = 0},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID), .driver_data = 1},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_DID),     .driver_data = 2},
+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID), .driver_data = 3},
+	{0,}
 };
 MODULE_DEVICE_TABLE(pci, dgnc_pci_tbl);
 
-- 
1.7.10.4

