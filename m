Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3IKF0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:26:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab3IKE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:25 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=9vDy3PGok7oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VnZ5lZ6KOC8A:10 a=7mOBRU54AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=8B-QWBJU1BGdP1FKeCAA:9 a=WeOa-AV5lc8A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042911.265821313@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Rick Farina (Zero_Chaos)" <zerochaos@gentoo.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [114/251] USB: serial: ftdi_sio: add more RT Systems ftdi devices
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0114-USB-serial-ftdi_sio-add-more-RT-Systems-ftdi-devices.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Rick Farina (Zero_Chaos)" <zerochaos@gentoo.org>

[ Upstream commit fed1f1ed90bce42ea010e2904cbc04e7b8304940 ]

RT Systems makes many usb serial cables based on the ftdi_sio driver for
programming various amateur radios.  This patch is a full listing of
their current product offerings and should allow these cables to all
be recognized.

Signed-off-by: Rick Farina (Zero_Chaos) <zerochaos@gentoo.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ftdi_sio.c     |   31 ++++++++++++++++++++++++++++---
 drivers/usb/serial/ftdi_sio_ids.h |   34 +++++++++++++++++++++++++++++-----
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5c3e249..710302ea 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -741,9 +741,34 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
-	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_RTS01_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S03_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_59_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57A_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_57B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29A_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29F_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_62B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S01_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_63_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_29C_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_81B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_82B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K5D_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K4Y_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_K5G_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_S05_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_60_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_61_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_62_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_63B_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_64_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_65_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_92_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_92D_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_W5R_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_A5R_PID) },
+	{ USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_USB_PW1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1e4bff5..b98e44a 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -808,11 +808,35 @@
 /*
  * RT Systems programming cables for various ham radios
  */
-#define RTSYSTEMS_VID			0x2100	/* Vendor ID */
-#define RTSYSTEMS_SERIAL_VX7_PID	0x9e52	/* Serial converter for VX-7 Radios using FT232RL */
-#define RTSYSTEMS_CT29B_PID		0x9e54	/* CT29B Radio Cable */
-#define RTSYSTEMS_RTS01_PID		0x9e57	/* USB-RTS01 Radio Cable */
-
+#define RTSYSTEMS_VID		0x2100	/* Vendor ID */
+#define RTSYSTEMS_USB_S03_PID	0x9001	/* RTS-03 USB to Serial Adapter */
+#define RTSYSTEMS_USB_59_PID	0x9e50	/* USB-59 USB to 8 pin plug */
+#define RTSYSTEMS_USB_57A_PID	0x9e51	/* USB-57A USB to 4pin 3.5mm plug */
+#define RTSYSTEMS_USB_57B_PID	0x9e52	/* USB-57B USB to extended 4pin 3.5mm plug */
+#define RTSYSTEMS_USB_29A_PID	0x9e53	/* USB-29A USB to 3.5mm stereo plug */
+#define RTSYSTEMS_USB_29B_PID	0x9e54	/* USB-29B USB to 6 pin mini din */
+#define RTSYSTEMS_USB_29F_PID	0x9e55	/* USB-29F USB to 6 pin modular plug */
+#define RTSYSTEMS_USB_62B_PID	0x9e56	/* USB-62B USB to 8 pin mini din plug*/
+#define RTSYSTEMS_USB_S01_PID	0x9e57	/* USB-RTS01 USB to 3.5 mm stereo plug*/
+#define RTSYSTEMS_USB_63_PID	0x9e58	/* USB-63 USB to 9 pin female*/
+#define RTSYSTEMS_USB_29C_PID	0x9e59	/* USB-29C USB to 4 pin modular plug*/
+#define RTSYSTEMS_USB_81B_PID	0x9e5A	/* USB-81 USB to 8 pin mini din plug*/
+#define RTSYSTEMS_USB_82B_PID	0x9e5B	/* USB-82 USB to 2.5 mm stereo plug*/
+#define RTSYSTEMS_USB_K5D_PID	0x9e5C	/* USB-K5D USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_K4Y_PID	0x9e5D	/* USB-K4Y USB to 2.5/3.5 mm plugs*/
+#define RTSYSTEMS_USB_K5G_PID	0x9e5E	/* USB-K5G USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_S05_PID	0x9e5F	/* USB-RTS05 USB to 2.5 mm stereo plug*/
+#define RTSYSTEMS_USB_60_PID	0x9e60	/* USB-60 USB to 6 pin din*/
+#define RTSYSTEMS_USB_61_PID	0x9e61	/* USB-61 USB to 6 pin mini din*/
+#define RTSYSTEMS_USB_62_PID	0x9e62	/* USB-62 USB to 8 pin mini din*/
+#define RTSYSTEMS_USB_63B_PID	0x9e63	/* USB-63 USB to 9 pin female*/
+#define RTSYSTEMS_USB_64_PID	0x9e64	/* USB-64 USB to 9 pin male*/
+#define RTSYSTEMS_USB_65_PID	0x9e65	/* USB-65 USB to 9 pin female null modem*/
+#define RTSYSTEMS_USB_92_PID	0x9e66	/* USB-92 USB to 12 pin plug*/
+#define RTSYSTEMS_USB_92D_PID	0x9e67	/* USB-92D USB to 12 pin plug data*/
+#define RTSYSTEMS_USB_W5R_PID	0x9e68	/* USB-W5R USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_A5R_PID	0x9e69	/* USB-A5R USB to 8 pin modular plug*/
+#define RTSYSTEMS_USB_PW1_PID	0x9e6A	/* USB-PW1 USB to 8 pin modular plug*/
 
 /*
  * Physik Instrumente
-- 
1.7.10.4


