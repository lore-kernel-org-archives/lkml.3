Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaBTOn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:43:27 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:47221 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaBTOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 02/10] spi: sh-msiof: Typo in comment s/tx/rx/
Date: Thu, 20 Feb 2014 15:43:01 +0100
Message-Id: <1392907389-21798-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-sh-msiof.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index e6f79b2f2616..cc12e755131d 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -486,7 +486,7 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	/* clear status bits */
 	sh_msiof_reset_str(p);
 
-	/* shut down frame, tx/tx and clock signals */
+	/* shut down frame, rx/tx and clock signals */
 	ret = sh_msiof_modify_ctr_wait(p, CTR_TFSE, 0);
 	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_TXE, 0);
 	if (rx_buf)
-- 
1.7.9.5

