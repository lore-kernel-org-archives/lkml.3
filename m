Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852Ab3DBQcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:32:09 -0400
Received: from [65.55.88.13] ([65.55.88.13]:10235 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759241Ab3DBQcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:32:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <shawn.guo@linaro.org>
CC: <tglx@linutronix.de>, <john.stultz@linaro.org>,
        <linux-kernel@vger.kernel.org>, <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] clocksource: mxs_timer: Add semicolon at end of line
Date: Tue, 2 Apr 2013 13:30:32 -0300
Message-ID: <1364920232-9604-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build error:

drivers/clocksource/mxs_timer.c:304:1: error: expected ',' or ';' at end of input

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/clocksource/mxs_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
index a4d469b..02af420 100644
--- a/drivers/clocksource/mxs_timer.c
+++ b/drivers/clocksource/mxs_timer.c
@@ -301,4 +301,4 @@ static void __init mxs_timer_init(struct device_node *np)
 	irq = irq_of_parse_and_map(np, 0);
 	setup_irq(irq, &mxs_timer_irq);
 }
-CLOCKSOURCE_OF_DECLARE(mxs, "fsl,timrot", mxs_timer_init)
+CLOCKSOURCE_OF_DECLARE(mxs, "fsl,timrot", mxs_timer_init);
-- 
1.7.9.5


