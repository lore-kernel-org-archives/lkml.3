Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaH3UgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:36:05 -0400
Received: from cthulhu.worldbroken.com ([173.230.133.178]:34530 "EHLO
	cthulhu.worldbroken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaH3UgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:36:00 -0400
From: wfp5p@worldbroken.com
To: gregkh@linuxfoundation.org
Cc: cascardo@linux.vnet.ibm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, lidza.louina@gmail.com,
        devel@driverdev.osuosl.org
Subject: [Patch v2 2/2] staging: dgnc: remove Neo card ids from device table
Date: Sat, 30 Aug 2014 16:35:58 -0400
Message-Id: <1409430958-2692-3-git-send-email-wfp5p@worldbroken.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1409430958-2692-1-git-send-email-wfp5p@worldbroken.com>
References: <1409430958-2692-1-git-send-email-wfp5p@worldbroken.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Pemberton <wfp5p@worldbroken.com>

The Digi Neo cards are supported by the jsm driver.  Remove support
for these cards from dgnc.

Signed-off-by: Bill Pemberton <wfp5p@worldbroken.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index 764613b2f4b4..ad07cc698147 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -128,19 +128,6 @@ static struct pci_device_id dgnc_pci_tbl[] = {
 	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	1 },
 	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	2 },
 	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	3 },
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
 	{0,}						/* 0 terminated list. */
 };
 MODULE_DEVICE_TABLE(pci, dgnc_pci_tbl);
-- 
1.9.3

