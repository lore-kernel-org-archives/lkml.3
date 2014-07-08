Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaGHSRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:17:48 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:21945 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051AbaGHSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:17:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4OAIA0vFNXQDwH/2dsb2JhbABagw6tHwUBAQEBAQEFAW4BmVmBGBd1hDFSgRo3iEYByDIXhXqIZGQdhC0FhGkDlgqUDINFO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/1] xc5000: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 20:17:41 +0200
Message-Id: <1404843461-17604-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/tuners/xc5000.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 2b3d514..f059ba2 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1302,7 +1302,6 @@ struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 	switch (instance) {
 	case 0:
 		goto fail;
-		break;
 	case 1:
 		/* new tuner instance */
 		priv->bandwidth = 6000000;
-- 
1.8.4.5

