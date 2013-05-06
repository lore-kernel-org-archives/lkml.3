Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab3EFVRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:17:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3EFUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 009/115] ARM: at91/trivial: fix model name for SAM9G15-EK
Date: Mon,  6 May 2013 13:44:05 -0700
Message-Id: <20130506203056.544008505@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 88fcb59a06556bf10eac97d7abb913cccea2c830 upstream.

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9g15ek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/at91sam9g15ek.dts
+++ b/arch/arm/boot/dts/at91sam9g15ek.dts
@@ -11,6 +11,6 @@
 /include/ "at91sam9x5ek.dtsi"
 
 / {
-	model = "Atmel AT91SAM9G25-EK";
+	model = "Atmel AT91SAM9G15-EK";
 	compatible = "atmel,at91sam9g15ek", "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
 };


