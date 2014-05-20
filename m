Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaETHlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:41:50 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40196 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaETHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:41:48 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Poggi?= <poggi.raph@gmail.com>
To: nicolas.ferre@atmel.com
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rapha=C3=ABl=20Poggi?= <poggi.raph@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20spi=3A=20atmel=3A=20fix=20typo=20in=20dev=5Ferr?=
Date: Tue, 20 May 2014 09:41:51 +0200
Message-Id: <1400571711-13137-1-git-send-email-poggi.raph@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in dev_err.

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/spi/spi-atmel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 079e6b1..7a1788b 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1122,7 +1122,7 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 		atmel_spi_lock(as);
 		if (WARN_ON(ret == 0)) {
 			dev_err(&spi->dev,
-				"spi trasfer timeout, err %d\n", ret);
+				"spi transfer timeout, err %d\n", ret);
 			as->done_status = -EIO;
 		} else {
 			ret = 0;
-- 
1.7.9.5

