Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3KJNop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 08:44:45 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55021 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3KJNoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 08:44:44 -0500
X-Originating-IP: 109.242.53.127
From: Aldo Iljazi <mail@aldo.io>
To: marek.belisko@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: ft1000: fixed coding style issues
Date: Sun, 10 Nov 2013 15:44:20 +0200
Message-Id: <1384091060-29915-1-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following coding style issues:

Lines 84-91,99-106,275,514: Replaced spaces at the start of the lines
with tabs.

Lines 205,271: Inserted spaces after the commas.
Lines 275,1060,1065: Indented the code with tabs instead of spaces.

Line 275: Inserted spaces around '=' and '<', also moved the trailing
statement on the next line.

Line 512: Removed space between function name and open parenthesis.
Line 839: Removed space after '&'.
Line 853: Removed space after '&'.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    | 57 +++++++++++-----------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 68ded17..170908a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -81,29 +81,29 @@
 #define  DWNLD_MAG1_PS_HDR_LOC        0x03
 
 struct dsp_file_hdr {
-   long              version_id;          // Version ID of this image format.
-   long              package_id;          // Package ID of code release.
-   long              build_date;          // Date/time stamp when file was built.
-   long              commands_offset;     // Offset to attached commands in Pseudo Hdr format.
-   long              loader_offset;       // Offset to bootloader code.
-   long              loader_code_address; // Start address of bootloader.
-   long              loader_code_end;     // Where bootloader code ends.
-   long              loader_code_size;
-   long              version_data_offset; // Offset were scrambled version data begins.
-   long              version_data_size;   // Size, in words, of scrambled version data.
-   long              nDspImages;          // Number of DSP images in file.
+	long              version_id;          // Version ID of this image format.
+	long              package_id;          // Package ID of code release.
+	long              build_date;          // Date/time stamp when file was built.
+	long              commands_offset;     // Offset to attached commands in Pseudo Hdr format.
+	long              loader_offset;       // Offset to bootloader code.
+	long              loader_code_address; // Start address of bootloader.
+	long              loader_code_end;     // Where bootloader code ends.
+	long              loader_code_size;
+	long              version_data_offset; // Offset were scrambled version data begins.
+	long              version_data_size;   // Size, in words, of scrambled version data.
+	long              nDspImages;          // Number of DSP images in file.
 };
 
 #pragma pack(1)
 struct dsp_image_info {
-   long              coff_date;           // Date/time when DSP Coff image was built.
-   long              begin_offset;        // Offset in file where image begins.
-   long              end_offset;          // Offset in file where image begins.
-   long              run_address;         // On chip Start address of DSP code.
-   long              image_size;          // Size of image.
-   long              version;             // Embedded version # of DSP code.
-   unsigned short    checksum;            // DSP File checksum
-   unsigned short    pad1;
+	long              coff_date;           // Date/time when DSP Coff image was built.
+	long              begin_offset;        // Offset in file where image begins.
+	long              end_offset;          // Offset in file where image begins.
+	long              run_address;         // On chip Start address of DSP code.
+	long              image_size;          // Size of image.
+	long              version;             // Embedded version # of DSP code.
+	unsigned short    checksum;            // DSP File checksum
+	unsigned short    pad1;
 };
 
 
@@ -202,7 +202,7 @@ static u16 get_handshake(struct ft1000_usb *ft1000dev, u16 expected_value)
 }
 
 /* write the handshake value to the handshake location */
-static void put_handshake(struct ft1000_usb *ft1000dev,u16 handshake_value)
+static void put_handshake(struct ft1000_usb *ft1000dev, u16 handshake_value)
 {
 	u32 tempx;
 	u16 tempword;
@@ -268,11 +268,12 @@ static u16 get_handshake_usb(struct ft1000_usb *ft1000dev, u16 expected_value)
 	return HANDSHAKE_TIMEOUT_VALUE;
 }
 
-static void put_handshake_usb(struct ft1000_usb *ft1000dev,u16 handshake_value)
+static void put_handshake_usb(struct ft1000_usb *ft1000dev, u16 handshake_value)
 {
 	int i;
 
-        for (i=0; i<1000; i++);
+	for (i = 0; i < 1000; i++)
+		;
 }
 
 static u16 get_request_type(struct ft1000_usb *ft1000dev)
@@ -509,9 +510,9 @@ static int write_blk(struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile,
 	return status;
 }
 
-static void usb_dnld_complete (struct urb *urb)
+static void usb_dnld_complete(struct urb *urb)
 {
-    //DEBUG("****** usb_dnld_complete\n");
+	//DEBUG("****** usb_dnld_complete\n");
 }
 
 /* writes a block of DSP image to DPRAM
@@ -836,7 +837,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 					 * Position ASIC DPRAM auto-increment pointer.
 					 */
 
-					data = (u16 *) & mailbox_data->data[0];
+					data = (u16 *) &mailbox_data->data[0];
 					dpram = (u16) DWNLD_MAG1_PS_HDR_LOC;
 					if (word_length & 0x1)
 						word_length++;
@@ -850,7 +851,7 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 						status =
 						    fix_ft1000_write_dpram32
 						    (ft1000dev, dpram++,
-						     (u8 *) & templong);
+						     (u8 *) &templong);
 
 					}
 					break;
@@ -1057,12 +1058,12 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
       // Check if Card is present
       status = Harley_Read_Register(&temp, FT1000_REG_SUP_IMASK);
       if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0x0000) ) {
-          break;
+	break;
       }
 
       status = Harley_Read_Register(&temp, FT1000_REG_ASIC_ID);
       if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0xffff) ) {
-          break;
+	break;
       }
 ****/
 
-- 
1.8.3.2

