Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaD0Bi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 21:38:27 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36396 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaD0BiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 21:38:25 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 5/6] staging: comedi: addi_apci_2032: remove unnecessary info from boardinfo
Date: Sat, 26 Apr 2014 20:38:13 -0500
Message-Id: <1398562693-6140-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i_IorangeBase1, i_PCIEeprom, and pc_EepromChip data in the boardinfo
was only needed to work out the usage of the PCI bars.  Now that that is
squared away, this info is no longer needed and can be removed.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 7e42d47..d5be8d3 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -11,9 +11,6 @@
 static const struct addi_board apci1564_boardtypes[] = {
 	{
 		.pc_DriverName		= "apci1564",
-		.i_IorangeBase1		= APCI1564_ADDRESS_RANGE,
-		.i_PCIEeprom		= ADDIDATA_EEPROM,
-		.pc_EepromChip		= ADDIDATA_93C76,
 		.i_NbrDiChannel		= 32,
 		.i_NbrDoChannel		= 32,
 		.i_DoMaxdata		= 0xffffffff,
-- 
1.9.0

