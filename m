Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbaFLKel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:34:41 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59186 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443AbaFLKeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:34:36 -0400
From: pramod.gurav.etc@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav.etc@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Brian Swetland <swetland@google.com>
Subject: [PATCH] staging: alarm-dev: Support to Compile as Module
Date: Thu, 12 Jun 2014 16:08:15 +0530
Message-Id: <1402569495-11308-1-git-send-email-pramod.gurav.etc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav.etc@gmail.com>

Currently this alarm-dev can be compiles only as built in
driver. This adds support to compile it as module as well.
This has dependancy on:
https://lkml.org/lkml/2014/6/12/180

which exports symbol of alarmtimer function.

CC: Greg Kroah-Hartman <greg@kroah.com>
CC: Brian Swetland <swetland@google.com>
Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
---
 drivers/staging/android/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 99e484f..c359317 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -76,7 +76,7 @@ config ANDROID_LOW_MEMORY_KILLER
 	  Registers processes to be killed when memory is low
 
 config ANDROID_INTF_ALARM_DEV
-	bool "Android alarm driver"
+	tristate "Android alarm driver"
 	depends on RTC_CLASS
 	default n
 	---help---
-- 
1.7.9.5

