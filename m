Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaHHPT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:19:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35381 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbaHHPTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:19:24 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH trivial 2/4] [media] cx23885: Spelling s/compuations/computations/
Date: Fri,  8 Aug 2014 17:19:13 +0200
Message-Id: <1407511155-5264-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407511155-5264-1-git-send-email-geert@linux-m68k.org>
References: <1407511155-5264-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/pci/cx23885/cx23888-ir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index 2c951dec2d33..c2ff5fc01157 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -263,7 +263,7 @@ static inline unsigned int lpf_count_to_us(unsigned int count)
 }
 
 /*
- * FIFO register pulse width count compuations
+ * FIFO register pulse width count computations
  */
 static u32 clock_divider_to_resolution(u16 divider)
 {
-- 
1.9.1

