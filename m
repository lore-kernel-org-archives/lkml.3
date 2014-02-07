Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaBGMhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:37:32 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49948 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaBGMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:37:26 -0500
Date: Fri, 7 Feb 2014 18:07:20 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 15/26] drivers: isdn: Mark function as static in mISDNipac.c
Message-ID: <5d52b7d0719e175dca22644e31549beae1f0b315.1390408517.git.rashika.kheria@gmail.com>
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

Mark functions as static in hardware/mISDN/mISDNipac.c because they are
not used outside this file.

This elimiantes the following warnings in hardware/mISDN/mISDNipac.c:
drivers/isdn/hardware/mISDN/mISDNipac.c:116:1: warning: no previous prototype for ‘isac_empty_fifo’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/mISDN/mISDNipac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardware/mISDN/mISDNipac.c
index ccd7d85..e139abc 100644
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -112,7 +112,7 @@ isac_ph_state_bh(struct dchannel *dch)
 	pr_debug("%s: TE newstate %x\n", isac->name, dch->state);
 }
 
-void
+static void
 isac_empty_fifo(struct isac_hw *isac, int count)
 {
 	u8 *ptr;
-- 
1.7.9.5

