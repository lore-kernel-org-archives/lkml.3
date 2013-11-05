Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3KELiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:38:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39703 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3KELiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:38:01 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-4c-5278d89774b1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 08/11] skd: remove SKD_OMIT_FROM_SRC_DIST ifdefs
Date: Tue, 05 Nov 2013 12:37:06 +0100
Message-id: <1383651429-4322-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xoO6MGxVBBtMbWS16e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgynjR9pC1YIVkxaSXV5kaGKcLdzFyckgImEhcXzCRGcIWk7hwbz1bFyMXh5DA
	dEaJT1OmskI4XUwS/w90s4FUsQlYSUxsX8UIYosICEvs72hlASliFljAKDF5xxx2kISwgLNE
	/8Y/LCA2i4CqxKMbu5hAbF4Bd4mrHzdBrZOXeHq/D2wop4CHxJVLb8B6hYBqtn3cyzqBkXcB
	I8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBgeia9g3FVg8UhRgEORiUe3ouhFUFCrIll
	xZW5hxglOJiVRHjbjgCFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2C
	yTJxcEo1MDK1fbzmHPGmMW9xwHvXngyLheHv/2pdsKp4v7z94POeszrN91auF9Rz5lpz85/p
	4jgRffGQB1qSPSrq18KiGJRyxF+v+adhvLA0XezjzbmS+/nyM3ys71RtPzdP9KPHrqzdp1NN
	HB9M2M31iSNabuF+5rpDOudyGoPczJfs5j1WVZdh++3qNiWW4oxEQy3mouJEAB3ZCr0iAgAA
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

