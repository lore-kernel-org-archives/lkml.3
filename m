Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaESORr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:17:47 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:41261 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaESORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:17:46 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <shigekatsu.tateno@atmel.com>
Subject: [PATCH] staging: ozwpan: Change Maintainer
Date: Mon, 19 May 2014 15:17:30 +0100
Message-ID: <1400509050-6300-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will be not able to work on ozwpan driver anymore.
Remove my name & add Tateno as maintainer.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 MAINTAINERS                 |    2 +-
 drivers/staging/ozwpan/TODO |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0de64a5..3a9e4d83 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8466,7 +8466,7 @@ S:	Maintained
 F:	drivers/staging/olpc_dcon/
 
 STAGING - OZMO DEVICES USB OVER WIFI DRIVER
-M:	Rupesh Gujare <rupesh.gujare@atmel.com>
+M:	Shigekatsu Tateno <shigekatsu.tateno@atmel.com>
 S:	Maintained
 F:	drivers/staging/ozwpan/
 
diff --git a/drivers/staging/ozwpan/TODO b/drivers/staging/ozwpan/TODO
index b4febd7..f32c1c0 100644
--- a/drivers/staging/ozwpan/TODO
+++ b/drivers/staging/ozwpan/TODO
@@ -10,5 +10,5 @@ TODO:
 	- testing with as many devices as possible.
 
 Please send any patches for this driver to
-Rupesh Gujare <rupesh.gujare@atmel.com>
+Shigekatsu Tateno <shigekatsu.tateno@atmel.com>
 and Greg Kroah-Hartman <gregkh@linuxfoundation.org>.
-- 
1.7.9.5

