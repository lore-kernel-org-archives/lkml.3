Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3LNDPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:15:09 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35739 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3LNDPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:15:07 -0500
From: "Preetam D'Souza" <preetamjdsouza@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Preetam D'Souza" <preetamjdsouza@gmail.com>
Subject: [PATCH] Staging: rts5139: fix parantheses coding style issue in ms.c
Date: Fri, 13 Dec 2013 19:13:47 -0800
Message-Id: <1386990827-23933-1-git-send-email-preetamjdsouza@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an unnecessary return statement parantheses error
found in ms.c by the checkpatch.pl tool.

Signed-off-by: Preetam D'Souza <preetamjdsouza@gmail.com>
---
 drivers/staging/rts5139/ms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5139/ms.c b/drivers/staging/rts5139/ms.c
index a27f7e2..9253f6a 100644
--- a/drivers/staging/rts5139/ms.c
+++ b/drivers/staging/rts5139/ms.c
@@ -48,7 +48,7 @@ static inline int ms_check_err_code(struct rts51x_chip *chip, u8 err_code)
 {
 	struct ms_info *ms_card = &(chip->ms_card);
 
-	return (ms_card->err_code == err_code);
+	return ms_card->err_code == err_code;
 }
 
 static int ms_parse_err_code(struct rts51x_chip *chip)
-- 
1.7.10.4

