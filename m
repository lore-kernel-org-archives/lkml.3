Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbbA0PWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:22:55 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39377 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbA0PWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:22:52 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>,
        Mark Salyzyn <salyzyn@google.com>, Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Greg Hackmann <ghackmann@google.com>, Elliott Hughes <enh@google.com>,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH] staging: Remove logger and alarm-dev from android Makefile
Date: Tue, 27 Jan 2015 07:22:21 -0800
Message-Id: <1422372141-2440-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422350658.14015.9.camel@x220>
References: <1422350658.14015.9.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous patches deleting logger and alarm-dev from staging
missed the android Makefile.

This patch cleans up the Makefile to remove the now non-existent
files.

Cc: Rom Lemarchand <romlem@google.com>,
Cc: Mark Salyzyn <salyzyn@google.com>,
Cc: Kees Cook <keescook@chromium.org>,
Cc: Android Kernel Team <kernel-team@android.com>,
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
Cc: Greg Hackmann <ghackmann@google.com>,
Cc: Elliott Hughes <enh@google.com>,
Cc: Todd Poynor <toddpoynor@google.com>,
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 479b2b8..c7b6c99 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -3,10 +3,8 @@ ccflags-y += -I$(src)			# needed for trace events
 obj-y					+= ion/
 
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
-obj-$(CONFIG_ANDROID_LOGGER)		+= logger.o
 obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+= timed_output.o
 obj-$(CONFIG_ANDROID_TIMED_GPIO)	+= timed_gpio.o
 obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
-obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+= alarm-dev.o
 obj-$(CONFIG_SYNC)			+= sync.o sync_debug.o
 obj-$(CONFIG_SW_SYNC)			+= sw_sync.o
-- 
1.9.1

