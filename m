Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3I3N1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:27:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55706 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3I3N1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:27:01 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-e1-52497c244fe1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 09/14] skd: remove SKD_OMIT_FROM_SRC_DIST ifdefs
Date: Mon, 30 Sep 2013 15:25:50 +0200
Message-id: <1380547556-17719-10-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgK5KjWeQwfVJNha9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZbxoe8hasEKyYtLLq0wNjNOFuxg5OSQETCSuvrvLCmGLSVy4t56ti5GLQ0hg
	EaNE793tzBBOF5PEii0nmEGq2ASsJCa2r2IEsUUEhCX2d7SygBQxCzQxSmxcMgeonYNDWMBB
	Ys4ePZAaFgFViZXfXrGA2LwCnhKL769nhNgmL/H0fh8biM0JFP9/+yhYXEjAQ+LboctMExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDqVnUjsYVzZYHGIU4GBU4uGdsNwjSIg1
	say4MvcQowQHs5IIr3iZZ5AQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakF
	qUUwWSYOTqkGxqzcjqgwTxa1qquaM+ysLjRGup9TkGT9sSqfNfh5W+K9V5rb7if7X7XNPCin
	aFMUJsxXr8XW8XOGtIRp2btl/3qUq88ftmE4Xb5j88POmVZcKpImtSucpovPmG3x0qBi51JW
	5vjS1dJbThRrB75UWnZEOM1O6vn2Lxp+1kyFehrhfQ7mos+VWIozEg21mIuKEwFxRu6EIQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SKD_OMIT_FROM_SRC_DIST is never defined.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_s1120.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/block/skd_s1120.h b/drivers/block/skd_s1120.h
index bf01941..426581e 100644
--- a/drivers/block/skd_s1120.h
+++ b/drivers/block/skd_s1120.h
@@ -21,11 +21,9 @@
 #define  FIT_QCMD_QID_MASK              (0x3 << 1)
 #define  FIT_QCMD_QID0                  (0x0 << 1)
 #define  FIT_QCMD_QID_NORMAL            FIT_QCMD_QID0
-#ifndef SKD_OMIT_FROM_SRC_DIST
 #define  FIT_QCMD_QID1                  (0x1 << 1)
 #define  FIT_QCMD_QID2                  (0x2 << 1)
 #define  FIT_QCMD_QID3                  (0x3 << 1)
-#endif /* SKD_OMIT_FROM_SRC_DIST */
 #define  FIT_QCMD_FLUSH_QUEUE           (0ull)      /* add QID */
 #define  FIT_QCMD_MSGSIZE_MASK          (0x3 << 4)
 #define  FIT_QCMD_MSGSIZE_64            (0x0 << 4)
@@ -39,13 +37,9 @@
  * Control, 32-bit r/w
  */
 #define FIT_CONTROL                 0x500u
-#ifndef SKD_OMIT_FROM_SRC_DIST
 #define  FIT_CR_HARD_RESET              (1u << 0u)
-#endif /* SKD_OMIT_FROM_SRC_DIST */
 #define  FIT_CR_SOFT_RESET              (1u << 1u)
-#ifndef SKD_OMIT_FROM_SRC_DIST
 #define	 FIT_CR_DIS_TIMESTAMPS		(1u << 6u)
-#endif /* SKD_OMIT_FROM_SRC_DIST */
 #define  FIT_CR_ENABLE_INTERRUPTS       (1u << 7u)
 
 /*
@@ -53,10 +47,8 @@
  */
 #define FIT_STATUS			0x510u
 #define FIT_SR_DRIVE_STATE_MASK		0x000000FFu
-#ifndef SKD_OMIT_FROM_SRC_DIST
 #define	FIT_SR_SIGNATURE		(0xFF << 8)
 #define	FIT_SR_PIO_DMA			(1 << 16)
-#endif /* SKD_OMIT_FROM_SRC_DIST */
 #define FIT_SR_DRIVE_OFFLINE		0x00
 #define FIT_SR_DRIVE_INIT		0x01
 /* #define FIT_SR_DRIVE_READY		0x02 */
@@ -74,14 +66,12 @@
 #define FIT_SR_DEVICE_MISSING           0xFF
 #define FIT_SR__RESERVED		0xFFFFFF00u
 
-#ifndef SKD_OMIT_FROM_SRC_DIST
 /*
  * FIT_STATUS - Status register data definition
  */
 #define	FIT_SR_STATE_MASK		(0xFF << 0)
 #define	FIT_SR_SIGNATURE		(0xFF << 8)
 #define	FIT_SR_PIO_DMA			(1 << 16)
-#endif /* SKD_OMIT_FROM_SRC_DIST */
 
 
 /*
@@ -189,10 +179,8 @@
 #define FIT_MFD_PM_SLEEP		        0x17u
 #define FIT_MFD_CMD_PROGRESS		    0x18u
 
-#ifndef SKD_OMIT_FROM_SRC_DIST
 #define FIT_MTD_DEBUG                   0xFEu
 #define FIT_MFD_DEBUG                   0xFFu
-#endif /* SKD_OMIT_FROM_SRC_DIST */
 
 #define FIT_MFD_MASK			(0xFFu)
 #define FIT_MFD_DATA_MASK		(0xFFu)
@@ -248,7 +236,6 @@ struct fit_msg_hdr {
 #define FIT_PROTOCOL_MINOR_VER(mtd_val) ((mtd_val >> 16) & 0xF)
 #define FIT_PROTOCOL_MAJOR_VER(mtd_val) ((mtd_val >> 20) & 0xF)
 
-#ifndef SKD_OMIT_FROM_SRC_DIST
 /*
  * Format of a completion entry. The completion queue is circular
  * and must have at least as many entries as the maximum number
@@ -264,7 +251,6 @@ struct fit_msg_hdr {
  * Command_context is opaque and taken verbatim from the SSDI command.
  * All other fields are big endian.
  */
-#endif /* SKD_OMIT_FROM_SRC_DIST */
 #define FIT_PROTOCOL_VERSION_0          0
 
 /*
-- 
1.8.2.3

