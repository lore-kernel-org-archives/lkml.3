Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3H0BTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:19:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab3H0BHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 07/74] ARM: at91: at91sam9x5 RTC is not compatible with at91rm9200 one
Date: Mon, 26 Aug 2013 18:08:05 -0700
Message-Id: <20130827010426.085528415@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 23fb05c688a8dcb0cf6a4d8d819cffeca82e5c54 upstream.

Due to a bug with RTC IMR, we cannot consider at91sam9x5 RTC compatible
with the previous one. Modify DT compatibility string, even if the driver
is not yet modified to take it into account.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91sam9x5.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -643,7 +643,7 @@
 			};
 
 			rtc@fffffeb0 {
-				compatible = "atmel,at91rm9200-rtc";
+				compatible = "atmel,at91sam9x5-rtc";
 				reg = <0xfffffeb0 0x40>;
 				interrupts = <1 4 7>;
 				status = "disabled";


