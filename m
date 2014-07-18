Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbaGRJcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:32:00 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56580 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933956AbaGRJb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:31:57 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 3/9] usb: musb_am335x: source cleanup
Date: Fri, 18 Jul 2014 11:31:24 +0200
Message-Id: <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove comma after end of list delimiter
  The empty entry must always be the last item in the list, thus there
  is no point in having a trailing comma to facilitate adding
  succeding entries.
  Remove the comma, so that inadvertedly adding an entry after the end
  of list sentinel will produce a compile time error rather than an
  unreachable entry in the list.
- consistently use tabs for indentation

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/musb/musb_am335x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_am335x.c b/drivers/usb/musb/musb_am335x.c
index 1e58ed2..164c868 100644
--- a/drivers/usb/musb/musb_am335x.c
+++ b/drivers/usb/musb/musb_am335x.c
@@ -21,14 +21,14 @@ err:
 
 static const struct of_device_id am335x_child_of_match[] = {
 	{ .compatible = "ti,am33xx-usb" },
-	{  },
+	{  }
 };
 MODULE_DEVICE_TABLE(of, am335x_child_of_match);
 
 static struct platform_driver am335x_child_driver = {
 	.probe		= am335x_child_probe,
-	.driver         = {
-		.name   = "am335x-usb-childs",
+	.driver		= {
+		.name	= "am335x-usb-childs",
 		.of_match_table	= am335x_child_of_match,
 	},
 };
-- 
1.7.10.4

