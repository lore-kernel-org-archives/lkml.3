Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaGNDHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 23:07:45 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38487 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaGNDHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 23:07:39 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kees Cook <keescook@chromium.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] xillybus: place 'else' on same line as '}'
Date: Sun, 13 Jul 2014 20:07:00 -0700
Message-Id: <1405307220-15946-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place 'else' on same line as closing brace '}' as per
Documentation/CodingStyle.  Fixes 1 error found by checkpatch.pl.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/xillybus/xillybus_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index ab6502c..7de4c11 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -546,8 +546,7 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 			channel->rd_buffers = buffers;
 			rc = xilly_get_dma_buffers(ep, &rd_alloc, buffers,
 						   bufnum, bytebufsize);
-		}
-		else if (channelnum > 0) {
+		} else if (channelnum > 0) {
 			channel->num_wr_buffers = bufnum;
 
 			channel->seekable = seekable;
-- 
2.0.1

