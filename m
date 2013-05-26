Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3EZDAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 23:00:30 -0400
Received: from gnurou.org ([207.192.72.5]:55595 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869Ab3EZDA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 23:00:29 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 May 2013 23:00:29 EDT
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] MAINTAINERS: add linux-gpio mailing list
Date: Sun, 26 May 2013 11:50:54 +0900
Message-Id: <1369536654-5699-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b645a3d..1541796 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3566,6 +3566,7 @@ GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@linaro.org>
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
+L:	linux-gpio@vger.kernel.org
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 F:	Documentation/gpio.txt
 F:	drivers/gpio/
-- 
1.8.2.3

