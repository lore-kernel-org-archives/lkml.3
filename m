Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbaFSHYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:24:43 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:37854 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaFSHYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:24:15 -0400
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, bergwolf@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Subject: [PATCHv2 2/3] staging: lustre: obdclass: linux-sysctl.c: fix checkpatch warnings about included headers
Date: Thu, 19 Jun 2014 11:24:12 +0400
Message-Id: <1403162653-17845-4-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403162653-17845-3-git-send-email-Andrej.Skvortzov@gmail.com>
References: <20140618223533.GA5096@kroah.com>
 <1403162653-17845-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <1403162653-17845-2-git-send-email-Andrej.Skvortzov@gmail.com>
 <1403162653-17845-3-git-send-email-Andrej.Skvortzov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Skvortsov <skvortsov.av@summatechnology.ru>


Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index b87ca10..4dcdfc2 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -42,8 +42,8 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
-#include <asm/bitops.h>
-#include <asm/uaccess.h>
+#include <linux/bitops.h>
+#include <linux/uaccess.h>
 #include <linux/utsname.h>
 
 #define DEBUG_SUBSYSTEM S_CLASS
-- 
1.7.10.4

