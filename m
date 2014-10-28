Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaJ1UIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:08:11 -0400
Received: from distopic.net ([80.67.6.140]:33282 "EHLO distopic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaJ1UIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:08:10 -0400
Message-ID: <544FF764.7090003@distopic.net>
Date: Tue, 28 Oct 2014 21:07:00 +0100
From: Mikael Svantesson <mikael@distopic.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Jake Edge <jake@lwn.net>,
        Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org,
        "mikael@distopic.net >> Mikael Svantesson" <mikael@distopic.net>
Subject: [PATCH v2] staging: skein: skein_api.c: removed space before ','
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikael Svantesson <mikael@distopic.net>
---
 drivers/staging/skein/skein_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/skein/skein_api.c b/drivers/staging/skein/skein_api.c
index 6e700ee..5bfce07 100644
--- a/drivers/staging/skein/skein_api.c
+++ b/drivers/staging/skein/skein_api.c
@@ -31,7 +31,7 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
 {
 	skein_assert_ret(ctx && size, SKEIN_FAIL);
 -	memset(ctx , 0, sizeof(struct skein_ctx));
+	memset(ctx, 0, sizeof(struct skein_ctx));
 	ctx->skein_size = size;
  	return SKEIN_SUCCESS;
-- 
2.1.1

