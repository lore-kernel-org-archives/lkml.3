Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbaJ3N7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:59:41 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50719 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759946AbaJ3N7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:59:39 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 1/3] of/irq: Export of_irq_get()
Date: Thu, 30 Oct 2014 15:59:36 +0200
Message-Id: <1414677578-27412-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function will be used by the I2C core which can be compiled as a
module.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/of/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 1471e0a223a5..0d7765807f49 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -405,6 +405,7 @@ int of_irq_get(struct device_node *dev, int index)
 
 	return irq_create_of_mapping(&oirq);
 }
+EXPORT_SYMBOL_GPL(of_irq_get);
 
 /**
  * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq number
-- 
2.0.4

