Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbbAKWAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:00:42 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:53377 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbAKWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:00:40 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: jfrederich@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] Staging: olpc_dcon: Fixed a typo
Date: Sun, 11 Jan 2015 16:00:33 -0600
Message-Id: <1421013633-865-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo in olpc_dcon_xo_1.c file.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
index 77e8eb5..0c5a10c 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -52,7 +52,7 @@ static int dcon_init_xo_1(struct dcon_priv *dcon)
 	 * Determine the current state by reading the GPIO bit; earlier
 	 * stages of the boot process have established the state.
 	 *
-	 * Note that we read GPIO_OUPUT_VAL rather than GPIO_READ_BACK here;
+	 * Note that we read GPIO_OUTPUT_VAL rather than GPIO_READ_BACK here;
 	 * this is because OFW will disable input for the pin and set a value..
 	 * READ_BACK will only contain a valid value if input is enabled and
 	 * then a value is set.  So, future readings of the pin can use
-- 
1.9.1

