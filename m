Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3IZSzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:55:50 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60170 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3IZSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:22 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: [PATCH 07/21] hexagon: remove unnecessary prom.h includes
Date: Thu, 26 Sep 2013 13:50:42 -0500
Message-Id: <1380221456-11192-8-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Hexagon does not have a prom.h header, so it is probably broken with
CONFIG_OF enabled. In any case, remove unnecessary prom.h include in
preparation to make prom.h optional.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
---
 arch/hexagon/kernel/setup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/hexagon/kernel/setup.c b/arch/hexagon/kernel/setup.c
index 29d1f1b..0e7c1db 100644
--- a/arch/hexagon/kernel/setup.c
+++ b/arch/hexagon/kernel/setup.c
@@ -32,9 +32,6 @@
 #include <asm/hexagon_vm.h>
 #include <asm/vm_mmu.h>
 #include <asm/time.h>
-#ifdef CONFIG_OF
-#include <asm/prom.h>
-#endif
 
 char cmd_line[COMMAND_LINE_SIZE];
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
-- 
1.8.1.2

