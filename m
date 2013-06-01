Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3FAKJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:09:38 -0400
Received: from www17.your-server.de ([213.133.104.17]:34549 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3FAKJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:09:33 -0400
Message-ID: <1370081367.29224.43.camel@localhost.localdomain>
Subject: [PATCH] drm/prime: Cocci spatch "err_cast.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 12:09:27 +0200
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

diff -u -p a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -277,7 +277,7 @@ struct drm_gem_object *drm_gem_prime_imp
 
 	attach = dma_buf_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach))
-		return ERR_PTR(PTR_ERR(attach));
+		return ERR_CAST(attach);
 
 	get_dma_buf(dma_buf);
 


