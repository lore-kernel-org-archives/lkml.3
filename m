Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393Ab3JPTV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:21:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44812 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288Ab3JPTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:21:50 -0400
From: Dhanunjaya Naidu Ravada <dhanunjaya.matrix@gmail.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, peterhuewe@gmx.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dhanunjaya <dhanunjaya.matrix@gmail.com>
Subject: [PATCH 4/4] Staging: xgifb: fix space prohibited before semicolon.
Date: Thu, 17 Oct 2013 00:51:25 +0530
Message-Id: <1381951285-20568-2-git-send-email-dhanunjaya.matrix@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381951285-20568-1-git-send-email-dhanunjaya.matrix@gmail.com>
References: <1381951285-20568-1-git-send-email-dhanunjaya.matrix@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhanunjaya <dhanunjaya.matrix@gmail.com>

This is a patch to the vb_table.h file that fixes the
space prohibited before semicolon warning found by the
checkpatch.pl tool.

Signed-off-by: Dhanunjaya Naidu Ravada <dhanunjaya.matrix@gmail.com>
---
 drivers/staging/xgifb/vb_table.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 7168eed..f17e5b9 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -1284,7 +1284,7 @@ static const struct SiS_LVDSData XGI_LVDS1024x768Des_1[] = {
 	{0, 1048,   0, 771}, /* 04 (640x480x60Hz) */
 	{0, 1048,   0, 771}, /* 05 (800x600x60Hz) */
 	{0, 1048, 805, 770}  /* 06 (1024x768x60Hz) */
-} ;
+};
 
 static const struct SiS_LVDSData XGI_LVDS1024x768Des_2[] = {
 	{1142,  856, 622, 587}, /* 00 (320x200,320x400,640x200,640x400) */
-- 
1.8.1.2

