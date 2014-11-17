Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaKQQ7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:59:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61586 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKQQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:59:45 -0500
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-kernel@vger.kernel.org, jg1.han@samsung.com, crope@iki.fi,
        mchehab@osg.samsung.com, joe@perches.com, gregkh@linuxfoundation.org,
        davem@davemloft.net, akpm@linux-foundation.org,
        linux-media@vger.kernel.org
Cc: maintainers@bluecherrydvr.com, andrey.krieger.utkin@gmail.com,
        ismael.luceno@gmail.com,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] Update MAINTAINERS for solo6x10
Date: Mon, 17 Nov 2014 20:59:23 +0400
Message-Id: <1416243563-8087-1-git-send-email-andrey.utkin@corp.bluecherry.net>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb38f02..f5cef1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8787,7 +8787,9 @@ S:	Maintained
 F:	drivers/leds/leds-net48xx.c
 
 SOFTLOGIC 6x10 MPEG CODEC
-M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
+M:	Bluecherry Maintainers <maintainers@bluecherrydvr.com>
+M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
+M:	Andrey Utkin <andrey.krieger.utkin@gmail.com>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/pci/solo6x10/
-- 
2.0.4

