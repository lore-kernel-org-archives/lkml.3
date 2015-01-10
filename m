Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbbAJOhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 09:37:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:58975 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbAJOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:37:45 -0500
From: Piotr Kubus <p.t.kubus@gmail.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Piotr Kubus <p.t.kubus@gmail.com>
Subject: [PATCH] Staging: vt6655: fix a space coding style issue
Date: Sat, 10 Jan 2015 15:35:45 +0100
Message-Id: <1420900545-27858-1-git-send-email-p.t.kubus@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a space coding style issue found by checkpatch.pl in rxtx.c.

Signed-off-by: Piotr Kubus <p.t.kubus@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 61c39dd..8047838 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -205,7 +205,7 @@ s_uGetRTSCTSRsvTime(
 	unsigned short wCurrentRate
 )
 {
-	unsigned int uRrvTime  , uRTSTime, uCTSTime, uAckTime, uDataTime;
+	unsigned int uRrvTime, uRTSTime, uCTSTime, uAckTime, uDataTime;
 
 	uRrvTime = uRTSTime = uCTSTime = uAckTime = uDataTime = 0;
 
-- 
1.9.1

