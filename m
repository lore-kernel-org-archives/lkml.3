Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3AXDbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:31:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44399 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3AXDbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Fleig <andreasfleig@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 57/74] USB: Add device quirk for Microsoft VX700 webcam
Date: Thu, 24 Jan 2013 01:27:09 -0200
Message-Id: <1358998046-613-58-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Fleig <andreasfleig@gmail.com>

commit bc009eca8d539162f7271c2daf0ab5e9e3bb90a0 upstream.

Add device quirk for Microsoft Lifecam VX700 v2.0 webcams.
Fixes squeaking noise of the microphone.

Signed-off-by: Andreas Fleig <andreasfleig@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 8b2a9d8..3f08c09 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -38,6 +38,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Microsoft LifeCam-VX700 v2.0 */
+	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Webcam C200 */
 	{ USB_DEVICE(0x046d, 0x0802), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.7.9.5

