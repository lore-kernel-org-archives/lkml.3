Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaLLWLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:11:17 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61828 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaLLWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:08:40 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        jogo@openwrt.org, arnd@arndb.de, computersforpeace@gmail.com,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 16/23] MIPS: BMIPS: Remove bogus bus name
Date: Fri, 12 Dec 2014 14:07:07 -0800
Message-Id: <1418422034-17099-17-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
References: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no "bcm3384" bus so let's just remove it to avoid confusion.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/bmips/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index 5099109..ac402ed 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -83,7 +83,7 @@ void __init device_tree_init(void)
 
 int __init plat_of_setup(void)
 {
-	return __dt_register_buses("brcm,bcm3384", "simple-bus");
+	return __dt_register_buses("simple-bus", NULL);
 }
 
 arch_initcall(plat_of_setup);
-- 
2.1.1

