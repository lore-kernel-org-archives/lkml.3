Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaLHVwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:52:00 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60701 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaLHVv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:51:57 -0500
From: Olof Johansson <olof@lixom.net>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        f.fainelli@gmail.com, Olof Johansson <olof@lixom.net>
Subject: [PATCH 2/2] clk: bcm: kona: make a variable static
Date: Mon,  8 Dec 2014 13:54:05 -0800
Message-Id: <1418075645-14571-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418075645-14571-1-git-send-email-olof@lixom.net>
References: <1418075645-14571-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not used outside of this file.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/clk/bcm/clk-kona-setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index e5aeded..152e7fe 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -21,7 +21,7 @@
 #define selector_clear_exists(sel)	((sel)->width = 0)
 #define trigger_clear_exists(trig)	FLAG_CLEAR(trig, TRIG, EXISTS)
 
-LIST_HEAD(ccu_list);	/* The list of set up CCUs */
+static LIST_HEAD(ccu_list);	/* The list of set up CCUs */
 
 /* Validity checking */
 
-- 
1.7.10.4

