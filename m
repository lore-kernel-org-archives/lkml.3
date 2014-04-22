Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaDVJYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:24:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:5270 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaDVJYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:24:33 -0400
From: Bintian Wang <bintian.wang@huawei.com>
To: <gregkh@linuxfoundation.org>, <ccross@android.com>,
        <john.stultz@linaro.org>, <rdunlap@xenotime.net>,
        <keescook@chromium.org>, <anton.vorontsov@linaro.org>,
        <lizefan@huawei.com>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/android: Remove ram_console.h
Date: Tue, 22 Apr 2014 17:22:58 +0800
Message-ID: <1398158578-122556-1-git-send-email-bintian.wang@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.111.68.244]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ram_console is replaced by pstore and pstore_ram drivers,
and there is no code to use this head file, so remove it.

Signed-off-by: Bintian Wang <bintian.wang@huawei.com>
---
 drivers/staging/android/ram_console.h |   22 ----------------------
 1 file changed, 22 deletions(-)
 delete mode 100644 drivers/staging/android/ram_console.h

diff --git a/drivers/staging/android/ram_console.h b/drivers/staging/android/ram_console.h
deleted file mode 100644
index 9f1125c..0000000
--- a/drivers/staging/android/ram_console.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (C) 2010 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef _INCLUDE_LINUX_PLATFORM_DATA_RAM_CONSOLE_H_
-#define _INCLUDE_LINUX_PLATFORM_DATA_RAM_CONSOLE_H_
-
-struct ram_console_platform_data {
-	const char *bootinfo;
-};
-
-#endif /* _INCLUDE_LINUX_PLATFORM_DATA_RAM_CONSOLE_H_ */
-- 
1.7.9.5


