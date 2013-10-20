Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab3JTFOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 01:14:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33492 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751035Ab3JTFOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 01:14:05 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ethernet: moxa: remove duplicate includes
Date: Sun, 20 Oct 2013 07:13:56 +0200
Message-Id: <1382246036-19253-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by "make includecheck"

Tested that drivers/net/ethernet/moxa/moxart_ether.c still compiles
well on ARM

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index bd1a2d2..7d4c8cc 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -26,7 +26,6 @@
 #include <linux/of_irq.h>
 #include <linux/crc32.h>
 #include <linux/crc32c.h>
-#include <linux/dma-mapping.h>
 
 #include "moxart_ether.h"
 
-- 
1.8.1.2

