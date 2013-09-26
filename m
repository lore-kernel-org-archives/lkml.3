Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3IZS5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:57:25 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50282 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3IZSvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:16 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 03/21] ARM: keystone: remove unnecessary prom.h include
Date: Thu, 26 Sep 2013 13:50:38 -0500
Message-Id: <1380221456-11192-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Remove unnecessary prom.h include in preparation to make prom.h optional.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-keystone/platsmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-keystone/platsmp.c b/arch/arm/mach-keystone/platsmp.c
index c122961..5cf0683 100644
--- a/arch/arm/mach-keystone/platsmp.c
+++ b/arch/arm/mach-keystone/platsmp.c
@@ -17,7 +17,6 @@
 #include <linux/io.h>
 
 #include <asm/smp_plat.h>
-#include <asm/prom.h>
 
 #include "keystone.h"
 
-- 
1.8.1.2

