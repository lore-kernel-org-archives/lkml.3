Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab3AYNY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:24:58 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45559 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab3AYNYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:24:22 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/25] HID: multitouch: remove useless DUAL_NSMU_CONTACTID class
Date: Fri, 25 Jan 2013 14:23:09 +0100
Message-Id: <1359120190-18281-25-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e019608..e3f0bf7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -116,7 +116,6 @@ struct mt_device {
 #define MT_CLS_CONFIDENCE_MINUS_ONE		0x0005
 #define MT_CLS_DUAL_INRANGE_CONTACTID		0x0006
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0007
-#define MT_CLS_DUAL_NSMU_CONTACTID		0x0008
 #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
 #define MT_CLS_ALWAYS_TRUE			0x000a
 #define MT_CLS_CONTACT_ID			0x0011
@@ -175,10 +174,6 @@ static struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
 		.maxcontacts = 2 },
-	{ .name = MT_CLS_DUAL_NSMU_CONTACTID,
-		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
-			MT_QUIRK_SLOT_IS_CONTACTID,
-		.maxcontacts = 2 },
 	{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
-- 
1.8.1

