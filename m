Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3G0XH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 19:07:58 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57857 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3G0XH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 19:07:57 -0400
From: Cong Ding <dinggnu@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] avr32: boards/atngw100/mrmt.c: fix building error
Date: Sat, 27 Jul 2013 19:07:51 -0400
Message-Id: <1374966478-16279-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there is an additional "{", which causes building error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/avr32/boards/atngw100/mrmt.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/avr32/boards/atngw100/mrmt.c b/arch/avr32/boards/atngw100/mrmt.c
index ccc9599..1ba09e4 100644
--- a/arch/avr32/boards/atngw100/mrmt.c
+++ b/arch/avr32/boards/atngw100/mrmt.c
@@ -150,7 +150,6 @@ static struct ac97c_platform_data __initdata ac97c0_data = {
 static struct platform_device rmt_ts_device = {
 	.name	= "ucb1400_ts",
 	.id	= -1,
-	}
 };
 #endif
 
-- 
1.7.10.4

