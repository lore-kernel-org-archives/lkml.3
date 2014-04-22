Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaDVDjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:39:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:47628 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbaDVDju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:39:50 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH Resend] defconfig: sama5_defconfig: updated
Date: Tue, 22 Apr 2014 11:32:54 +0800
Message-ID: <1398137574-5790-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

due to enabling
	-- CONFIG_REGULATOR
	-- CONFIG_REGULATOR_ACT8865

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
Hi Nicolas,

It is a typo.
This patch is based on the branch: at91-3.16-dt, not at91-3.10-dt of
	git://github.com/at91linux/linux-at91.git

Best Regards,
Wenyou Yang

 arch/arm/configs/sama5_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index dc3881e..2b9891e 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -201,3 +201,5 @@ CONFIG_CRYPTO_DEV_ATMEL_TDES=y
 CONFIG_CRYPTO_DEV_ATMEL_SHA=y
 CONFIG_CRC_CCITT=m
 CONFIG_CRC_ITU_T=m
+CONFIG_REGULATOR=y
+CONFIG_REGULATOR_ACT8865=y
-- 
1.7.9.5

