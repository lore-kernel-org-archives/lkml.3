Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaDUDyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 23:54:13 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39732 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaDUDyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 23:54:10 -0400
From: "Son P. Nguyen" <fastmutex@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Son P. Nguyen" <fastmutex@gmail.com>
Subject: [PATCH v2 1/2] Staging: dgnc: dgnc_driver: fixed dgnc_pci_tbl definition
Date: Sun, 20 Apr 2014 18:05:38 +0000
Message-Id: <1398017139-22231-1-git-send-email-fastmutex@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397947691-19232-2-git-send-email-fastmutex@gmail.com>
References: <1397947691-19232-2-git-send-email-fastmutex@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Son P. Nguyen" <fastmutex@gmail.com>

Fixed dgnc_pci_tbl definition for correct coding style

PS: This is for task 10 of eudyptula-challenge.

Signed-off-by: Son P. Nguyen <fastmutex@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 39 +++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index b1a39b2..6af1ab3 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -125,26 +125,31 @@ static uint		dgnc_poll_stop;				/* Used to tell poller to stop */
 static struct timer_list dgnc_poll_timer;
 
 
+
+#define DIGIVID_PCI_DEVICE_ID(subdevice, driver_data) \
+	{ DIGI_VID, PCI_DEVICE_##subdevice, PCI_ANY_ID, 0, 0, driver_data }
+
 static struct pci_device_id dgnc_pci_tbl[] = {
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	0 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	1 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	2 },
-	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	3 },
-	{	DIGI_VID, PCI_DEVICE_NEO_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,		4 },
-	{	DIGI_VID, PCI_DEVICE_NEO_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,		5 },
-	{	DIGI_VID, PCI_DEVICE_NEO_2DB9_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	6 },
-	{	DIGI_VID, PCI_DEVICE_NEO_2DB9PRI_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	7 },
-	{	DIGI_VID, PCI_DEVICE_NEO_2RJ45_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	8 },
-	{	DIGI_VID, PCI_DEVICE_NEO_2RJ45PRI_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	9 },
-	{	DIGI_VID, PCI_DEVICE_NEO_1_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	10 },
-	{	DIGI_VID, PCI_DEVICE_NEO_1_422_485_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	11 },
-	{	DIGI_VID, PCI_DEVICE_NEO_2_422_485_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	12 },
-	{	DIGI_VID, PCI_DEVICE_NEO_EXPRESS_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	 13 },
-	{	DIGI_VID, PCI_DEVICE_NEO_EXPRESS_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	14 },
-	{	DIGI_VID, PCI_DEVICE_NEO_EXPRESS_4RJ45_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	15 },
-	{	DIGI_VID, PCI_DEVICE_NEO_EXPRESS_8RJ45_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	16 },
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_4_DID,		0) },
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_4_422_DID,	1) },
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_8_DID,		2) },
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_8_422_DID,	3) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_4_DID,		4) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_8_DID,		5) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2DB9_DID,		6) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2DB9PRI_DID,	7) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2RJ45_DID,		8) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2RJ45PRI_DID,	9) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_1_422_DID,		10) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_1_422_485_DID,	11) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2_422_485_DID,	12) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_8_DID,	13) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_4_DID,	14) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_4RJ45_DID,	15) },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_8RJ45_DID,	16) },
 	{0,}						/* 0 terminated list. */
 };
+
 MODULE_DEVICE_TABLE(pci, dgnc_pci_tbl);
 
 struct board_id {
-- 
1.8.1.2

