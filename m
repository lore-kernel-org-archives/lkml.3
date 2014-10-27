Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaJ0WkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:40:07 -0400
Received: from distopic.net ([80.67.6.140]:60257 "EHLO distopic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbaJ0WkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:40:06 -0400
X-Greylist: delayed 1316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 18:40:05 EDT
Message-ID: <544EC45E.3030906@distopic.net>
Date: Mon, 27 Oct 2014 23:17:02 +0100
From: Mikael Svantesson <mikael@distopic.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Jake Edge <jake@lwn.net>,
        Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org
CC: Mikael Svantesson <mikael@distopic.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: skein: skein_api.c: removed space before ','
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikael Svantesson <mikael@distopic.net>
---
 drivers/staging/skein/skein_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/skein/skein_api.c
b/drivers/staging/skein/skein_api.c
index 6e700ee..5bfce07 100644
--- a/drivers/staging/skein/skein_api.c
+++ b/drivers/staging/skein/skein_api.c
@@ -31,7 +31,7 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum
skein_size size)
 {
 	skein_assert_ret(ctx && size, SKEIN_FAIL);
 -	memset(ctx , 0, sizeof(struct skein_ctx));
+	memset(ctx, 0, sizeof(struct skein_ctx));
 	ctx->skein_size = size;
  	return SKEIN_SUCCESS;
-- 
2.1.1

