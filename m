Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbaDVUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:25:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252AbaDVUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:25:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <wsa@the-dreams.de>, Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 040/133] [media] media: gspca: sn9c20x: add ID for Genius Look 1320 V2
Date: Tue, 22 Apr 2014 13:12:58 -0700
Message-Id: <1398197671-12786-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 61f0319193c44adbbada920162d880b1fdb3aeb3 upstream.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/video4linux/gspca.txt | 1 +
 drivers/media/usb/gspca/sn9c20x.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index 1e6b653..d2ba80b 100644
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
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 41f769f..9ccde23 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -2394,6 +2394,7 @@ static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x045e, 0x00f4), SN9C20X(OV9650, 0x30, 0)},
 	{USB_DEVICE(0x145f, 0x013d), SN9C20X(OV7660, 0x21, 0)},
 	{USB_DEVICE(0x0458, 0x7029), SN9C20X(HV7131R, 0x11, 0)},
+	{USB_DEVICE(0x0458, 0x7045), SN9C20X(MT9M112, 0x5d, LED_REVERSE)},
 	{USB_DEVICE(0x0458, 0x704a), SN9C20X(MT9M112, 0x5d, 0)},
 	{USB_DEVICE(0x0458, 0x704c), SN9C20X(MT9M112, 0x5d, 0)},
 	{USB_DEVICE(0xa168, 0x0610), SN9C20X(HV7131R, 0x11, 0)},
-- 
1.9.1

