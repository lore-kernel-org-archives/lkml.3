Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaLUVPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:15:19 -0500
Received: from sauhun.de ([89.238.76.85]:52859 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaLUVPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:17 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 02/28] mips: lantiq: xway: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:23 +0100
Message-Id: <1419196495-9626-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 arch/mips/lantiq/xway/vmmc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/lantiq/xway/vmmc.c b/arch/mips/lantiq/xway/vmmc.c
index 696cd57f6f13..d001bc38908a 100644
--- a/arch/mips/lantiq/xway/vmmc.c
+++ b/arch/mips/lantiq/xway/vmmc.c
@@ -61,7 +61,6 @@ static struct platform_driver vmmc_driver = {
 	.probe = vmmc_probe,
 	.driver = {
 		.name = "lantiq,vmmc",
-		.owner = THIS_MODULE,
 		.of_match_table = vmmc_match,
 	},
 };
-- 
2.1.3

