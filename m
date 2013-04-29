Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3D2VTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:19:24 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:15177 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab3D2VTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:19:20 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] partitions/Makefile: compile aix.c if configured.
Date: Mon, 29 Apr 2013 23:18:32 +0200
Message-Id: <1367270313-18871-5-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367270313-18871-1-git-send-email-phdm@macqel.be>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

