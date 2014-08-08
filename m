Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbaHHKml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:42:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56090 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaHHKmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:42:38 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dma-buf/fence: Fix a kerneldoc warning
Date: Fri,  8 Aug 2014 12:42:32 +0200
Message-Id: <1407494552-18147-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

kerneldoc doesn't know how to parse variables, so don't let it try.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/dma-buf/fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/fence.c b/drivers/dma-buf/fence.c
index 4222cb2aa96a..7bb9d65d9a2c 100644
--- a/drivers/dma-buf/fence.c
+++ b/drivers/dma-buf/fence.c
@@ -29,7 +29,7 @@
 EXPORT_TRACEPOINT_SYMBOL(fence_annotate_wait_on);
 EXPORT_TRACEPOINT_SYMBOL(fence_emit);
 
-/**
+/*
  * fence context counter: each execution context should have its own
  * fence context, this allows checking if fences belong to the same
  * context or not. One device can have multiple separate contexts,
-- 
2.0.4

