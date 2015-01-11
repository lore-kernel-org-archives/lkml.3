Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbbAKVtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:49:33 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:57510 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbbAKVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:49:29 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] Staging: nvec: Fixed a typo
Date: Sun, 11 Jan 2015 15:49:13 -0600
Message-Id: <1421012953-32257-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo in nvec.c file

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/nvec/nvec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 093535c..2637059 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -259,7 +259,7 @@ static void nvec_gpio_set_value(struct nvec_chip *nvec, int value)
  * and return immediately.
  *
  * Returns: 0 on success, a negative error code on failure. If a failure
- * occured, the nvec driver may print an error.
+ * occurred, the nvec driver may print an error.
  */
 int nvec_write_async(struct nvec_chip *nvec, const unsigned char *data,
 			short size)
-- 
1.9.1

