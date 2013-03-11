Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3CKNQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:16:08 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:61983 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab3CKNQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:16:07 -0400
Message-ID: <1363007760.3137.69.camel@x61.thuisdomein>
Subject: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 14:16:00 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 13:16:01.0277 (UTC) FILETIME=[939D42D0:01CE1E5A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested by grepping the tree.

1) Typo was added in commit f8c95fe6d9adad72fc7bce90f4ab68d119f50c5b
("ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs").
Looking at that patch and at the tree makes clear that DEBUG_IMX53_UART
was intended here.

 arch/arm/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index acdddda..ecfcdba 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -492,7 +492,7 @@ config DEBUG_IMX_UART_PORT
 						DEBUG_IMX31_UART || \
 						DEBUG_IMX35_UART || \
 						DEBUG_IMX51_UART || \
-						DEBUG_IMX50_IMX53_UART || \
+						DEBUG_IMX53_UART || \
 						DEBUG_IMX6Q_UART
 	default 1
 	help
-- 
1.7.11.7

