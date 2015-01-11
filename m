Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbbAKVpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:45:00 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36909 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbAKVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:44:56 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] Staging: octeon: Fixed a typo
Date: Sun, 11 Jan 2015 15:44:39 -0600
Message-Id: <1421012679-32138-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo in ethernet.c file.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/octeon/ethernet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index ee32149..460e854 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -798,7 +798,7 @@ static int cvm_oct_probe(struct platform_device *pdev)
 	cvm_oct_rx_initialize();
 
 	/*
-	 * 150 uS: about 10 1500-byte packtes at 1GE.
+	 * 150 uS: about 10 1500-byte packets at 1GE.
 	 */
 	cvm_oct_tx_poll_interval = 150 * (octeon_get_clock_rate() / 1000000);
 
-- 
1.9.1

