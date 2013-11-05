Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3KELif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:38:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47707 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3KELiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:38:14 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-71-5278d8a46056
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 11/11] skd: fix formatting in skd_s1120.h
Date: Tue, 05 Nov 2013 12:37:09 +0100
Message-id: <1383651429-4322-12-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO7SGxVBBqdOslr09pxkt1h9t5/N
	YuOM9awWZ39dZbE42/SG3eLyrjlsDmwel8+Werzfd5XNo2/LKkaPO+c+MHl83iQXwBrFZZOS
	mpNZllqkb5fAlTHpiEvB/OiKtqmTGBsYp7l1MXJySAiYSLz6dpcJwhaTuHBvPVsXIxeHkMB0
	Ronmp+vZIZwuJonNc58wg1SxCVhJTGxfxQhiiwgIS+zvaGUBKWIWWMAoMXnHHHaQhLCAjUTr
	+3tgDSwCqhL7Fm9nAbF5BTwk9q9rYoRYJy/x9H4fG4jNCRS/cukNWK+QgLvEto97WScw8i5g
	ZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxKz6R2MK5ssDjEKMDBqMTD++BseZAQa2JZ
	cWXuIUYJDmYlEd62IxVBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQW
	wWSZODilGhhNL//1rv2/+ae5WZ7X60bbZZHLplneTpp8bk8/a+P/vngVi8OddjvVraw3XmD3
	392y85nL5iNfSp693XuJ9Wnb9claDZN+Ox05O+/E7bv/NoZP0ZUuZEwIvZcuaBGk+vyldb+H
	mO+lWkUPfkMH9w95cy8ytnwykw1+1yJy7srTeTkarzXS5tQpsRRnJBpqMRcVJwIAaJZ0yiEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_s1120.h | 230 ++++++++++++++++++++++------------------------
 1 file changed, 110 insertions(+), 120 deletions(-)

diff --git a/drivers/block/skd_s1120.h b/drivers/block/skd_s1120.h
index 426581e..61c757f 100644
--- a/drivers/block/skd_s1120.h
+++ b/drivers/block/skd_s1120.h
@@ -17,30 +17,29 @@
 /*
  * Q-channel, 64-bit r/w
  */
-#define FIT_Q_COMMAND               0x400u
-#define  FIT_QCMD_QID_MASK              (0x3 << 1)
-#define  FIT_QCMD_QID0                  (0x0 << 1)
-#define  FIT_QCMD_QID_NORMAL            FIT_QCMD_QID0
-#define  FIT_QCMD_QID1                  (0x1 << 1)
-#define  FIT_QCMD_QID2                  (0x2 << 1)
-#define  FIT_QCMD_QID3                  (0x3 << 1)
-#define  FIT_QCMD_FLUSH_QUEUE           (0ull)      /* add QID */
-#define  FIT_QCMD_MSGSIZE_MASK          (0x3 << 4)
-#define  FIT_QCMD_MSGSIZE_64            (0x0 << 4)
-#define  FIT_QCMD_MSGSIZE_128           (0x1 << 4)
-#define  FIT_QCMD_MSGSIZE_256           (0x2 << 4)
-#define  FIT_QCMD_MSGSIZE_512           (0x3 << 4)
-#define  FIT_QCMD_BASE_ADDRESS_MASK     (0xFFFFFFFFFFFFFFC0ull)
-
+#define FIT_Q_COMMAND			0x400u
+#define FIT_QCMD_QID_MASK		(0x3 << 1)
+#define  FIT_QCMD_QID0			(0x0 << 1)
+#define  FIT_QCMD_QID_NORMAL		FIT_QCMD_QID0
+#define  FIT_QCMD_QID1			(0x1 << 1)
+#define  FIT_QCMD_QID2			(0x2 << 1)
+#define  FIT_QCMD_QID3			(0x3 << 1)
+#define  FIT_QCMD_FLUSH_QUEUE		(0ull)	/* add QID */
+#define  FIT_QCMD_MSGSIZE_MASK		(0x3 << 4)
+#define  FIT_QCMD_MSGSIZE_64		(0x0 << 4)
+#define  FIT_QCMD_MSGSIZE_128		(0x1 << 4)
+#define  FIT_QCMD_MSGSIZE_256		(0x2 << 4)
+#define  FIT_QCMD_MSGSIZE_512		(0x3 << 4)
+#define  FIT_QCMD_BASE_ADDRESS_MASK	(0xFFFFFFFFFFFFFFC0ull)
 
 /*
  * Control, 32-bit r/w
  */
