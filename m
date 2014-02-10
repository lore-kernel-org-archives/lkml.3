Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaBJBJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:09:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20034 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBJBJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:09:34 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-36-52f826c5df42
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Roland Stigge'" <stigge@antcom.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: [PATCH 2/7] ARM: lpc32xx: don't select HAVE_PWM
Date: Mon, 10 Feb 2014 10:09:25 +0900
Message-id: <003b01cf25fc$bd4b51d0$37e1f570$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAAADYDQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY92jaj+CDO581bL4O+kYu8XlhZdY
	LTY9vsZqcXnXHDaLyUvOsjqwesyZupvR4/evSYwem5fUe/RtWcXo8XmTXABrFJdNSmpOZllq
	kb5dAlfG4o+P2AsWs1Y8vP6HtYFxIUsXIyeHhICJxNlLP9ghbDGJC/fWs3UxcnEICSxjlNj0
	YAUjTNGM6zCJ6YwS035OZoVwfjFKtC+cwgxSxSagJvHly2GwUSICyhLHX95hASliFpjAKHH7
	DcQOIQFbibkN+8FsTgE7iXlLvwFN4uAQFrCQ+H3IEyTMIqAqsam5hwnE5gUq/952E8oWlPgx
	+R7Y2cwCWhLrdx5ngrDlJTavecsMMkZCQF3i0V9diBOMJF4tP8sGUSIise/FO0aQcyQEbrFL
	bNr7nglil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGyxAh89CsnkWks2zkGyehWTFAkaWVYyiqQXJ
	BcVJ6UWmesWJucWleel6yfm5mxghkTpxB+P9A9aHGJOB1k9klhJNzgdGel5JvKGxmZGFqYmp
	sZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MAYoskeqSa83dLcTtGGY
	+KFlo3eS7Ns5/+uV/Df/914m01oV+PjZO3f2jx8fRqxdzbAxu8HOmFsuey73aQf2s6v0hVVb
	03QX/nRatqNIu8P74f55mZFLAnoeJd5Qq/sTlP3+7avMeUsunu1ujmD1W3eg+VtPl4Tb0Y50
	n7a/1znlHoTUbeeXUWIpzkg01GIuKk4EAGeVjL/qAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd2jaj+CDJYeVbf4O+kYu8XlhZdY
	LTY9vsZqcXnXHDaLyUvOsjqwesyZupvR4/evSYwem5fUe/RtWcXo8XmTXABrVAOjTUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QciWFssScUqBQQGJx
	sZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxuKPj9gLFrNWPLz+h7WBcSFLFyMnh4SAicSM
	6+vZIGwxiQv3QGwuDiGB6YwS035OZoVwfjFKtC+cwgxSxSagJvHly2F2EFtEQFni+Ms7LCBF
	zAITGCVuv/kBlhASsJWY27AfzOYUsJOYt/Qb0CQODmEBC4nfhzxBwiwCqhKbmnuYQGxeoPLv
	bTehbEGJH5PvgV3HLKAlsX7ncSYIW15i85q3zCBjJATUJR791YU4wUji1fKzbBAlIhL7Xrxj
	nMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLTwDOpHYwr
	GywOMQpwMCrx8O748z1IiDWxrLgy9xCjBAezkgjvy7tAId6UxMqq1KL8+KLSnNTiQ4zJQI9O
	ZJYSTc4Hpqi8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDc
	qhy9jrmw9KF22Rc19vq2Pzlr6ubEK0zXmcBu+//XsXdbEjOCT6/ynx205yoXv6TiYhabQ7Ih
	Sxp4MsP0j/T+lP/x/7jiX9bAHnPm6F7tTb+Xbt/+cP37Ge2lAeUXM/otTyoJnbM8silEv2fV
	grl5/e4fNodpKLxk92NWuXXJ5rPN89jp3IuVWIozEg21mIuKEwHGuJuRRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. The lpc32xx
platforms use the generic PWM framework, after the commit "2132fa8
pwm: add lpc32xx PWM support".

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..897fa15 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -632,7 +632,6 @@ config ARCH_LPC32XX
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
 	select HAVE_IDE
-	select HAVE_PWM
 	select USB_ARCH_HAS_OHCI
 	select USE_OF
 	help
-- 
1.7.10.4


