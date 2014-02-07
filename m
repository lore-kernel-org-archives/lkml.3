Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaBGMgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:36:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38635 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaBGMgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:36:21 -0500
Date: Fri, 7 Feb 2014 18:06:15 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 14/26] drivers: isdn: Mark function as static in w6692.c
Message-ID: <a825533c7ef63682bb42113546fe1741f2c4a5a0.1390408517.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in hardware/mISDN/w6692.c because they ar enot
used outside this file.

This eliminates the following warnings in hardware/mISDN/w6692.c:
drivers/isdn/hardware/mISDN/w6692.c:851:6: warning: no previous prototype for ‘initW6692’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/mISDN/w6692.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
index de69f68..2e24a05 100644
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -848,7 +848,7 @@ dbusy_timer_handler(struct dchannel *dch)
 	}
 }
 
-void initW6692(struct w6692_hw *card)
+static void initW6692(struct w6692_hw *card)
 {
 	u8	val;
 
-- 
1.7.9.5

