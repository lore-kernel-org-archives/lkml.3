Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3BENzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:55:05 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:43951 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3BENzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:55:02 -0500
From: Johan Hovold <jhovold@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH resend] ARM: at91/ide: remove unsused at91-ide Kconfig entry
Date: Tue,  5 Feb 2013 14:53:35 +0100
Message-Id: <1360072415-6594-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1352892034-18871-1-git-send-email-jhovold@gmail.com>
References: <1352892034-18871-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cf844751fb25e ("ARM: at91: drop ide driver in favor of the pata
one") removed the at91-ide driver but did not remove the Kconfig entry.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Resend of patch first posted mid-November with trivial added as CC. Perhaps it
can go in via the AT91-folks, otherwise?

Thanks,
Johan


 drivers/ide/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 5a26584..bfec4e6 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -702,11 +702,6 @@ config BLK_DEV_IDE_TX4939
 	depends on SOC_TX4939
 	select BLK_DEV_IDEDMA_SFF
 
-config BLK_DEV_IDE_AT91
-	tristate "Atmel AT91 (SAM9, CAP9, AT572D940HF) IDE support"
-	depends on ARM && ARCH_AT91 && !ARCH_AT91RM9200 && !ARCH_AT91X40
-	select IDE_TIMINGS
-
 config BLK_DEV_IDE_ICSIDE
 	tristate "ICS IDE interface support"
 	depends on ARM && ARCH_ACORN
-- 
1.8.1.1

