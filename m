Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3FDROB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:14:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48270 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3FDQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 11/75] ARM: at91/trivial: fix model name for SAM9X25-EK
Date: Tue,  4 Jun 2013 09:54:55 -0700
Message-Id: <1370364959-9475-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit 9349d00fc3ff2b110dc07d9f5d06abfeac300c19 upstream.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/at91sam9x25ek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9x25ek.dts b/arch/arm/boot/dts/at91sam9x25ek.dts
index 3b40d11..315250b 100644
--- a/arch/arm/boot/dts/at91sam9x25ek.dts
+++ b/arch/arm/boot/dts/at91sam9x25ek.dts
@@ -11,7 +11,7 @@
 /include/ "at91sam9x5ek.dtsi"
 
 / {
-	model = "Atmel AT91SAM9G25-EK";
+	model = "Atmel AT91SAM9X25-EK";
 	compatible = "atmel,at91sam9x25ek", "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
 
 	ahb {
-- 
1.8.1.2

