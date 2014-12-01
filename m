Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaLAQxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:53:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaLAQwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:52:54 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, Ping Cheng <pinglinux@gmail.com>,
        Hans Spath <inbox-546@hans-spath.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] HID: wacom: re-add accidentally dropped Lenovo PID
Date: Mon,  1 Dec 2014 11:52:39 -0500
Message-Id: <1417452760-2763-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropped in the following commit:

commit a3e6f6543d19 ("Input: wacom - keep wacom_ids ordered")
 drivers/input/tablet/wacom_wac.c | 79 +++++++++++++++++++++++++++++++++++++++----------------------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

> -    { USB_DEVICE_LENOVO(0x6004) },

Reported-by: Hans Spath <inbox-546@hans-spath.de>
CC: stable@vger.kernel.org    # v3.17+
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_wac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 1468f00..2b8d1f8 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3046,6 +3046,7 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x4004) },
 	{ USB_DEVICE_WACOM(0x5000) },
 	{ USB_DEVICE_WACOM(0x5002) },
+	{ USB_DEVICE_LENOVO(0x6004) },
 
 	{ USB_DEVICE_WACOM(HID_ANY_ID) },
 	{ }
-- 
2.1.0

