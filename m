Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab3CECDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:03:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27805 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab3CECD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:03:29 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-95-51355266e238
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
In-reply-to: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
Subject: [PATCH 2/3] misc: atmel_pwm: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 11:03:18 +0900
Message-id: <004c01ce1945$9b253db0$d16fb910$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ZRXktbgD8B1v7QgSgtGTX79fL8QAAAYEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ920INNAgxVfLC3+TjrGbtG8eD2b
	xeWFl1gtLu+aw+bA4vH71yRGj/1z17B79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8a7Tc/Z
	C2awV0w7lt3AOIGti5GTQ0LAROLFlJksELaYxIV764HiXBxCAssYJfY9PMQOU3Ri4xpGEFtI
	YDqjxN2zOhBFvxgl/jdfBCtiE1CT+PLlMJgtIhAh0dLaDNTAwcEs4CJxdJoIRK+tRMudH2Bz
	OAXsJE5tmMYKYgsLeEhcObaPCcRmEVCV6NzdwQLSygtU/3GGMEiYV0BQ4sfke2B3MgtoSWze
	1sQKYctLbF7zlhmkXEJAXeLRX12IA4wkZkxYxw5RIiKx78U7RpCLJQTOsUtsP/KCDWKVgMS3
	yYdYIHplJTYdYIb4VlLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJjveLE
	3OLSvHS95PzcTYyQeOzfwXj3gPUhxmSg9ROZpUST84HxnFcSb2hsbGJmYmpibmlqbkqasJI4
	r/wlmUAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDlsZ/3r7nj+8zPnVTtodyoumXfROhnz
	b/LnLzNp7VdxXmNzcx6DrWzvkutzYjnPv1h7Zh3r4lml+9n0Ti+Y36vS05fUYbf00e1z9ydK
	ctw+dS9za0/epySJPE+NO5+vHeB5/8XNXMHwwouoHTvrvzN5Rpb2Psk9+sgj9XqiIEOcUYOv
	mIj9NSWW4oxEQy3mouJEAO5GZWXdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd20INNAg+vnTC3+TjrGbtG8eD2b
	xeWFl1gtLu+aw+bA4vH71yRGj/1z17B79G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGu03P2QtmsFdMO5bdwDiBrYuRk0NCwETixMY1jBC2mMSFe+vB
	4kIC0xkl7p7V6WLkArJ/MUr8b77IDpJgE1CT+PLlMJgtIhAh0dLaDNTMwcEs4CJxdJoIRK+t
	RMudH2AzOQXsJE5tmMYKYgsLeEhcObaPCcRmEVCV6NzdwQLSygtU/3GGMEiYV0BQ4sfkeywg
	NrOAlsTmbU2sELa8xOY1b5lByiUE1CUe/dWFOMBIYsaEdewQJSIS+168Y5zAKDQLyaRZSCbN
	QjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/2Z1A7GlQ0WhxgFOBiVeHgZ
	jpoECrEmlhVX5h5ilOBgVhLhvc9rGijEm5JYWZValB9fVJqTWnyIMRnoz4nMUqLJ+cBElFcS
	b2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGNcXHu1/f+ubW7qK
	GpOardGVP2qTZr3kfjNJSI0rsiQ6WXWnT+VDiZ/VstHz7/8yn39z1YTkx0o6/ra+flbTTJw0
	hGY1+l5qSlloYfJ1U9aE2p8Xd/D1eD6OWbN29q1XkUx/ij6uaJwUckMtj33OgzvqZ0pVv1XI
	/Lii8X9j5NZ/PvWTD1ox/VViKc5INNRiLipOBABLRDg1OgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/atmel_pwm.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 28f5aaa..494d050 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -393,17 +393,7 @@ static struct platform_driver atmel_pwm_driver = {
 	 */
 };
 
-static int __init pwm_init(void)
-{
-	return platform_driver_probe(&atmel_pwm_driver, pwm_probe);
-}
-module_init(pwm_init);
-
-static void __exit pwm_exit(void)
-{
-	platform_driver_unregister(&atmel_pwm_driver);
-}
-module_exit(pwm_exit);
+module_platform_driver_probe(atmel_pwm_driver, pwm_probe);
 
 MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


