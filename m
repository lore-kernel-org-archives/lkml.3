Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3IZS5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:57:05 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46988 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3IZSvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:19 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net
Subject: [PATCH 05/21] openrisc: remove unnecessary prom.h include
Date: Thu, 26 Sep 2013 13:50:40 -0500
Message-Id: <1380221456-11192-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Remove unnecessary prom.h include in preparation to make prom.h optional.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
---
 arch/openrisc/kernel/prom.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index a63e768..a915dc7 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -37,7 +37,6 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 
-#include <asm/prom.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/irq.h>
-- 
1.8.1.2

