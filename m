Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaHHPTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:19:24 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:55733 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaHHPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:19:22 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH trivial 1/4] [media] cx25840: Spelling s/compuations/computations/
Date: Fri,  8 Aug 2014 17:19:12 +0200
Message-Id: <1407511155-5264-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/i2c/cx25840/cx25840-ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index e6588ee5bdb0..4cf8f18bf097 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -224,7 +224,7 @@ static inline unsigned int lpf_count_to_us(unsigned int count)
 }
 
 /*
- * FIFO register pulse width count compuations
+ * FIFO register pulse width count computations
  */
 static u32 clock_divider_to_resolution(u16 divider)
 {
-- 
1.9.1

