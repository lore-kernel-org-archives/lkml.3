Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbaGATtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:49:22 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:37279 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaGATtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:49:21 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: tglx@linutronix.de, trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH] trivial: genirq: fix reference in devm_request_threaded_irq comment
Date: Tue,  1 Jul 2014 16:47:35 -0300
Message-Id: <1404244055-19880-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be request_threaded_irq, not request_irq

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 kernel/irq/devres.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index 1ef0606..d5d0f73 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -38,7 +38,7 @@ static int devm_irq_match(struct device *dev, void *res, void *data)
  *
  *	Except for the extra @dev argument, this function takes the
  *	same arguments and performs the same function as
- *	request_irq().  IRQs requested with this function will be
+ *	request_threaded_irq().  IRQs requested with this function will be
  *	automatically freed on driver detach.
  *
  *	If an IRQ allocated with this function needs to be freed
-- 
2.0.1

