Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3J2Dv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:51:57 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:49685 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab3J2Dvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:51:55 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 01/11 V2] Staging: bcm: Fix WARNING: space prohibited before semicolon.
Date: Mon, 28 Oct 2013 23:51:38 -0400
Message-Id: <1383018708-29615-2-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
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
index d6c9630..11fd7f1 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -267,7 +267,7 @@ struct bcm_mini_adapter {
 	bool			fw_download_done;
 
 	char			*txctlpacket[MAX_CNTRL_PKTS];
-	atomic_t		cntrlpktCnt ;
+	atomic_t		cntrlpktCnt;
 	atomic_t		index_app_read_cntrlpkt;
 	atomic_t		index_wr_txcntrlpkt;
 	atomic_t		index_rd_txcntrlpkt;
-- 
1.7.9.5

