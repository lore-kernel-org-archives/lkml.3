Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaGHRXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:23:12 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:63523 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbaGHRXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:23:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4OAIQovFNXQDwH/2dsb2JhbABZgw6tHwUBAQEBAQEFAW4BmVmBGBd1hQOBGjeIRgHIMxeFeohkZB2ELQWEaQOWCpQMg0U7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/1] dvb-frontends: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 19:23:01 +0200
Message-Id: <1404840181-29822-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/dvb-frontends/af9013.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index fb504f1..ecf6388 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -470,7 +470,6 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 		break;
 	default:
 		goto err;
-		break;
 	}
 
 	for (i = 0; i < len; i++) {
-- 
1.8.4.5

