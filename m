Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaEVXLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:11:42 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48681 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbaEVXLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:11:38 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.151.95]
Date: Thu, 22 May 2014 16:11:38 -0700
Message-ID: <CADadk9FjRgvBqO4FMpz8UrBAh8pV8t4SZnKPVBwyjHzBUw+0=Q@mail.gmail.com>
Subject: [PATCH] Staging: Media: sn9c102: Fixed a pointer declaration coding
 style issue
From: Chaitanya <c@24.io>
To: Luca Risolia <luca.risolia@studio.unibo.it>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the ERROR thrown off by checkpatch.pl.

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
b/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
index a30bbc4..725de85 100644
--- a/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
+++ b/drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
@@ -23,7 +23,7 @@
 #include "sn9c102_devtable.h"


-static int tas5130d1b_init(struct sn9c102_device* cam)
+static int tas5130d1b_init(struct sn9c102_device *cam)
 {
  int err;

@@ -36,8 +36,8 @@ static int tas5130d1b_init(struct sn9c102_device* cam)
 }


-static int tas5130d1b_set_ctrl(struct sn9c102_device* cam,
-       const struct v4l2_control* ctrl)
+static int tas5130d1b_set_ctrl(struct sn9c102_device *cam,
+       const struct v4l2_control *ctrl)
 {
  int err = 0;

@@ -56,10 +56,10 @@ static int tas5130d1b_set_ctrl(struct sn9c102_device* cam,
 }


-static int tas5130d1b_set_crop(struct sn9c102_device* cam,
-       const struct v4l2_rect* rect)
+static int tas5130d1b_set_crop(struct sn9c102_device *cam,
+       const struct v4l2_rect *rect)
 {
- struct sn9c102_sensor* s = sn9c102_get_sensor(cam);
+ struct sn9c102_sensor *s = sn9c102_get_sensor(cam);
  u8 h_start = (u8)(rect->left - s->cropcap.bounds.left) + 104,
    v_start = (u8)(rect->top - s->cropcap.bounds.top) + 12;
  int err = 0;
@@ -76,8 +76,8 @@ static int tas5130d1b_set_crop(struct sn9c102_device* cam,
 }


-static int tas5130d1b_set_pix_format(struct sn9c102_device* cam,
-     const struct v4l2_pix_format* pix)
+static int tas5130d1b_set_pix_format(struct sn9c102_device *cam,
+     const struct v4l2_pix_format *pix)
 {
  int err = 0;

@@ -146,7 +146,7 @@ static const struct sn9c102_sensor tas5130d1b = {
 };


-int sn9c102_probe_tas5130d1b(struct sn9c102_device* cam)
+int sn9c102_probe_tas5130d1b(struct sn9c102_device *cam)
 {
  const struct usb_device_id tas5130d1b_id_table[] = {
  { USB_DEVICE(0x0c45, 0x6024), },
-- 
1.9.1
