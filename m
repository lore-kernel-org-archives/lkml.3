Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3AXSPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:15:09 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:54341 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab3AXSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:15:07 -0500
X-Forefront-Antispam-Report: CIP:157.56.245.149;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0810HT002.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2fh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH] staging:ozwpan: Change email address.
Date: Thu, 24 Jan 2013 18:14:51 +0000
Message-ID: <1359051291-3235-1-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of transition caused due to acquisition of Ozmo Devices by Atmel,
my email address is changed.

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 MAINTAINERS                 |    2 +-
 drivers/staging/ozwpan/TODO |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 49afc49..3603fd3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7248,7 +7248,7 @@ S:	Odd Fixes
 F:	drivers/staging/olpc_dcon/
 
 STAGING - OZMO DEVICES USB OVER WIFI DRIVER
-M:	Rupesh Gujare <rgujare@ozmodevices.com>
+M:	Rupesh Gujare <rupesh.gujare@atmel.com>
 S:	Maintained
 F:	drivers/staging/ozwpan/
 
diff --git a/drivers/staging/ozwpan/TODO b/drivers/staging/ozwpan/TODO
index c71bd83..b4febd7 100644
--- a/drivers/staging/ozwpan/TODO
+++ b/drivers/staging/ozwpan/TODO
@@ -10,5 +10,5 @@ TODO:
 	- testing with as many devices as possible.
 
 Please send any patches for this driver to
-Rupesh Gujare <rgujare@ozmodevices.com>
+Rupesh Gujare <rupesh.gujare@atmel.com>
 and Greg Kroah-Hartman <gregkh@linuxfoundation.org>.
-- 
1.7.5.4


