Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbaJ2RqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:46:21 -0400
Received: from distopic.net ([80.67.6.140]:34162 "EHLO distopic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348AbaJ2RqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:18 -0400
From: Mikael Svantesson <mikael@distopic.net>
To: mikael@distopic.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: skein: skein_api.c: removed space before ','
Date: Wed, 29 Oct 2014 18:45:14 +0100
Message-Id: <1414604714-13306-1-git-send-email-mikael@distopic.net>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <545117FC.6030704@distopic.net>
References: <545117FC.6030704@distopic.net>
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

