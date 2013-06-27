Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3F0Myk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:54:40 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:36964 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753652Ab3F0Muw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:52 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 41/51] Input: atmel_mxt_ts - Remove unused defines
Date: Thu, 27 Jun 2013 13:49:16 +0100
Message-Id: <1372337366-9286-42-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of these values are out of date and they aren't used in the driver - all
they do is increase the size of the kernel source.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   66 +-----------------------------
 1 file changed, 1 insertion(+), 65 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 2eaa9d3..c01a457 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -25,27 +25,13 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 
-/* Version */
-#define MXT_VER_20		20
-#define MXT_VER_21		21
-#define MXT_VER_22		22
-
 /* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
 #define MXT_CFG_NAME		"maxtouch.cfg"
 #define MXT_CFG_MAGIC		"OBP_RAW V1"
 
 /* Registers */
-#define MXT_INFO		0x00
-#define MXT_FAMILY_ID		0x00
-#define MXT_VARIANT_ID		0x01
-#define MXT_VERSION		0x02
-#define MXT_BUILD		0x03
-#define MXT_MATRIX_X_SIZE	0x04
-#define MXT_MATRIX_Y_SIZE	0x05
-#define MXT_OBJECT_NUM		0x06
 #define MXT_OBJECT_START	0x07
-
 #define MXT_OBJECT_SIZE		6
 #define MXT_INFO_CHECKSUM_SIZE	3
 #define MXT_MAX_BLOCK_WRITE	256
@@ -107,15 +93,6 @@ struct t7_config {
 #define MXT_POWER_CFG_RUN		0
 #define MXT_POWER_CFG_DEEPSLEEP		1
 
-/* MXT_GEN_ACQUIRE_T8 field */
-#define MXT_ACQUIRE_CHRGTIME	0
-#define MXT_ACQUIRE_TCHDRIFT	2
-#define MXT_ACQUIRE_DRIFTST	3
-#define MXT_ACQUIRE_TCHAUTOCAL	4
-#define MXT_ACQUIRE_SYNC	5
-#define MXT_ACQUIRE_ATCHCALST	6
-#define MXT_ACQUIRE_ATCHCALSTHR	7
-
 /* MXT_TOUCH_MULTI_T9 field */
 #define MXT_T9_ORIENT		9
 #define MXT_T9_RANGE		18
@@ -138,51 +115,10 @@ struct t9_range {
 /* MXT_TOUCH_MULTI_T9 orient */
 #define MXT_T9_ORIENT_SWITCH	(1 << 0)
 
-/* MXT_PROCI_GRIPFACE_T20 field */
-#define MXT_GRIPFACE_CTRL	0
-#define MXT_GRIPFACE_XLOGRIP	1
-#define MXT_GRIPFACE_XHIGRIP	2
-#define MXT_GRIPFACE_YLOGRIP	3
-#define MXT_GRIPFACE_YHIGRIP	4
-#define MXT_GRIPFACE_MAXTCHS	5
-#define MXT_GRIPFACE_SZTHR1	7
-#define MXT_GRIPFACE_SZTHR2	8
-#define MXT_GRIPFACE_SHPTHR1	9
-#define MXT_GRIPFACE_SHPTHR2	10
-#define MXT_GRIPFACE_SUPEXTTO	11
-
-/* MXT_PROCI_NOISE field */
-#define MXT_NOISE_CTRL		0
-#define MXT_NOISE_OUTFLEN	1
-#define MXT_NOISE_GCAFUL_LSB	3
-#define MXT_NOISE_GCAFUL_MSB	4
-#define MXT_NOISE_GCAFLL_LSB	5
-#define MXT_NOISE_GCAFLL_MSB	6
-#define MXT_NOISE_ACTVGCAFVALID	7
-#define MXT_NOISE_NOISETHR	8
-#define MXT_NOISE_FREQHOPSCALE	10
-#define MXT_NOISE_FREQ0		11
-#define MXT_NOISE_FREQ1		12
-#define MXT_NOISE_FREQ2		13
-#define MXT_NOISE_FREQ3		14
-#define MXT_NOISE_FREQ4		15
-#define MXT_NOISE_IDLEGCAFVALID	16
-
 /* MXT_SPT_COMMSCONFIG_T18 */
 #define MXT_COMMS_CTRL		0
 #define MXT_COMMS_CMD		1
 
-/* MXT_SPT_CTECONFIG_T28 field */
-#define MXT_CTE_CTRL		0
-#define MXT_CTE_CMD		1
-#define MXT_CTE_MODE		2
-#define MXT_CTE_IDLEGCAFDEPTH	3
-#define MXT_CTE_ACTVGCAFDEPTH	4
-#define MXT_CTE_VOLTAGE		5
-
-#define MXT_VOLTAGE_DEFAULT	2700000
-#define MXT_VOLTAGE_STEP	10000
-
 /* Define for MXT_GEN_COMMAND_T6 */
 #define MXT_BOOT_VALUE		0xa5
 #define MXT_RESET_VALUE		0x01
@@ -1577,7 +1513,7 @@ static int mxt_get_info(struct mxt_data *data)
 	int error;
 
 	/* Read 7-byte info block starting at address 0 */
-	error = __mxt_read_reg(client, MXT_INFO, sizeof(*info), info);
+	error = __mxt_read_reg(client, 0, sizeof(*info), info);
 	if (error)
 		return error;
 
-- 
1.7.10.4

