Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab3BYNGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:06:36 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57984 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab3BYNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:06:35 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: gregkh@linuxfoundation.org
Cc: stefanha@gmail.com, morbidrsa@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] staging: line6: pod.c: fix checkpatch warning
Date: Mon, 25 Feb 2013 14:08:49 +0100
Message-Id: <1361797729-19489-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/staging/line6/pod.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 74898c3..699b217 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -148,9 +148,8 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 	    buf[0] != (LINE6_SYSEX_BEGIN | LINE6_CHANNEL_UNKNOWN)) {
 		return;
 	}
-	if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) != 0) {
+	if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) != 0)
 		return;
-	}
 
 	if (buf[5] == POD_SYSEX_SYSTEM && buf[6] == POD_MONITOR_LEVEL) {
 		short value = ((int)buf[7] << 12) | ((int)buf[8] << 8) |
-- 
1.7.10.4

