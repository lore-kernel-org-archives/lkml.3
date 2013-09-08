Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab3IHDiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:38:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56160 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756646Ab3IHDTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rick Farina (Zero_Chaos)" <zerochaos@gentoo.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.312363339@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [049/121] USB: serial: ftdi_sio: add more RT Systems ftdi devices
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Rick Farina (Zero_Chaos)" <zerochaos@gentoo.org>

commit fed1f1ed90bce42ea010e2904cbc04e7b8304940 upstream.

RT Systems makes many usb serial cables based on the ftdi_sio driver for
programming various amateur radios.  This patch is a full listing of
their current product offerings and should allow these cables to all
be recognized.

Signed-off-by: Rick Farina (Zero_Chaos) <zerochaos@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 31 ++++++++++++++++++++++++++++---
 drivers/usb/serial/ftdi_sio_ids.h | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 57 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -743,9 +743,34 @@ static struct usb_device_id id_table_com
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
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -815,11 +815,35 @@
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

