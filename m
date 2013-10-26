Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3JZGP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:15:28 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55967 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3JZGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:26 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 01/11] Staging: bcm: Fix WARNING: space prohibited before semicolon.
Date: Sat, 26 Oct 2013 02:15:10 -0400
Message-Id: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a space before semicolon as
specified by checkpatch.pl.

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 1d8bf08..c2c0e6c 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -267,7 +267,7 @@ struct bcm_mini_adapter {
 	BOOLEAN			fw_download_done;
 
 	char			*txctlpacket[MAX_CNTRL_PKTS];
-	atomic_t		cntrlpktCnt ;
+	atomic_t		cntrlpktCnt;
 	atomic_t		index_app_read_cntrlpkt;
 	atomic_t		index_wr_txcntrlpkt;
 	atomic_t		index_rd_txcntrlpkt;
-- 
1.7.9.5

