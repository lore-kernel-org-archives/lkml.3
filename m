Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaHaNTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 09:19:15 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38385 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaHaNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 09:19:13 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net,
        rdunlap@infradead.org, pali.rohar@gmail.com, linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: misc-devices: Rename freefall.c from hpfall.c in lis2lv02d
Date: Sun, 31 Aug 2014 22:18:53 +0900
Message-Id: <1409491133-14402-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpfall.c was renamed to freefall.c in 3.16.
But this file still refer to hpfall.c instead of freefall.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/misc-devices/lis3lv02d | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/misc-devices/lis3lv02d b/Documentation/misc-devices/lis3lv02d
index af815b9..f89960a 100644
--- a/Documentation/misc-devices/lis3lv02d
+++ b/Documentation/misc-devices/lis3lv02d
@@ -59,7 +59,7 @@ acts similar to /dev/rtc and reacts on free-fall interrupts received
 from the device. It supports blocking operations, poll/select and
 fasync operation modes. You must read 1 bytes from the device.  The
 result is number of free-fall interrupts since the last successful
-read (or 255 if number of interrupts would not fit). See the hpfall.c
+read (or 255 if number of interrupts would not fit). See the freefall.c
 file for an example on using the device.
 
 
-- 
2.1.0.24.g4109c28

