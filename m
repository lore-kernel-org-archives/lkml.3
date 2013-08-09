Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967797Ab3HICTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:19:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967453Ab3HIB6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Vineet Gupta <vgupta@synopsys.com>
Subject: [ 023/102] serial: arc_uart: Fix module alias
Date: Thu,  8 Aug 2013 18:56:59 -0700
Message-Id: <20130809015015.343919928@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit d5a12ea7a9e58d9e5c19d25cb668aadb396423ec upstream.

Platform drivers use "platform:" prefix in module alias.
Also use DRIVER_NAME in MODULE_ALIAS to make module autoloading work.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/arc_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -773,6 +773,6 @@ module_init(arc_serial_init);
 module_exit(arc_serial_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("plat-arcfpga/uart");
+MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_AUTHOR("Vineet Gupta");
 MODULE_DESCRIPTION("ARC(Synopsys) On-Chip(fpga) serial driver");


