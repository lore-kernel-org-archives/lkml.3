Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFMGQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:16:06 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60273 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaFMGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:16:01 -0400
From: pramod.gurav.etc@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
        Pramod Gurav <pramod.gurav.etc@gmail.com>
Subject: [PATCH v2 2/2] staging: alarm-dev: Support to Compile as Module
Date: Fri, 13 Jun 2014 11:49:43 +0530
Message-Id: <1402640383-13324-2-git-send-email-pramod.gurav.etc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402640383-13324-1-git-send-email-pramod.gurav.etc@gmail.com>
References: <1402640383-13324-1-git-send-email-pramod.gurav.etc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav.etc@gmail.com>

Currently this alarm-dev can be compiles only as built in
driver. This adds support to compile it as module as well which is in
planned activity (See drivers/staging/android/TODO)


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

