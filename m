Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab3CEEBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:01:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60007 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab3CEEBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:01:38 -0500
X-AuditID: cbfee68d-b7f636d0000009be-41-51356e205f88
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] twl4030_charger: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 13:01:36 +0900
Message-id: <005a01ce1956$21f306a0$65d913e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ZViHZJpbC2ArySBGXIYqICSLLiw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t8zI13FPNNAg08FFpd3zWFzYPT4vEku
	gDGKyyYlNSezLLVI3y6BK6Pr3xS2gv0cFee2zWNpYNzC3sXIwSEhYCLxYJ1PFyMnkCkmceHe
	erYuRi4OIYFljBIXf95ggkiYSPx984QJIrGIUWLLrNeMEM5sJonvL5awgFSxCahJfPlymB3E
	FhHQkGhbPQUsziyQL3H40GUwW1jARWLlxZtgU1kEVCW6pywAq+cVsJWYtOooE4QtKPFj8j0W
	kOuYBXQkvk6KgBijLfHk3QVWiKPVJR791YXYpCcxcz/EVmYBEYl9L94xQtzczi7x6ZwGxCYB
	iW+TD7FAtMpKbDrADFEiKXFwxQ2WCYxis5DsnYWwdxaSvbOQLFjAyLKKUTS1ILmgOCm9yFCv
	ODG3uDQvXS85P3cTIyRCencw3j5gfYgxGWj7RGYp0eR8YITllcQbGhubmJmYmphbmpqbkias
	JM4rd0kmUEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjbtjXOjfVEOVEF6bnMY99JjkXGU5h
	SXZrnPrLVIkvf8+DS3dl3P7OO/T0mLF0VN/z/aKzLws9sbytPS9As8tqhczFefqWJ5wuZknv
	7lhwh+1a4R4DsR0BM41kHp43u8g5yXCeVPIH9/tGlrL/i6+Zu+vp+izPuz/nwfRZWr2sAW28
	p808FiQqsRRnJBpqMRcVJwIA2asTNaYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAV2FPNNAg32HLC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRte/KWwF+zkqzm2bx9LA
	uIW9i5GTQ0LAROLvmydMELaYxIV769m6GLk4hAQWMUpsmfWaEcKZzSTx/cUSFpAqNgE1iS9f
	DoN1iwhoSLStngIWZxbIlzh86DKYLSzgIrHy4k2wqSwCqhLdUxaA1fMK2EpMWnWUCcIWlPgx
	+R5QPQdQr47E10kREGO0JZ68u8AKEpYQUJd49FcXYpOexMz9EFuZBUQk9r14xziBUWAWkkGz
	EAbNQjJoFpKOBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/CZ1A7GlQ0WhxgFOBiV
	eHgZjpoECrEmlhVX5h5ilOBgVhLhvc9rGijEm5JYWZValB9fVJqTWnyIMRnozYnMUqLJ+cAE
	kVcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGDUWbi3j9quL
	1tp8Psgx651uYmTMux6vHyz8h3yDRLZv8GyKYOJc4LF43qPOu/6POV6+uHTCYeL74xphecdN
	Zl+w3np+y5wZ129kaTg4Tb7+uKDv5WYJrqb97E4pm12Cpvru/LdbRzbA1s3pdCvDCxXBf9/F
	Aq5kXj0btvqE/0u95N0vd1aGKCmxFGckGmoxFxUnAgDgUy7GBgMAAA==
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
 drivers/power/twl4030_charger.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index a69d0d1..bed4581 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -636,17 +636,7 @@ static struct platform_driver twl4030_bci_driver = {
 	.remove	= __exit_p(twl4030_bci_remove),
 };
 
-static int __init twl4030_bci_init(void)
-{
-	return platform_driver_probe(&twl4030_bci_driver, twl4030_bci_probe);
-}
-module_init(twl4030_bci_init);
-
-static void __exit twl4030_bci_exit(void)
-{
-	platform_driver_unregister(&twl4030_bci_driver);
-}
-module_exit(twl4030_bci_exit);
+module_platform_driver_probe(twl4030_bci_driver, twl4030_bci_probe);
 
 MODULE_AUTHOR("Gra¾vydas Ignotas");
 MODULE_DESCRIPTION("TWL4030 Battery Charger Interface driver");
-- 
1.7.2.5


