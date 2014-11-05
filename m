Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaKES3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:29:11 -0500
Received: from blu004-omc1s22.hotmail.com ([65.55.116.33]:64225 "EHLO
	BLU004-OMC1S22.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbaKES3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:29:08 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 13:29:08 EST
X-TMN: [Lbv+VDdOd9slvcdQAfGlqQZfQoxR4s/yAox2StNxQ7Y=]
X-Originating-Email: [dhdawson100@hotmail.co.uk]
Message-ID: <BLU436-SMTP4872A8CFC8E70D215BBF81AF870@phx.gbl>
From: Daniel Dawson <dhdawson100@hotmail.co.uk>
To: rmk+kernel@arm.linux.org.uk, pdeschrijver@nvidia.com
CC: linux-kernel@vger.kernel.org, Daniel Dawson <dhdawson100@hotmail.co.uk>
Subject: [PATCH] init: calibrate.c: Fixed some coding style issues.
Date: Wed, 5 Nov 2014 18:23:11 +0000
X-Mailer: git-send-email 1.8.4.5
X-OriginalArrivalTime: 05 Nov 2014 18:23:59.0120 (UTC) FILETIME=[AAC55900:01CFF925]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues in init/calibrate.c

Signed-off-by: Daniel Dawson <dhdawson100@hotmail.co.uk>
---
 init/calibrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index ce635dc..f61375e 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -15,7 +15,7 @@ unsigned long lpj_fine;
 unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
-	preset_lpj = simple_strtoul(str,NULL,0);
+	preset_lpj = simple_strtoul(str, NULL, 0);
 	return 1;
 }
 
@@ -44,7 +44,7 @@ static unsigned long calibrate_delay_direct(void)
 	int min = -1;
 	int i;
 
-	if (read_current_timer(&pre_start) < 0 )
+	if (read_current_timer(&pre_start) < 0)
 		return 0;
 
 	/*
-- 
1.8.4.5

