Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbbA1UQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:16:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48453 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbbA1UQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:16:44 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Paul Clements <paul.clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH] MAINTAINERS: Update NBD maintainer
Date: Wed, 28 Jan 2015 19:35:38 +0100
Message-Id: <1422470138-8352-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.4
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul stops maintining NBD and I will take his place from now on.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ebb056cbe0a..4a83259e7f45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6583,9 +6583,10 @@ F:	include/uapi/linux/netrom.h
 F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
-M:	Paul Clements <Paul.Clements@steeleye.com>
+M:	Markus Pargmann <mpa@pengutronix.de
 S:	Maintained
 L:	nbd-general@lists.sourceforge.net
+T:	git git://git.pengutronix.de/git/mpa/linux-nbd.git
 F:	Documentation/blockdev/nbd.txt
 F:	drivers/block/nbd.c
 F:	include/linux/nbd.h
-- 
2.1.4

