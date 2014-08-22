Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaHVQtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:49:13 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63725 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaHVQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:49:11 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] include/linux/mfd/davinci_voicecodec.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 18:49:03 +0200
Message-Id: <1408726143-3014-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The include guard doesn't work as intended due to the transposition
typo DAVINCI -> DAVINIC.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/mfd/davinci_voicecodec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/davinci_voicecodec.h b/include/linux/mfd/davinci_voicecodec.h
index 5166935..cb01496 100644
--- a/include/linux/mfd/davinci_voicecodec.h
+++ b/include/linux/mfd/davinci_voicecodec.h
@@ -21,7 +21,7 @@
  */
 
 #ifndef __LINUX_MFD_DAVINCI_VOICECODEC_H_
-#define __LINUX_MFD_DAVINIC_VOICECODEC_H_
+#define __LINUX_MFD_DAVINCI_VOICECODEC_H_
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-- 
2.0.4

