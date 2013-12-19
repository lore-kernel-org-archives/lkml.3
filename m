Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3LSRC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:02:27 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39393 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3LSRCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:02:21 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, JBottomley@parallels.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] scsi: Fix typo in gdth_ioctl.h
Date: Fri, 20 Dec 2013 02:02:14 +0900
Message-Id: <1387472534-13458-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct structure name typo "drvers" to "drivers"
in gdth_ioctl.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/gdth_ioctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/gdth_ioctl.h b/drivers/scsi/gdth_ioctl.h
index b004c61..047295a9 100644
--- a/drivers/scsi/gdth_ioctl.h
+++ b/drivers/scsi/gdth_ioctl.h
@@ -229,7 +229,7 @@ typedef struct {
         } general;
         struct {
             u16          version;            /* driver version */
-        } drvers;
+        } drivers;
         struct {
             u8          type;               /* controller type */
             u16          info;               /* slot etc. */
-- 
1.8.5.2.192.g7794a68

