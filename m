Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbbANH20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:28:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbbANH2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Spath <inbox-546@hans-spath.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.18 052/150] HID: wacom: re-add accidentally dropped Lenovo PID
Date: Tue, 13 Jan 2015 23:22:03 -0800
Message-Id: <20150114072058.234415286@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 00d6f227a5905be47006abcc1f417d069ecc3711 upstream.

Dropped in the following commit:

commit a3e6f6543d19 ("Input: wacom - keep wacom_ids ordered")

Reported-by: Hans Spath <inbox-546@hans-spath.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3026,6 +3026,7 @@ const struct hid_device_id wacom_ids[] =
 	{ USB_DEVICE_WACOM(0x4004) },
 	{ USB_DEVICE_WACOM(0x5000) },
 	{ USB_DEVICE_WACOM(0x5002) },
+	{ USB_DEVICE_LENOVO(0x6004) },
 
 	{ USB_DEVICE_WACOM(HID_ANY_ID) },
 	{ }


