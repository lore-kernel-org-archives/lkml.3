Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3K1SwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:52:06 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:38483 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3K1SwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:52:04 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5rDWwSjjbQ==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] loop: fix comment typo in loop_config_discard
Date: Thu, 28 Nov 2013 19:51:56 +0100
Message-Id: <1385664716-14806-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discard requests are ignored if the encryption is enabled for the given
loop device. Update comment to match the code, and similar comments
elsewhere in the file.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c8dac73..586e6f53 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -798,7 +798,7 @@ static void loop_config_discard(struct loop_device *lo)
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
-	 * image a.k.a. discard. However we do support discard if
+	 * image a.k.a. discard. However we do not support discard if
 	 * encryption is enabled, because it may give an attacker
 	 * useful information.
 	 */
