Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaEDQco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:32:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaEDPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 121/158] media: media: gspca: sn9c20x: add ID for Genius Look 1320 V2
Date: Sun,  4 May 2014 11:40:30 -0400
Message-Id: <20140504154046.442087799@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 61f0319193c44adbbada920162d880b1fdb3aeb3 upstream.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/usb/gspca/sn9c20x.c   |    1 +
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
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -2359,6 +2359,7 @@ static const struct usb_device_id device
 	{USB_DEVICE(0x045e, 0x00f4), SN9C20X(OV9650, 0x30, 0)},
 	{USB_DEVICE(0x145f, 0x013d), SN9C20X(OV7660, 0x21, 0)},
 	{USB_DEVICE(0x0458, 0x7029), SN9C20X(HV7131R, 0x11, 0)},
+	{USB_DEVICE(0x0458, 0x7045), SN9C20X(MT9M112, 0x5d, LED_REVERSE)},
 	{USB_DEVICE(0x0458, 0x704a), SN9C20X(MT9M112, 0x5d, 0)},
 	{USB_DEVICE(0x0458, 0x704c), SN9C20X(MT9M112, 0x5d, 0)},
 	{USB_DEVICE(0xa168, 0x0610), SN9C20X(HV7131R, 0x11, 0)},


