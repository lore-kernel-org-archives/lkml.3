Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab3FEWLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:11:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab3FEVfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 010/127] ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition
Date: Wed,  5 Jun 2013 14:32:57 -0700
Message-Id: <20130605213219.208003537@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris BREZILLON <b.brezillon@overkiz.com>

commit f6d35d67d0a5c159f767a20f4fcc1d295a7314b1 upstream.

The PA24 pin is wrongly assigned to peripheral B.
In the current config there is 2 ETX3 pins (PA11 and PA24) and
no ETXER pin (PA22).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9260.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


