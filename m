Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaEDR16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:27:58 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64065 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaEDR15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 13:27:57 -0400
From: Maarten de Jonge <mdejonge1990@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Maarten de Jonge <mdejonge1990@gmail.com>
Subject: [PATCH] staging: et131x: add blank lines after declarations
Date: Sun,  4 May 2014 19:26:51 +0200
Message-Id: <1399224411-4201-1-git-send-email-mdejonge1990@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten de Jonge <mdejonge1990@gmail.com>
---
 drivers/staging/et131x/et131x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index d329cf3..747fd9a 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -762,6 +762,7 @@ static int et131x_init_eeprom(struct et131x_adapter *adapter)
 	 */
 	if (eestatus & 0x4C) {
 		int write_failed = 0;
+
 		if (pdev->revision == 0x01) {
 			int	i;
 			static const u8 eedata[4] = { 0xFE, 0x13, 0x10, 0xFF };
@@ -2091,6 +2092,7 @@ static void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
 {
 	u32 tmp_free_buff_ring = *free_buff_ring;
+
 	tmp_free_buff_ring++;
 	/* This works for all cases where limit < 1024. The 1023 case
 	 * works because 1023++ is 1024 which means the if condition is not
-- 
1.9.2

