Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaANO10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:27:26 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45347 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:27:23 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: m.chehab@samsung.com, gregkh@linuxfoundation.org,
        monamagarwal123@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com
Subject: [PATCH] Staging: media: Fix line length exceeding 80 characters in as102_drv.c
Date: Tue, 14 Jan 2014 19:57:08 +0530
Message-Id: <1389709628-3421-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning in as102/as102_drv.c
WARNING: line over 80 characters in the file 

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 8b7bb95..7c294bf 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -133,7 +133,8 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 		filter.pid = pid;
 
 		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
-		dprintk(debug, "ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
+		dprintk(debug,
+			"ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
 			index, filter.idx, filter.pid, ret);
 		break;
 	}
-- 
1.7.9.5

