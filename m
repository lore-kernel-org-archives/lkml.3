Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaHNF0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:26:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbaHNF0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:26:12 -0400
From: Fam Zheng <famz@redhat.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, famz@redhat.com
Subject: [TRIVIAL PATCH] Documentation: Fix null_blk parameter irq_mode to irqmode
Date: Thu, 14 Aug 2014 13:26:22 +0800
Message-Id: <1407993982-14015-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To match the real module parameter name we implemented.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 Documentation/block/null_blk.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/block/null_blk.txt b/Documentation/block/null_blk.txt
index b2830b4..2f6c6ff 100644
--- a/Documentation/block/null_blk.txt
+++ b/Documentation/block/null_blk.txt
@@ -42,7 +42,7 @@ nr_devices=[Number of devices]: Default: 2
   Number of block devices instantiated. They are instantiated as /dev/nullb0,
   etc.
 
-irq_mode=[0-2]: Default: 1-Soft-irq
+irqmode=[0-2]: Default: 1-Soft-irq
   The completion mode used for completing IOs to the block-layer.
 
   0: None.
@@ -53,7 +53,7 @@ irq_mode=[0-2]: Default: 1-Soft-irq
      completion.
 
 completion_nsec=[ns]: Default: 10.000ns
-  Combined with irq_mode=2 (timer). The time each completion event must wait.
+  Combined with irqmode=2 (timer). The time each completion event must wait.
 
 submit_queues=[0..nr_cpus]:
   The number of submission queues attached to the device driver. If unset, it
-- 
2.0.3

