Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886Ab3DIMpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:45:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:38010 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147Ab3DIMpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:45:09 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>, <cjb@laptop.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] mmc: atmel-mci: remove include <mach/cpu.h>
Date: Tue, 9 Apr 2013 14:45:00 +0200
Message-ID: <1365511500-13778-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header file not needed anymore as we have removed
the calls to cpu_is_xxx() macro.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/mmc/host/atmel-mci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e75774f..08e2b92 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -40,8 +40,6 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
-#include <mach/cpu.h>
-
 #include "atmel-mci-regs.h"
 
 #define ATMCI_DATA_ERROR_FLAGS	(ATMCI_DCRCE | ATMCI_DTOE | ATMCI_OVRE | ATMCI_UNRE)
-- 
1.8.0

