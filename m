Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab3EFW7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:59:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963Ab3EFW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:58:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Jencks <ben@bjencks.net>
Subject: [ 05/46] usb/misc/appledisplay: Add 24" LED Cinema display
Date: Mon,  6 May 2013 15:58:11 -0700
Message-Id: <20130506225821.227008307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Jencks <ben@bjencks.net>

commit e7d3b6e22c871ba36d052ca99bc8ceca4d546a60 upstream.

Add the Apple 24" LED Cinema display to the supported devices.

Signed-off-by: Ben Jencks <ben@bjencks.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/appledisplay.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -63,6 +63,7 @@ static const struct usb_device_id appled
 	{ APPLEDISPLAY_DEVICE(0x9219) },
 	{ APPLEDISPLAY_DEVICE(0x921c) },
 	{ APPLEDISPLAY_DEVICE(0x921d) },
+	{ APPLEDISPLAY_DEVICE(0x9236) },
 
 	/* Terminating entry */
 	{ }


