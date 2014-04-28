Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaD1Bal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43072 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbaD1B3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wolfram Sang" <wsa@the-dreams.de>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.235285677@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 33/94] [media] media: gspca: sn9c20x: add ID for
 Genius Look 1320 V2
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 61f0319193c44adbbada920162d880b1fdb3aeb3 upstream.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/video4linux/gspca.txt | 1 +
 drivers/media/video/gspca/sn9c20x.c | 1 +
 2 files changed, 2 insertions(+)

--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -55,6 +55,7 @@ zc3xx		0458:700f	Genius VideoCam Web V2
 sonixj		0458:7025	Genius Eye 311Q
 sn9c20x		0458:7029	Genius Look 320s
 sonixj		0458:702e	Genius Slim 310 NB
+sn9c20x		0458:7045	Genius Look 1320 V2
 sn9c20x		0458:704a	Genius Slim 1320
 sn9c20x		0458:704c	Genius i-Look 1321
 sn9c20x		045e:00f4	LifeCam VX-6000 (SN9C20x + OV9650)
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -2521,6 +2521,7 @@ static const struct usb_device_id device
 	{USB_DEVICE(0x045e, 0x00f4), SN9C20X(OV9650, 0x30, 0)},
 	{USB_DEVICE(0x145f, 0x013d), SN9C20X(OV7660, 0x21, 0)},
 	{USB_DEVICE(0x0458, 0x7029), SN9C20X(HV7131R, 0x11, 0)},
+	{USB_DEVICE(0x0458, 0x7045), SN9C20X(MT9M112, 0x5d, LED_REVERSE)},
 	{USB_DEVICE(0x0458, 0x704a), SN9C20X(MT9M112, 0x5d, 0)},
 	{USB_DEVICE(0x0458, 0x704c), SN9C20X(MT9M112, 0x5d, 0)},
 	{USB_DEVICE(0xa168, 0x0610), SN9C20X(HV7131R, 0x11, 0)},

