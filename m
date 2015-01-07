Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbbAGJpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:45:52 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:45043 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbAGJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:45:50 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2015 04:45:50 EST
From: Fabian Holler <fabian.holler@profitbricks.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabian Holler <fabian.holler@profitbricks.com>
Subject: [PATCH 2/3] staging: android: remove blank lines after open braces
Date: Wed,  7 Jan 2015 10:39:53 +0100
Message-Id: <1f31dcecb2292f8dc7d5b5958c51d738d36074ee.1420622282.git.fabian.holler@profitbricks.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1420622282.git.fabian.holler@profitbricks.com>
References: <cover.1420622282.git.fabian.holler@profitbricks.com>
In-Reply-To: <cover.1420622282.git.fabian.holler@profitbricks.com>
References: <cover.1420622282.git.fabian.holler@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warnings:
	ashmem.c:552: CHECK:BRACES: Blank lines aren't necessary after an open brace '{'
	ashmem.c:801: CHECK:BRACES: Blank lines aren't necessary after an open brace

Signed-off-by: Fabian Holler <fabian.holler@profitbricks.com>
---
 drivers/staging/android/ashmem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 181a71e..6b228d9 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -549,7 +549,6 @@ static int get_name(struct ashmem_area *asma, void __user *name)
 
 	mutex_lock(&ashmem_mutex);
 	if (asma->name[ASHMEM_NAME_PREFIX_LEN] != '\0') {
-
 		/*
 		 * Copying only `len', instead of ASHMEM_NAME_LEN, bytes
 		 * prevents us from revealing one user's stack to another.
@@ -798,7 +797,6 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 static long compat_ashmem_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-
 	switch (cmd) {
 	case COMPAT_ASHMEM_SET_SIZE:
 		cmd = ASHMEM_SET_SIZE;
-- 
2.1.3

