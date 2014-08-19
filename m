Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaHSLaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:30:05 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53254 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaHSLaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:30:01 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: benjamin.romer@unisys.com, david.kershner@unisys.com,
        gregkh@linuxfoundation.org, erik.arfvidson@unisys.com,
        sparmaintainer@unisys.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>
Subject: [linux-next PATCH] print u64 with %llu
Date: Tue, 19 Aug 2014 19:29:41 +0800
Message-Id: <1408447783-22287-1-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are printk format issue and coding style issue for the lines
changed by this patch. This patch only fix the format issue. Please
take those coding style errors as false positives for this patch.

[real@name linux-next]$ scripts/checkpatch.pl outgoing2/0001-staging-unisys-virthba-virthba.c-print-u64-with-llu.patch 
WARNING: line over 80 characters
#45: FILE: drivers/staging/unisys/virthba/virthba.c:520:
+    LOGINF("scsihost->max_channel=%u, max_id=%u, max_lun=%llu, cmd_per_lun=%u, max_sectors=%hu, sg_tablesize=%hu\n",

WARNING: line over 80 characters
#63: FILE: drivers/staging/unisys/virthba/virthba.c:1142:
+		LOGERR("SCSICMD ****FAILED scsicmd:0x%p op:0x%x <%d:%d:%d:%llu> 0x%x-0x%x-0x%x-0x%x-0x%x.\n",

WARNING: line over 80 characters
#72: FILE: drivers/staging/unisys/virthba/virthba.c:1151:
+			LOGERR("Throtling SCSICMD errors disk <%d:%d:%d:%llu>\n",

total: 0 errors, 3 warnings, 32 lines checked

outgoing2/0001-staging-unisys-virthba-virthba.c-print-u64-with-llu.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
[real@name linux-next]$ 

Honggang Li (1):
  staging: unisys/virthba/virthba.c print u64 with %llu

 drivers/staging/unisys/virthba/virthba.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.3.1