-#define FIT_CONTROL                 0x500u
-#define  FIT_CR_HARD_RESET              (1u << 0u)
-#define  FIT_CR_SOFT_RESET              (1u << 1u)
-#define	 FIT_CR_DIS_TIMESTAMPS		(1u << 6u)
-#define  FIT_CR_ENABLE_INTERRUPTS       (1u << 7u)
+#define FIT_CONTROL			0x500u
+#define  FIT_CR_HARD_RESET		(1u << 0u)
+#define  FIT_CR_SOFT_RESET		(1u << 1u)
+#define  FIT_CR_DIS_TIMESTAMPS		(1u << 6u)
+#define  FIT_CR_ENABLE_INTERRUPTS	(1u << 7u)
 
 /*
  * Status, 32-bit, r/o
@@ -63,88 +62,82 @@
 #define FIT_SR_DRIVE_BUSY_ERASE		0x0B
 #define FIT_SR_DRIVE_FW_BOOTING		0x0C
 #define FIT_SR_DRIVE_NEED_FW_DOWNLOAD	0xFE
-#define FIT_SR_DEVICE_MISSING           0xFF
+#define FIT_SR_DEVICE_MISSING		0xFF
 #define FIT_SR__RESERVED		0xFFFFFF00u
 
 /*
  * FIT_STATUS - Status register data definition
  */
-#define	FIT_SR_STATE_MASK		(0xFF << 0)
-#define	FIT_SR_SIGNATURE		(0xFF << 8)
-#define	FIT_SR_PIO_DMA			(1 << 16)
-
+#define FIT_SR_STATE_MASK		(0xFF << 0)
+#define FIT_SR_SIGNATURE		(0xFF << 8)
+#define FIT_SR_PIO_DMA			(1 << 16)
 
 /*
  * Interrupt status, 32-bit r/w1c (w1c ==> write 1 to clear)
  */
