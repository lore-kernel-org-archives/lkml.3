Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab3B1SaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:30:12 -0500
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:46311 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3B1SaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:30:10 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH] mailbox, pl320-ipc: remove __init from probe function
Date: Thu, 28 Feb 2013 12:29:19 -0600
Message-Id: <1362076159-20426-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids a section mismatch.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
 drivers/mailbox/pl320-ipc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index c45b3ae..d873cba 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -138,8 +138,7 @@ int pl320_ipc_unregister_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(pl320_ipc_unregister_notifier);
 
-static int __init pl320_probe(struct amba_device *adev,
-				const struct amba_id *id)
+static int pl320_probe(struct amba_device *adev, const struct amba_id *id)
 {
 	int ret;
 
-- 
1.7.10.4

