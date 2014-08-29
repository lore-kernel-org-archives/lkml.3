Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaH2IIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:08:30 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54583 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaH2IIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:08:22 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] drivers: media: radio: radio-miropcm20.c: include missing header file
Date: Fri, 29 Aug 2014 13:38:01 +0530
Message-Id: <1409299681-28409-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with -Werror=implicit-function-declaration build failed with error :
error: implicit declaration of function 'inb'
error: implicit declaration of function 'outb'

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindi.org>
---

Jim reported for next-20140828 , but the error still persists in next-20140829 also.


 drivers/media/radio/radio-miropcm20.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 998919e..3309f7c 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <sound/aci.h>
+#include<linux/io.h>
 
 #define RDS_DATASHIFT          2   /* Bit 2 */
 #define RDS_DATAMASK        (1 << RDS_DATASHIFT)
-- 
1.8.1.2

