Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbbADCPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 21:15:11 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36810 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbbADCPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 21:15:09 -0500
From: Daniel Tang <dt.tangr@gmail.com>
To: Peter.Chen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, Daniel Tang <dt.tangr@gmail.com>
Subject: [PATCH 1/2] Chipidea: TI-NSPIRE USB OTG hardware does not support high speed and must connect at full speed
Date: Sun,  4 Jan 2015 13:14:58 +1100
Message-Id: <1420337699-28219-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 drivers/usb/chipidea/ci_hdrc_zevio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_zevio.c b/drivers/usb/chipidea/ci_hdrc_zevio.c
index d976fc1..1264de5 100644
--- a/drivers/usb/chipidea/ci_hdrc_zevio.c
+++ b/drivers/usb/chipidea/ci_hdrc_zevio.c
@@ -18,7 +18,7 @@
 
 static struct ci_hdrc_platform_data ci_hdrc_zevio_platdata = {
 	.name			= "ci_hdrc_zevio",
-	.flags			= CI_HDRC_REGS_SHARED,
+	.flags			= CI_HDRC_REGS_SHARED | CI_HDRC_FORCE_FULLSPEED,
 	.capoffset		= DEF_CAPOFFSET,
 };
 
-- 
2.1.3

