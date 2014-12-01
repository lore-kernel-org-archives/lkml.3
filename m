Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaLAMg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:36:59 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41636 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaLAMg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:36:56 -0500
From: Athira Sharikkal <athirasnamby@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira Sharikkal <athirasnamby@gmail.com>
Subject: [PATCH v2] Drivers: input: mousedev.c: Fixed trailing statement on the next line
Date: Mon,  1 Dec 2014 18:06:42 +0530
Message-Id: <1417437402-3365-1-git-send-email-athirasnamby@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch error:
trailing statements should be on next line

Signed-off-by: Athira Sharikkal <athirasnamby@gmail.com>
---
v2: corrected indentation
 drivers/input/mousedev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index b604564..28988f5 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -248,7 +248,8 @@ static void mousedev_key_event(struct mousedev *mousedev,
 	case BTN_4:
 	case BTN_EXTRA:		index = 4; break;
 
-	default:		return;
+	default:	
+				return;
 	}
 
 	if (value) {
-- 
1.9.1

