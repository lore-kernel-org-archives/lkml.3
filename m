Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaDUFRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:17:38 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:34579 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbaDUFRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:17:36 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 01:17:36 EDT
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH] defconfig: sama5_defconfig: updated
Date: Mon, 21 Apr 2014 13:05:27 +0800
Message-ID: <1398056727-21339-1-git-send-email-wenyou.yang@atmel.com>
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

The patch is based on the branch: at91-3.10-dt
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

