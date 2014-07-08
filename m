Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaGHRUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:20:44 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:32006 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbaGHRUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:20:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4OANcnvFNXQDwH/2dsb2JhbABZgw6tHwUBAQEBAQEFAW4BmVmBGBd1hDFSgRo3iEYByDMXhXqIZGQdhC0FhGkDlgqUDINFO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Michael Krufky <mkrufky@linuxtv.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/1] r820t: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 19:20:37 +0200
Message-Id: <1404840037-29692-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/tuners/r820t.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 96ccfeb..6906b16 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2300,7 +2300,6 @@ struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 	case 0:
 		/* memory allocation failure */
 		goto err_no_gate;
-		break;
 	case 1:
 		/* new tuner instance */
 		priv->cfg = cfg;
-- 
1.8.4.5

