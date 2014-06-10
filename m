Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaFJVf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:35:58 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41627 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaFJVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:35:56 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH] HID: drop remove Unicode non-breaking space from Kconfig
Date: Tue, 10 Jun 2014 14:35:36 -0700
Message-Id: <1402436136-17918-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a UTF-8 non-breaking space character (0xc2 0xa0) after the "Y"
in "Say Y here". This is probably not intentional. Replace it with a
standard ASCII space (0x20).

If you can't see a difference here, I don't blame you :)

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org
---
 drivers/hid/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 800c8b60f7a2..08c9693e6f83 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -785,7 +785,7 @@ config HID_XINMO
 	depends on HID
 	---help---
 	Support for Xin-Mo devices that are not fully compliant with the HID
-	standard. Currently only supports the Xin-Mo Dual Arcade. Say Y here
+	standard. Currently only supports the Xin-Mo Dual Arcade. Say Y here
 	if you have a Xin-Mo Dual Arcade controller.
 
 config HID_ZEROPLUS
-- 
1.9.1

