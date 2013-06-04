Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3FDRDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:03:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3FDRDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 43/75] ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition
Date: Tue,  4 Jun 2013 09:55:27 -0700
Message-Id: <1370364959-9475-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris BREZILLON <b.brezillon@overkiz.com>

commit f6d35d67d0a5c159f767a20f4fcc1d295a7314b1 upstream.

The PA24 pin is wrongly assigned to peripheral B.
In the current config there is 2 ETX3 pins (PA11 and PA24) and
no ETXER pin (PA22).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 02b70a4..755a61e 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -264,7 +264,7 @@
 						atmel,pins =
 							<0 10 0x2 0x0	/* PA10 periph B */
 							 0 11 0x2 0x0	/* PA11 periph B */
-							 0 24 0x2 0x0	/* PA24 periph B */
+							 0 22 0x2 0x0	/* PA22 periph B */
 							 0 25 0x2 0x0	/* PA25 periph B */
 							 0 26 0x2 0x0	/* PA26 periph B */
 							 0 27 0x2 0x0	/* PA27 periph B */
-- 
1.8.1.2

