Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3ANVoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:44:08 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:46321 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab3ANVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:44:07 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] avr32: boards/atngw100/mrmt.c: fix build error
Date: Mon, 14 Jan 2013 22:43:51 +0100
Message-Id: <1358199833-15769-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there is an extra "} in the file, so we delete it.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/avr32/boards/atngw100/mrmt.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/avr32/boards/atngw100/mrmt.c b/arch/avr32/boards/atngw100/mrmt.c
index f914319..7de083d 100644
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
1.7.9.5

