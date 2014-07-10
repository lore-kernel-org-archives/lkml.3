Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaGJNSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:18:51 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:34158 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaGJNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:18:50 -0400
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] GenWQE: Remove unnecessary include
Date: Thu, 10 Jul 2014 10:17:08 -0300
Message-Id: <1404998228-2148-1-git-send-email-klebers@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071013-9564-0000-0000-0000013FD8E0
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

