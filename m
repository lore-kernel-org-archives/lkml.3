Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaL2XeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:34:03 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:59029 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbaL2Xd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:33:59 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Andreas Siegling <andreas.siegling@fau.de>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net, eric.rost@mybabylon.net,
        nks@flawful.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        trivial@kernel.org, Andreas Siegling <andreas.siegling@fau.de>,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: [PATCH] skein: checkpatch: trailing whitespace
Date: Tue, 30 Dec 2014 00:33:34 +0100
Message-Id: <1419896014-13334-1-git-send-email-andreas.siegling@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch will fix the trailing whitespace in
drivers/staging/skein/skein_generic.c.

After applying the patch, there will only remain the checkpatch warning:
	WARNING: Single statement macros should not use a do {} while (0) loop
in files which are in the directory drivers/staging/skein/

Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>
---
 drivers/staging/skein/skein_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 85bd7d0..4eaae1d 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -191,7 +191,7 @@ static int __init skein_generic_init(void)
 
 	return 0;
 
-		
+
 unreg512:
 	crypto_unregister_shash(&alg512);
 unreg256:
-- 
1.9.1

