Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbaFYQXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:23:01 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:42236 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbaFYQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:22:58 -0400
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH 4/4] GenWQE: Remove unnecessary include
Date: Wed, 25 Jun 2014 13:22:07 -0300
Message-Id: <1403713327-27976-5-git-send-email-klebers@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
References: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062516-1524-0000-0000-00000A1B22B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The include for the UAPI header file from card_base.c can be removed
since it's already included on card_base.h.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_base.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
index abb7961..dc8c04a 100644
--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -38,7 +38,6 @@
 #include <linux/notifier.h>
 #include <linux/device.h>
 #include <linux/log2.h>
-#include <linux/genwqe/genwqe_card.h>
 
 #include "card_base.h"
 #include "card_ddcb.h"
-- 
1.7.1

