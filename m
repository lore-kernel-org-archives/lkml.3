Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbbAHQh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:37:56 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61423 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbbAHQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:37:55 -0500
From: Sakshi Bansal <sakshi.april5@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar, shack@linux.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sakshi Bansal <sakshi.april5@gmail.com>
Subject: [Discarding old patch and resending new one] Staging: vt6655: baseband.c: fixed line over 80 characters
Date: Thu,  8 Jan 2015 22:07:41 +0530
Message-Id: <1420735061-10801-1-git-send-email-sakshi.april5@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20150108150921.GN15033@mwanda>
References: <20150108150921.GN15033@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sakshi Bansal <sakshi.april5@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 86c72ba..c138f9b 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -27,7 +27,8 @@
  *
  * Functions:
  *      BBuGetFrameTime        - Calculate data frame transmitting time
- *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
+ *      BBvCaculateParameter   - Caculate PhyLength, PhyService and Phy Signal
+ *                               parameter for baseband Tx
  *      BBbReadEmbedded         - Embedded read baseband register via MAC
  *      BBbWriteEmbedded        - Embedded write baseband register via MAC
  *      BBbVT3253Init          - VIA VT3253 baseband chip init code
-- 
1.9.1

