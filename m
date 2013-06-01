Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107Ab3FAJ4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:56:39 -0400
Received: from www17.your-server.de ([213.133.104.17]:60706 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab3FAJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:56:31 -0400
Message-ID: <1370080586.29224.30.camel@localhost.localdomain>
Subject: [PATCH] [media] media: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: g.liakhovetski@gmx.de, mchehab@redhat.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:56:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -359,10 +359,7 @@ static int sh_veu_context_init(struct sh
 	veu->m2m_ctx = v4l2_m2m_ctx_init(veu->m2m_dev, veu,
 					 sh_veu_queue_init);
 
-	if (IS_ERR(veu->m2m_ctx))
-		return PTR_ERR(veu->m2m_ctx);
-
-	return 0;
+	return PTR_RET(veu->m2m_ctx);
 }
 
 static int sh_veu_querycap(struct file *file, void *priv,


