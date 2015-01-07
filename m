Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbbAGJkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:40:20 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51588 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbAGJkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:40:08 -0500
From: Fabian Holler <fabian.holler@profitbricks.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabian Holler <fabian.holler@profitbricks.com>
Subject: [PATCH 3/3] staging: android: remove space after casts
Date: Wed,  7 Jan 2015 10:39:54 +0100
Message-Id: <5b1e897f693d41bf28d538afd9d230e2718e5bf9.1420622282.git.fabian.holler@profitbricks.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1420622282.git.fabian.holler@profitbricks.com>
References: <cover.1420622282.git.fabian.holler@profitbricks.com>
In-Reply-To: <cover.1420622282.git.fabian.holler@profitbricks.com>
References: <cover.1420622282.git.fabian.holler@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warnings:
	ashmem.c:753: CHECK:SPACING: No space is necessary after a cast
	ashmem.c:756: CHECK:SPACING: No space is necessary after a cast
	ashmem.c:777: CHECK:SPACING: No space is necessary after a cast

Signed-off-by: Fabian Holler <fabian.holler@profitbricks.com>
---
 drivers/staging/android/ashmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 6b228d9..d140b733 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -750,10 +750,10 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case ASHMEM_SET_NAME:
-		ret = set_name(asma, (void __user *) arg);
+		ret = set_name(asma, (void __user *)arg);
 		break;
 	case ASHMEM_GET_NAME:
-		ret = get_name(asma, (void __user *) arg);
+		ret = get_name(asma, (void __user *)arg);
 		break;
 	case ASHMEM_SET_SIZE:
 		ret = -EINVAL;
@@ -774,7 +774,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case ASHMEM_PIN:
 	case ASHMEM_UNPIN:
 	case ASHMEM_GET_PIN_STATUS:
-		ret = ashmem_pin_unpin(asma, cmd, (void __user *) arg);
+		ret = ashmem_pin_unpin(asma, cmd, (void __user *)arg);
 		break;
 	case ASHMEM_PURGE_ALL_CACHES:
 		ret = -EPERM;
-- 
2.1.3

