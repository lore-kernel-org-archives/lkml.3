Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbaLWFLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:11:25 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45676 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLWFLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:11:24 -0500
From: Kroderia <kroderia@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kroderia <kroderia@gmail.com>
Subject: [PATCH] Fix a white space coding style problem
Date: Tue, 23 Dec 2014 05:10:28 +0000
Message-Id: <1419311428-6644-1-git-send-email-kroderia@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kroderia <kroderia@gmail.com>
---
 drivers/staging/skein/skein_generic.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 85bd7d0..899078f 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -191,7 +191,6 @@ static int __init skein_generic_init(void)
 
 	return 0;
 
-		
 unreg512:
 	crypto_unregister_shash(&alg512);
 unreg256:
-- 
1.7.10.4

