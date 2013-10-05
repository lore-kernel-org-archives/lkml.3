Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3JEQLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:11:15 -0400
Received: from libra.uberspace.de ([95.143.172.171]:45184 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752135Ab3JEQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:11:13 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Oct 2013 12:11:12 EDT
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 1/5] drivers: usb: core: hcd: moved asterix to variable
Date: Sat,  5 Oct 2013 18:02:06 +0200
Message-Id: <79a196f5038eebeead7ca0d28d1d5adfc0a4afa2.1380986962.git.mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of type

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d6a8d23..9036794 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2818,7 +2818,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 EXPORT_SYMBOL_GPL(usb_remove_hcd);
 
 void
-usb_hcd_platform_shutdown(struct platform_device* dev)
+usb_hcd_platform_shutdown(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
-- 
1.8.4

