Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3LSPvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:51:53 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55917 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab3LSPvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:51:51 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rjw@rjwysocki.net
Cc: linux-acpi@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] acpi: Fix typo in video_detect.c
Date: Fri, 20 Dec 2013 00:51:37 +0900
Message-Id: <1387468297-10678-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct "**retyurn_value" to "**return_value".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/acpi/video_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 84875fd..f0447d3 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -50,7 +50,7 @@ static bool acpi_video_caps_checked;
 
 static acpi_status
 acpi_backlight_cap_match(acpi_handle handle, u32 level, void *context,
-			  void **retyurn_value)
+			  void **return_value)
 {
 	long *cap = context;
 
-- 
1.8.5.1.163.gd7aced9

