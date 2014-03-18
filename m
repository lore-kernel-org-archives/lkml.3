Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaCRCmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:42:35 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:17883 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753664AbaCRCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:42:34 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux@maxim.org.za>, <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 3/3] defconfig: arm: sama5_defconfig: update
Date: Tue, 18 Mar 2014 10:33:57 +0800
Message-ID: <1395110037-23151-4-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395110037-23151-1-git-send-email-wenyou.yang@atmel.com>
References: <1395110037-23151-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to enable CONFIG_AT91_SLOW_CLOCK

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/configs/sama5_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
index dc3881e..a15879c 100644
--- a/arch/arm/configs/sama5_defconfig
+++ b/arch/arm/configs/sama5_defconfig
@@ -201,3 +201,4 @@ CONFIG_CRYPTO_DEV_ATMEL_TDES=y
 CONFIG_CRYPTO_DEV_ATMEL_SHA=y
 CONFIG_CRC_CCITT=m
 CONFIG_CRC_ITU_T=m
+CONFIG_AT91_SLOW_CLOCK=y
-- 
1.7.9.5

