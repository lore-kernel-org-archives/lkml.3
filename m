Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaCPTSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:18:25 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61336 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaCPTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:18:24 -0400
Date: Mon, 17 Mar 2014 08:18:17 +1300
From: Daniel Ngu <daniel.dy.ngu@gmail.com>
To: Jonathan Kim <jonathankim@gctsemi.com>
Cc: Dean ahn <deanahn@gctsemi.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_lte.h: fixed coding style
Message-ID: <20140316191817.GD3478@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing space after return type

Signed-off-by: Daniel Ngu <daniel.dy.ngu@gmail.com>
---
 drivers/staging/gdm724x/gdm_lte.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.h b/drivers/staging/gdm724x/gdm_lte.h
index 9287d31..88414e5 100644
--- a/drivers/staging/gdm724x/gdm_lte.h
+++ b/drivers/staging/gdm724x/gdm_lte.h
@@ -56,7 +56,7 @@ struct phy_dev {
 			int (*cb)(void *cb_data, void *data, int len,
 				  int context),
 			void *cb_data, int context);
-	struct gdm_endian *(*get_endian)(void *priv_dev);
+	struct gdm_endian * (*get_endian)(void *priv_dev);
 };
 
 struct nic {
-- 
1.7.9.5

