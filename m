Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaAUTwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:52:01 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33563 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaAUTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:51:57 -0500
Date: Tue, 21 Jan 2014 20:51:53 +0100
From: Robin Schroer <sulamiification@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/hid/wacom: fixed coding style issues
Message-ID: <20140121195153.GA4198@fedora.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues regarding spaces before semicolons and
closing parenthesis.

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/hid/hid-wacom.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 60c75dc..ebcca0d 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -77,8 +77,8 @@ static void wacom_scramble(__u8 *image)
 	__u16 mask;
 	__u16 s1;
 	__u16 s2;
-	__u16 r1 ;
-	__u16 r2 ;
+	__u16 r1;
+	__u16 r2;
 	__u16 r;
 	__u8 buf[256];
 	int i, w, x, y, z;
@@ -336,7 +336,7 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
 
 	switch (hdev->product) {
 	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
-		rep_data[0] = 0x03 ; rep_data[1] = 0x00;
+		rep_data[0] = 0x03; rep_data[1] = 0x00;
 		limit = 3;
 		do {
 			ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
@@ -404,7 +404,7 @@ static ssize_t wacom_store_speed(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	int new_speed;
 
-	if (sscanf(buf, "%1d", &new_speed ) != 1)
+	if (sscanf(buf, "%1d", &new_speed) != 1)
 		return -EINVAL;
 
 	if (new_speed == 0 || new_speed == 1) {
-- 
1.8.4.2

