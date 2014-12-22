Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaLVPV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:21:27 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38990 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaLVPVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:21:00 -0500
From: mathieu.poirier@linaro.org
To: jason@lakedaemon.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH v2 1/2] staging: skein: Fixing trailing whitespace error
Date: Mon, 22 Dec 2014 08:20:38 -0700
Message-Id: <1419261639-17157-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419261639-17157-1-git-send-email-mathieu.poirier@linaro.org>
References: <1419261639-17157-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/staging/skein/skein_generic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 85bd7d0168b0..899078f1b8bc 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -191,7 +191,6 @@ static int __init skein_generic_init(void)
 
 	return 0;
 
-		
 unreg512:
 	crypto_unregister_shash(&alg512);
 unreg256:
-- 
1.9.1

