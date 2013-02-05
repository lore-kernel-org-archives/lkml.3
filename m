Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3BEPLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:11:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61732 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3BEPLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:11:03 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Kirkwood: Add missing linux/i2c.h include
Date: Tue,  5 Feb 2013 16:10:25 +0100
Message-Id: <1360077025-8046-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:mnQKT1fUJY0x9xAGgdXtbrHbTBxYTSQTtph4JF2IxXl
 +EprjUJuyf72Ie8VVuhuTKuenLhUfOnnd+4dnPh8zNz+OsfgIv
 el/SKM3V73XjQl6/t64Ee2RtU6DAyuQPc3zmrsBzClb/VQXPpc
 5n4LccyxKHNmwjpUZRC0Umzag5xgAX4Us1V+7JbxYgaqqF9tC0
 ngpBr+fQwajJntgdYWsA/SpiUSEXVNvkaXjDmBywXZnhUBrx6/
 xvuP0iLEWu9cnjkZBuSfUzm0w0DjZ9ibJRsTokaIItmdY6+bOn
 DzcQsu85haHQ8wHHHfOQ8MbNulNOMKTQjcVkN5Jz1n66HP5v+h
 uvTSSh5VusmifRt1EboEK49VPIg+dd0hS+j4a8naYH2BXyWmYB
 xgowhV/O5yxXNhnokQXNMWMR/BMeZxFmqdCoky/H/gbMEZMVc5
 M+H9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nsa310 board uses I2C_BOARD_INFO and i2c_register_board_info(), both
of which are defined in the linux/i2c.h header file.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mach-kirkwood/board-nsa310.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-kirkwood/board-nsa310.c b/arch/arm/mach-kirkwood/board-nsa310.c
index 61c4b18..970174a 100644
--- a/arch/arm/mach-kirkwood/board-nsa310.c
+++ b/arch/arm/mach-kirkwood/board-nsa310.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
+#include <linux/i2c.h>
 #include <mach/kirkwood.h>
 #include <linux/of.h>
 #include "common.h"
-- 
1.8.1.2

