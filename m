Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaFIP4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:56:06 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37697 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbaFIPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:55:57 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@kernel.org, Alexey Klimov <klimov.linux@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org (open list:MR800 AVERMEDIA U...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5/6] update reference, kerneltrap.org no longer works
Date: Mon,  9 Jun 2014 11:55:25 -0400
Message-Id: <1402329327-6766-5-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402329327-6766-1-git-send-email-bobby.prani@gmail.com>
References: <1402329327-6766-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kerneltrap.org no longer works, update to a working reference

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/media/radio/radio-mr800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index a360227..f476071 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -32,7 +32,7 @@
  * achievements (specifications given).
  * Also, Faidon Liambotis <paravoid@debian.org> wrote nice driver for this radio
  * in 2007. He allowed to use his driver to improve current mr800 radio driver.
- * http://kerneltrap.org/mailarchive/linux-usb-devel/2007/10/11/342492
+ * http://www.spinics.net/lists/linux-usb-devel/msg10109.html
  *
  * Version 0.01:	First working version.
  * 			It's required to blacklist AverMedia USB Radio
-- 
1.9.1

