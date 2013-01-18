Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3ARDt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:49:27 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36865 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3ARDt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:49:26 -0500
Date: Thu, 17 Jan 2013 22:49:36 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visiongravers.com, wfp5p@virginia.edu,
        jake.champlin.27@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: addi_acpi_035: Fixed Camel Case Coding
 Style Issue
Message-ID: <20130118034931.GA7126@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed camel case style issue.

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/comedi/drivers/addi_apci_035.c | 34 +++++++++++++-------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_035.c b/drivers/staging/comedi/drivers/addi_apci_035.c
index c981d4b..e1c36d1 100644
--- a/drivers/staging/comedi/drivers/addi_apci_035.c
+++ b/drivers/staging/comedi/drivers/addi_apci_035.c
@@ -12,21 +12,21 @@
 
 static const struct addi_board apci035_boardtypes[] = {
 	{
-		.pc_DriverName		= "apci035",
-		.i_VendorId		= PCI_VENDOR_ID_ADDIDATA,
-		.i_DeviceId		= 0x0300,
-		.i_IorangeBase0		= 127,
-		.i_IorangeBase1		= APCI035_ADDRESS_RANGE,
-		.i_PCIEeprom		= 1,
-		.pc_EepromChip		= ADDIDATA_S5920,
-		.i_NbrAiChannel		= 16,
-		.i_NbrAiChannelDiff	= 8,
-		.i_AiChannelList	= 16,
-		.i_AiMaxdata		= 0xff,
-		.pr_AiRangelist		= &range_apci035_ai,
-		.i_Timer		= 1,
-		.ui_MinAcquisitiontimeNs = 10000,
-		.ui_MinDelaytimeNs	= 100000,
+		.pc_driver_name		= "apci035",
+		.vendor_id		= PCI_VENDOR_ID_ADDIDATA,
+		.device_id		= 0x0300,
+		.orange_base0		= 127,
+		.orange_base1		= APCI035_ADDRESS_RANGE,
+		.pci_eeprom		= 1,
+		.pc_eeprom_chip		= ADDIDATA_S5920,
+		.nbr_ai_channel		= 16,
+		.nbr_ai_channel_diff	= 8,
+		.ai_channel_list	= 16,
+		.ai_max_data		= 0xff,
+		.ai_range_list		= &range_apci035_ai,
+		.i_timer		= 1,
+		.ui_min_ack_time	= 10000,
+		.ui_min_delay_time	= 100000,
 		.interrupt		= v_APCI035_Interrupt,
 		.reset			= i_APCI035_Reset,
 		.ai_config		= i_APCI035_ConfigAnalogInput,
@@ -41,9 +41,9 @@ static struct comedi_driver apci035_driver = {
 	.driver_name	= "addi_apci_035",
 	.module		= THIS_MODULE,
 	.auto_attach	= addi_auto_attach,
-	.detach		= i_ADDI_Detach,
+	.detach		= addi_detach,
 	.num_names	= ARRAY_SIZE(apci035_boardtypes),
-	.board_name	= &apci035_boardtypes[0].pc_DriverName,
+	.board_name	= &apci035_boardtypes[0].pc_driver_name,
 	.offset		= sizeof(struct addi_board),
 };
 
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
8123742937
<MuttClient>
