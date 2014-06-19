Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbaFSHYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:24:25 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:64591 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbaFSHYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:24:16 -0400
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, bergwolf@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Subject: [PATCHv2 3/3] staging: lustre: obdclass: linux-sysctl.c: fix unnecessary spaces coding style issue
Date: Thu, 19 Jun 2014 11:24:13 +0400
Message-Id: <1403162653-17845-5-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403162653-17845-4-git-send-email-Andrej.Skvortzov@gmail.com>
References: <20140618223533.GA5096@kroah.com>
 <1403162653-17845-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <1403162653-17845-2-git-send-email-Andrej.Skvortzov@gmail.com>
 <1403162653-17845-3-git-send-email-Andrej.Skvortzov@gmail.com>
 <1403162653-17845-4-git-send-email-Andrej.Skvortzov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Skvortsov <skvortsov.av@summatechnology.ru>


Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index 4dcdfc2..140b570 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -408,18 +408,18 @@ static ctl_table_t parent_table[] = {
 };
 #endif
 
-void obd_sysctl_init (void)
+void obd_sysctl_init(void)
 {
 #ifdef CONFIG_SYSCTL
-	if ( !obd_table_header )
+	if (!obd_table_header)
 		obd_table_header = register_sysctl_table(parent_table);
 #endif
 }
 
-void obd_sysctl_clean (void)
+void obd_sysctl_clean(void)
 {
 #ifdef CONFIG_SYSCTL
-	if ( obd_table_header )
+	if (obd_table_header)
 		unregister_sysctl_table(obd_table_header);
 	obd_table_header = NULL;
 #endif
-- 
1.7.10.4

