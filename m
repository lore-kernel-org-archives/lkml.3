Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054Ab3BSTOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:14:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806Ab3BSSuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniele Palmas <dnlplm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 15/81] USB: qcserial: add Telit Gobi QDL device
Date: Tue, 19 Feb 2013 15:48:38 -0300
Message-Id: <1361299784-8830-16-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 78796ae17eacedcdcaaeb03ba73d2e532a4c8f83 upstream.

Add VID and PID for Telit Gobi QDL device

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 996015c..4302733 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -55,6 +55,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_G1K(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+	{DEVICE_G1K(0x1bc7, 0x900e)},	/* Telit Gobi QDL device */
 
 	/* Gobi 2000 devices */
 	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi 2000 QDL device */
-- 
1.7.9.5

