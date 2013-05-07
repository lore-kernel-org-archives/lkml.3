Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3EGOB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:01:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42402 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3EGNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Jencks <ben@bjencks.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 071/118] usb/misc/appledisplay: Add 24" LED Cinema display
Date: Tue,  7 May 2013 14:38:37 +0100
Message-Id: <1367933964-1564-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Jencks <ben@bjencks.net>

commit e7d3b6e22c871ba36d052ca99bc8ceca4d546a60 upstream.

Add the Apple 24" LED Cinema display to the supported devices.

Signed-off-by: Ben Jencks <ben@bjencks.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/misc/appledisplay.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 0fc6e5f..ba6a5d6 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -63,6 +63,7 @@ static const struct usb_device_id appledisplay_table[] = {
 	{ APPLEDISPLAY_DEVICE(0x9219) },
 	{ APPLEDISPLAY_DEVICE(0x921c) },
 	{ APPLEDISPLAY_DEVICE(0x921d) },
+	{ APPLEDISPLAY_DEVICE(0x9236) },
 
 	/* Terminating entry */
 	{ }
-- 
1.8.1.2

