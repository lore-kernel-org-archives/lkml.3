Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab3DYVS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:18:28 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:27824 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab3DYVS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:18:26 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] partitions/Makefile: compile aix.c if configured.
Date: Thu, 25 Apr 2013 23:10:28 +0200
Message-Id: <1366924229-21569-5-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366924229-21569-1-git-send-email-phdm@macqel.be>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/partitions/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/partitions/Makefile b/block/partitions/Makefile
index 03af8ea..2be4d7b 100644
--- a/block/partitions/Makefile
+++ b/block/partitions/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_BLOCK) := check.o
 obj-$(CONFIG_ACORN_PARTITION) += acorn.o
 obj-$(CONFIG_AMIGA_PARTITION) += amiga.o
 obj-$(CONFIG_ATARI_PARTITION) += atari.o
+obj-$(CONFIG_AIX_PARTITION) += aix.o
 obj-$(CONFIG_MAC_PARTITION) += mac.o
 obj-$(CONFIG_LDM_PARTITION) += ldm.o
 obj-$(CONFIG_MSDOS_PARTITION) += msdos.o
-- 
1.7.1

