Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3HPX6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:58:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51827 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab3HPWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 058/133] serial: arc_uart: Fix module alias
Date: Fri, 16 Aug 2013 15:33:20 -0700
Message-Id: <1376692475-28413-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit d5a12ea7a9e58d9e5c19d25cb668aadb396423ec upstream.

Platform drivers use "platform:" prefix in module alias.
Also use DRIVER_NAME in MODULE_ALIAS to make module autoloading work.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/arc_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 3e0b3fa..c4e06db 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -741,6 +741,6 @@ module_init(arc_serial_init);
 module_exit(arc_serial_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("plat-arcfpga/uart");
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("Vineet Gupta");
 MODULE_DESCRIPTION("ARC(Synopsys) On-Chip(fpga) serial driver");
-- 
1.8.1.2