-#define FIT_INT_STATUS_HOST         0x520u
-#define  FIT_ISH_FW_STATE_CHANGE        (1u << 0u)
-#define  FIT_ISH_COMPLETION_POSTED      (1u << 1u)
-#define  FIT_ISH_MSG_FROM_DEV           (1u << 2u)
-#define  FIT_ISH_UNDEFINED_3            (1u << 3u)
-#define  FIT_ISH_UNDEFINED_4            (1u << 4u)
-#define  FIT_ISH_Q0_FULL                (1u << 5u)
-#define  FIT_ISH_Q1_FULL                (1u << 6u)
-#define  FIT_ISH_Q2_FULL                (1u << 7u)
-#define  FIT_ISH_Q3_FULL                (1u << 8u)
-#define  FIT_ISH_QCMD_FIFO_OVERRUN      (1u << 9u)
-#define  FIT_ISH_BAD_EXP_ROM_READ       (1u << 10u)
-
-
-#define FIT_INT_DEF_MASK	\
-		(FIT_ISH_FW_STATE_CHANGE | \
-		 FIT_ISH_COMPLETION_POSTED | \
-		 FIT_ISH_MSG_FROM_DEV | \
-		 FIT_ISH_Q0_FULL | \
-		 FIT_ISH_Q1_FULL | \
-		 FIT_ISH_Q2_FULL | \
-		 FIT_ISH_Q3_FULL | \
-		 FIT_ISH_QCMD_FIFO_OVERRUN | \
-		 FIT_ISH_BAD_EXP_ROM_READ)
-
-#define FIT_INT_QUEUE_FULL	\
-		(FIT_ISH_Q0_FULL | \
-		FIT_ISH_Q1_FULL | \
-		FIT_ISH_Q2_FULL | \
-		FIT_ISH_Q3_FULL)
-
-
-#define MSI_MSG_NWL_ERROR_0             0x00000000
-#define MSI_MSG_NWL_ERROR_1             0x00000001
-#define MSI_MSG_NWL_ERROR_2             0x00000002
-#define MSI_MSG_NWL_ERROR_3             0x00000003
-#define MSI_MSG_STATE_CHANGE            0x00000004
-#define MSI_MSG_COMPLETION_POSTED       0x00000005
-#define MSI_MSG_MSG_FROM_DEV            0x00000006
-#define MSI_MSG_RESERVED_0              0x00000007
-#define MSI_MSG_RESERVED_1              0x00000008
-#define MSI_MSG_QUEUE_0_FULL            0x00000009
-#define MSI_MSG_QUEUE_1_FULL            0x0000000A
-#define MSI_MSG_QUEUE_2_FULL            0x0000000B
-#define MSI_MSG_QUEUE_3_FULL            0x0000000C
-
-
-
-#define FIT_INT_RESERVED_MASK	\
-		(FIT_ISH_UNDEFINED_3 | \
-		FIT_ISH_UNDEFINED_4)
+#define FIT_INT_STATUS_HOST		0x520u
+#define  FIT_ISH_FW_STATE_CHANGE	(1u << 0u)
+#define  FIT_ISH_COMPLETION_POSTED	(1u << 1u)
+#define  FIT_ISH_MSG_FROM_DEV		(1u << 2u)
+#define  FIT_ISH_UNDEFINED_3		(1u << 3u)
+#define  FIT_ISH_UNDEFINED_4		(1u << 4u)
+#define  FIT_ISH_Q0_FULL		(1u << 5u)
+#define  FIT_ISH_Q1_FULL		(1u << 6u)
+#define  FIT_ISH_Q2_FULL		(1u << 7u)
+#define  FIT_ISH_Q3_FULL		(1u << 8u)
+#define  FIT_ISH_QCMD_FIFO_OVERRUN	(1u << 9u)
+#define  FIT_ISH_BAD_EXP_ROM_READ	(1u << 10u)
+
+#define FIT_INT_DEF_MASK \
+	(FIT_ISH_FW_STATE_CHANGE | \
+	 FIT_ISH_COMPLETION_POSTED | \
+	 FIT_ISH_MSG_FROM_DEV | \
+	 FIT_ISH_Q0_FULL | \
+	 FIT_ISH_Q1_FULL | \
+	 FIT_ISH_Q2_FULL | \
+	 FIT_ISH_Q3_FULL | \
+	 FIT_ISH_QCMD_FIFO_OVERRUN | \
+	 FIT_ISH_BAD_EXP_ROM_READ)
+
+#define FIT_INT_QUEUE_FULL \
+	(FIT_ISH_Q0_FULL | \
+	 FIT_ISH_Q1_FULL | \
+	 FIT_ISH_Q2_FULL | \
+	 FIT_ISH_Q3_FULL)
+
+#define MSI_MSG_NWL_ERROR_0		0x00000000
+#define MSI_MSG_NWL_ERROR_1		0x00000001
+#define MSI_MSG_NWL_ERROR_2		0x00000002
+#define MSI_MSG_NWL_ERROR_3		0x00000003
+#define MSI_MSG_STATE_CHANGE		0x00000004
+#define MSI_MSG_COMPLETION_POSTED	0x00000005
+#define MSI_MSG_MSG_FROM_DEV		0x00000006
+#define MSI_MSG_RESERVED_0		0x00000007
+#define MSI_MSG_RESERVED_1		0x00000008
+#define MSI_MSG_QUEUE_0_FULL		0x00000009
+#define MSI_MSG_QUEUE_1_FULL		0x0000000A
+#define MSI_MSG_QUEUE_2_FULL		0x0000000B
+#define MSI_MSG_QUEUE_3_FULL		0x0000000C
+
+#define FIT_INT_RESERVED_MASK \
+	(FIT_ISH_UNDEFINED_3 | \
+	 FIT_ISH_UNDEFINED_4)
+
 /*
  * Interrupt mask, 32-bit r/w
  * Bit definitions are the same as FIT_INT_STATUS_HOST
  */
