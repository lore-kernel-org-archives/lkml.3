Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaKSPpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:45:51 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:43999 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaKSPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:45:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] MAINTAINERS: Remove Sam from MFD Maintainers list
Date: Wed, 19 Nov 2014 15:45:35 +0000
Message-Id: <1416411935-2102-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam hasn't been active in MFD for around a year now.  If he'd like
to come and play again I'll be only too pleased to have him aboard.
Until then we can save submitters that little bit of work and
simultaneously stop spamming Sam with emails he likely doesn't care
about.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f10ed39..277b667 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6080,7 +6080,6 @@ F:	drivers/media/i2c/mt9v032.c
 F:	include/media/mt9v032.h
 
 MULTIFUNCTION DEVICES (MFD)
-M:	Samuel Ortiz <sameo@linux.intel.com>
 M:	Lee Jones <lee.jones@linaro.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git
 S:	Supported
-- 
1.9.1

