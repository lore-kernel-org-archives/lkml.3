Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab3CTMKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:10:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64098 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623Ab3CTMKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:10:40 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: santosh.shilimkar@ti.com, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 04/10] gpio: gpio-pca953x.c: fix checkpatch error
Date: Wed, 20 Mar 2013 13:15:58 +0100
Message-Id: <1363781764-17330-5-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
References: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix :
 gpio/gpio-pca953x.c:150: ERROR: else should follow close brace '}'

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpio/gpio-pca953x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 2405946..15dbc36 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -146,8 +146,7 @@ static int pca953x_write_regs(struct pca953x_chip *chip, int reg, u8 *val)
 		ret = i2c_smbus_write_i2c_block_data(chip->client,
 					(reg << bank_shift) | REG_ADDR_AI,
 					NBANK(chip), val);
-	}
-	else {
+	} else {
 		switch (chip->chip_type) {
 		case PCA953X_TYPE:
 			ret = i2c_smbus_write_word_data(chip->client,
-- 
1.7.10.4

