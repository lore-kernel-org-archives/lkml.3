Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaHDWa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:30:27 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47891 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaHDWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:30:26 -0400
From: Adrian Remonda <adrianremonda@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adrian Remonda <adrianremonda@gmail.com>
Subject: [PATCH] Staging: rtl8188eu: Missing a blank line after declarations.
Date: Tue,  5 Aug 2014 00:30:17 +0200
Message-Id: <1407191417-23269-1-git-send-email-adrianremonda@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rtl8188e_xmit.c file that fixes up a missing
blank line warning found by the checkpatch.pl tool.

Signed-off-by: Adrian Remonda <adrianremonda@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c
index 7ecbcf7..7a4f754 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c
@@ -64,6 +64,7 @@ void _dbg_dump_tx_info(struct adapter *padapter, int frame_tag,
 {
 	u8 dmp_txpkt;
 	bool dump_txdesc = false;
+
 	rtw_hal_get_def_var(padapter, HAL_DEF_DBG_DUMP_TXPKT, &(dmp_txpkt));
 
 	if (dmp_txpkt == 1) {/* dump txdesc for data frame */
-- 
2.0.4

