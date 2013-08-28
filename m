Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3H1FzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:55:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42868 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3H1Fy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:54:59 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-6a-521d90b10021
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Chris Ball'" <cjb@laptop.org>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
In-reply-to: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
Subject: [PATCH 4/5] mfd: tc6393xb: Remove .set_pwr() callback
Date: Wed, 28 Aug 2013 14:54:57 +0900
Message-id: <000c01cea3b3$20282b60$60788220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jssAlip17A5gXTNKNBqRYWYD+6gAAFIWg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zfd2NE2SDDOZOULbY/nojm8X7jfOY
	LPY1PWexuLzwEqvFxKY7LBb3vx5ltLi8aw6bxeluVgcOj7/Pr7N4fPgY5zG7Yyarx6Eraxk9
	7lzbw+Yx72SgR9+WVYwenzfJBXBEcdmkpOZklqUW6dslcGWcWXaXsWAJX8XMe+1sDYwzeboY
	OTgkBEwktrSwdzFyApliEhfurWfrYuTiEBJYxiixvXshVMJEYu3Uk1CJRYwSOz9dYYVwfjFK
	nF7xmhWkik1ATeLLl8PsIFNFBPwkGlawg9QwC7QzSfyesYANpEZIwFbibG8rC4jNKWAncaL9
	JiNIvTCQva01ASTMIqAqMWPDAbCRvEDl+2fvYoOwBSV+TL4H1sosoCWxfudxJghbXmLzmrfM
	EM+oSzz6qwsSFhEwktgy9SI7RImIxL4X7xhBzpEQ6OSQWLTtOzvELgGJb5MPsUD0ykpsOsAM
	8a+kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsY
	IdHdu4Px9gHrQ4zJQOsnMkuJJucDk0NeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhgFDi26c4S/etqKJzc42A1ONO/7Yn3SaL11M7+gMkvSBLtO
	N+61rAESYgurfG4WbM/WVXh+8tOmPX9PiTnb/9xQvCT9c18hU/mjn7dWF5pmboiV4Msrcd0s
	cDaw7vnP+1mJj6TkLPTv8J2wWX/BwnSdhbtNhbtH2Kv8u6fqO+unbPaxOrXjXa8SS3FGoqEW
	c1FxIgC34yGZBAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jAd2NE2SDDJbvl7PY/nojm8X7jfOY
	LPY1PWexuLzwEqvFxKY7LBb3vx5ltLi8aw6bxeluVgcOj7/Pr7N4fPgY5zG7Yyarx6Eraxk9
	7lzbw+Yx72SgR9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGPMOLPsLmPBEr6Kmffa2RoYZ/J0MXJySAiYSKydepINwhaTuHBvPZDNxSEksIhRYuenK6wQ
	zi9GidMrXrOCVLEJqEl8+XKYvYuRg0NEwE+iYQU7SA2zQDuTxO8ZC8AmCQnYSpztbWUBsTkF
	7CROtN9kBKkXBrK3tSaAhFkEVCVmbDgANpIXqHz/7F1sELagxI/J98BamQW0JNbvPM4EYctL
	bF7zlhlkjISAusSjv7ogYREBI4ktUy+yQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4ez6R3MK5qsDjEKMDBqMTDa7FZJkiINbGsuDL3
	EKMEB7OSCG/Jf6AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wMTW15JvKGxiZmRpZGZhZGJ
	uTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MEZ8mu17KeGbbEiX8/bgrXNmb517/wv7
	/EcfdV727/ttsqfLM32StWn2gXguhUU+V+4ZT/3bN+HRuyvzL0yt2L2qr9k64YjhA7fjh0wf
	Hjj5pqHu5ZZavp4vW9d81pvRbxdwZwK/5PSfE0MvHNkTnjGriK/xeN/1Wx7atatb35xYy3vt
	xk4/7/V2SizFGYmGWsxFxYkAq+99SmIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
platform data", .set_pwr() callback is removed from platform data.
Thus, .set_pwr() is not used anymore. Also, this patch fixes
the following build error and warning.

drivers/mfd/tc6393xb.c:381:2: error: unknown field 'set_pwr' specified in initializer
drivers/mfd/tc6393xb.c:381:2: warning: initialization makes integer from pointer without a cast [enabled by default]
drivers/mfd/tc6393xb.c:381:2: warning: (near initialization for 'tc6393xb_mmc_data.capabilities' [enabled by default]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian.molton@collabora.co.uk>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mfd/tc6393xb.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 11c19e5..7c5c351 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -360,14 +360,6 @@ static int tc6393xb_mmc_resume(struct platform_device *mmc)
 	return 0;
 }
 
-static void tc6393xb_mmc_pwr(struct platform_device *mmc, int state)
-{
-	struct platform_device *dev = to_platform_device(mmc->dev.parent);
-	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
-
-	tmio_core_mmc_pwr(tc6393xb->scr + 0x200, 0, state);
-}
-
 static void tc6393xb_mmc_clk_div(struct platform_device *mmc, int state)
 {
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
@@ -378,7 +370,6 @@ static void tc6393xb_mmc_clk_div(struct platform_device *mmc, int state)
 
 static struct tmio_mmc_data tc6393xb_mmc_data = {
 	.hclk = 24000000,
-	.set_pwr = tc6393xb_mmc_pwr,
 	.set_clk_div = tc6393xb_mmc_clk_div,
 };
 
-- 
1.7.10.4


