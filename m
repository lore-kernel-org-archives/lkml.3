Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161123AbaDTCbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:31:09 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36082 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaDTCa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:30:56 -0400
From: "Son P. Nguyen" <fastmutex@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Son P. Nguyen" <fastmutex@gmail.com>
Subject: [PATCH 1/2] Staging: dgnc: dgnc_driver: fixed coding style of dgnc_pci_tbl
Date: Sat, 19 Apr 2014 22:48:10 +0000
Message-Id: <1397947691-19232-1-git-send-email-fastmutex@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Son P. Nguyen" <fastmutex@gmail.com>

Fixed coding style of dgnc_pci_tbl definition (longer than 80 chars)

Signed-off-by: Son P. Nguyen <fastmutex@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index b1a39b2..e91d3a7 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -124,25 +124,27 @@ static ulong		dgnc_poll_time;				/* Time of next poll */
 static uint		dgnc_poll_stop;				/* Used to tell poller to stop */
 static struct timer_list dgnc_poll_timer;
 
+#define DIGIVID_PCI_DEVICE_ID(subdevice, driver_data) \
+	{ DIGI_VID, PCI_DEVICE_##subdevice, PCI_ANY_ID, 0, 0, driver_data }
 
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
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_4_DID,		0 },
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_4_422_DID,	1 },
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_8_DID,		2 },
+	{ DIGIVID_PCI_DEVICE_ID(CLASSIC_8_422_DID,	3 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_4_DID,		4 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_8_DID,		5 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2DB9_DID,		6 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2DB9PRI_DID,	7 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2RJ45_DID,		8 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2RJ45PRI_DID,	9 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_1_422_DID,		10 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_1_422_485_DID,	11 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_2_422_485_DID,	12 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_8_DID,	13 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_4_DID,	14 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_4RJ45_DID,	15 },
+	{ DIGIVID_PCI_DEVICE_ID(NEO_EXPRESS_8RJ45_DID,	16 },
 	{0,}						/* 0 terminated list. */
 };
 MODULE_DEVICE_TABLE(pci, dgnc_pci_tbl);
-- 
1.8.1.2