-#define FIT_INT_MASK_HOST           0x528u
-
+#define FIT_INT_MASK_HOST		0x528u
 
 /*
  * Message to device, 32-bit r/w
  */
-#define FIT_MSG_TO_DEVICE           0x540u
+#define FIT_MSG_TO_DEVICE		0x540u
 
 /*
  * Message from device, 32-bit, r/o
  */
-#define FIT_MSG_FROM_DEVICE         0x548u
-
+#define FIT_MSG_FROM_DEVICE		0x548u
 
 /*
  * 32-bit messages to/from device, composition/extraction macros
@@ -153,52 +146,50 @@
 	((((TYPE)  & 0xFFu) << 24u) | \
 	(((PARAM) & 0xFFu) << 16u) | \
 	(((DATA)  & 0xFFFFu) << 0u))
-#define FIT_MXD_TYPE(MXD)               (((MXD) >> 24u) & 0xFFu)
-#define FIT_MXD_PARAM(MXD)              (((MXD) >> 16u) & 0xFFu)
-#define FIT_MXD_DATA(MXD)               (((MXD) >> 0u) & 0xFFFFu)
-
+#define FIT_MXD_TYPE(MXD)		(((MXD) >> 24u) & 0xFFu)
+#define FIT_MXD_PARAM(MXD)		(((MXD) >> 16u) & 0xFFu)
+#define FIT_MXD_DATA(MXD)		(((MXD) >> 0u) & 0xFFFFu)
 
 /*
  * Types of messages to/from device
  */
-#define FIT_MTD_FITFW_INIT              0x01u
-#define FIT_MTD_GET_CMDQ_DEPTH          0x02u
-#define FIT_MTD_SET_COMPQ_DEPTH         0x03u
-#define FIT_MTD_SET_COMPQ_ADDR          0x04u
-#define FIT_MTD_ARM_QUEUE               0x05u
-#define FIT_MTD_CMD_LOG_HOST_ID         0x07u
-#define FIT_MTD_CMD_LOG_TIME_STAMP_LO   0x08u
-#define FIT_MTD_CMD_LOG_TIME_STAMP_HI   0x09u
-#define FIT_MFD_SMART_EXCEEDED          0x10u
-#define FIT_MFD_POWER_DOWN		        0x11u
-#define FIT_MFD_OFFLINE			        0x12u
-#define FIT_MFD_ONLINE			        0x13u
-#define FIT_MFD_FW_RESTARTING		    0x14u
-#define FIT_MFD_PM_ACTIVE		        0x15u
-#define FIT_MFD_PM_STANDBY		        0x16u
-#define FIT_MFD_PM_SLEEP		        0x17u
-#define FIT_MFD_CMD_PROGRESS		    0x18u
-
-#define FIT_MTD_DEBUG                   0xFEu
-#define FIT_MFD_DEBUG                   0xFFu
+#define FIT_MTD_FITFW_INIT		0x01u
+#define FIT_MTD_GET_CMDQ_DEPTH		0x02u
+#define FIT_MTD_SET_COMPQ_DEPTH		0x03u
+#define FIT_MTD_SET_COMPQ_ADDR		0x04u
+#define FIT_MTD_ARM_QUEUE		0x05u
+#define FIT_MTD_CMD_LOG_HOST_ID		0x07u
+#define FIT_MTD_CMD_LOG_TIME_STAMP_LO	0x08u
+#define FIT_MTD_CMD_LOG_TIME_STAMP_HI	0x09u
+#define FIT_MFD_SMART_EXCEEDED		0x10u
+#define FIT_MFD_POWER_DOWN		0x11u
+#define FIT_MFD_OFFLINE			0x12u
+#define FIT_MFD_ONLINE			0x13u
+#define FIT_MFD_FW_RESTARTING		0x14u
+#define FIT_MFD_PM_ACTIVE		0x15u
+#define FIT_MFD_PM_STANDBY		0x16u
+#define FIT_MFD_PM_SLEEP		0x17u
+#define FIT_MFD_CMD_PROGRESS		0x18u
+
+#define FIT_MTD_DEBUG			0xFEu
+#define FIT_MFD_DEBUG			0xFFu
 
 #define FIT_MFD_MASK			(0xFFu)
 #define FIT_MFD_DATA_MASK		(0xFFu)
 #define FIT_MFD_MSG(x)			(((x) >> 24) & FIT_MFD_MASK)
 #define FIT_MFD_DATA(x)			((x) & FIT_MFD_MASK)
 
