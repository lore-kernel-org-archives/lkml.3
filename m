Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaCJW2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:28:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45212 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaCJW2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:28:44 -0400
Message-ID: <531e3c9a.085e0e0a.4316.ffffe91d@mx.google.com>
From: Silvan Jegen <s.jegen@gmail.com>
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Mon, 10 Mar 2014 22:33:50 +0100
Subject: [PATCH] pata_legacy: Remove dead code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current flow of control prevents this function from being
called. Let's remove the call.

Signed-off-by: Silvan Jegen <s.jegen@gmail.com>
---
 drivers/ata/pata_legacy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index be81642..bce2a8c 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -916,7 +916,6 @@ static __init int probe_chip_type(struct legacy_probe *probe)
 			local_irq_restore(flags);
 			return BIOS;
 		}
-		local_irq_restore(flags);
 	}
 
 	if (ht6560a & mask)
-- 
1.9.0

