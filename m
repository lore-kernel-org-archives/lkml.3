Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaK2Pj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 10:39:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaK2Pj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 10:39:27 -0500
From: Athira S <athirasnamby@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira S <athirasnamby@gmail.com>
Subject: [PATCH] Drivers:input:mousedev.c: Fixed trailing statement on the next line
Date: Sat, 29 Nov 2014 21:09:08 +0530
Message-Id: <1417275548-3431-1-git-send-email-athirasnamby@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch error:
trailing statements should be on next line

Signed-off-by: Athira S <athirasnamby@gmail.com>
---
 drivers/input/mousedev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index b604564..be2cc5c 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -248,7 +248,8 @@ static void mousedev_key_event(struct mousedev *mousedev,
 	case BTN_4:
 	case BTN_EXTRA:		index = 4; break;
 
-	default:		return;
+	default:
+	return;
 	}
 
 	if (value) {
-- 
1.9.1

