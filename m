Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaJ0SAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:00:37 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:48817 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbaJ0SAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:00:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYUALiHTlRXQ3zJ/2dsb2JhbABcgw6BLLlDCwUBdJo9BAKBHhcBfYRfI4EaN4hFAbxojweGNIpUHYQ1BZ1hli6BRwGCMTwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net/irda: include linux/uaccess.h instead of asm/uaccess.h
Date: Mon, 27 Oct 2014 19:00:08 +0100
Message-Id: <1414432809-29054-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/irda/ircomm/ircomm_tty_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/irda/ircomm/ircomm_tty_ioctl.c b/net/irda/ircomm/ircomm_tty_ioctl.c
index ce94385..2db24bd 100644
--- a/net/irda/ircomm/ircomm_tty_ioctl.c
+++ b/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -31,8 +31,7 @@
 #include <linux/termios.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <net/irda/irda.h>
 #include <net/irda/irmod.h>
-- 
1.9.1