-
 /*
  * Extra arg to FIT_MSG_TO_DEVICE, 64-bit r/w
  * Used to set completion queue address (FIT_MTD_SET_COMPQ_ADDR)
  * (was Response buffer in docs)
  */
-#define FIT_MSG_TO_DEVICE_ARG       0x580u
+#define FIT_MSG_TO_DEVICE_ARG		0x580u
 
 /*
  * Hardware (ASIC) version, 32-bit r/o
  */
-#define FIT_HW_VERSION              0x588u
+#define FIT_HW_VERSION			0x588u
 
 /*
  * Scatter/gather list descriptor.
@@ -213,8 +204,8 @@ struct fit_sg_descriptor {
 	uint64_t next_desc_ptr;
 };
 
-#define FIT_SGD_CONTROL_NOT_LAST    0x000u
-#define FIT_SGD_CONTROL_LAST        0x40Eu
+#define FIT_SGD_CONTROL_NOT_LAST	0x000u
+#define FIT_SGD_CONTROL_LAST		0x40Eu
 
 /*
  * Header at the beginning of a FIT message. The header
@@ -228,9 +219,9 @@ struct fit_msg_hdr {
 	uint8_t _reserved[62];
 };
 
-#define FIT_PROTOCOL_ID_FIT     1
-#define FIT_PROTOCOL_ID_SSDI    2
-#define FIT_PROTOCOL_ID_SOFIT   3
+#define FIT_PROTOCOL_ID_FIT	1
+#define FIT_PROTOCOL_ID_SSDI	2
+#define FIT_PROTOCOL_ID_SOFIT	3
 
 
 #define FIT_PROTOCOL_MINOR_VER(mtd_val) ((mtd_val >> 16) & 0xF)
@@ -251,7 +242,7 @@ struct fit_msg_hdr {
  * Command_context is opaque and taken verbatim from the SSDI command.
  * All other fields are big endian.
  */
-#define FIT_PROTOCOL_VERSION_0          0
+#define FIT_PROTOCOL_VERSION_0		0
 
 /*
  *  Protocol major version 1 completion entry.
@@ -264,8 +255,8 @@ struct fit_completion_entry_v1 {
 	uint8_t		status;  /* SCSI status */
 	uint8_t		cycle;
 };
-#define FIT_PROTOCOL_VERSION_1          1
-#define FIT_PROTOCOL_VERSION_CURRENT    FIT_PROTOCOL_VERSION_1
+#define FIT_PROTOCOL_VERSION_1		1
+#define FIT_PROTOCOL_VERSION_CURRENT	FIT_PROTOCOL_VERSION_1
 
 struct fit_comp_error_info {
 	uint8_t		type:7; /* 00: Bits0-6 indicates the type of sense data. */
@@ -293,10 +284,9 @@ struct fit_comp_error_info {
 
 
 /* Task management constants */
-#define SOFT_TASK_SIMPLE            0x00
-#define SOFT_TASK_HEAD_OF_QUEUE     0x01
-#define SOFT_TASK_ORDERED           0x02
-
+#define SOFT_TASK_SIMPLE		0x00
+#define SOFT_TASK_HEAD_OF_QUEUE		0x01
+#define SOFT_TASK_ORDERED		0x02
 
 /* Version zero has the last 32 bits reserved,
  * Version one has the last 32 bits sg_list_len_bytes;
-- 
1.8.2.3

