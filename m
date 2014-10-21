Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaJULYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:24:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28485 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbaJULYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:24:02 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-23-5446424f4ff0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 3/4] mfd/regulator: dt-bindings: max77686: Document
 regulators off in suspend
Date: Tue, 21 Oct 2014 13:23:16 +0200
Message-id: <1413890597-31037-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xK7r+Tm4hBpd+aFpsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac
	38dkcfsyr8XaI3fZHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGX8OTKDseAle8WtSf0sDYxn2boYOTkkBEwkFrbvY4KwxSQu3FsP
	FhcSWMoo8eOjbRcjF5DdxyTx9PgJsCI2AWOJzcuXgBWJCOxnkng8wQSkiFlgNZPEzyunmEES
	wgJJEk2dk9lBbBYBVYl1nRtZuxg5OHgF3CXedmtALJOTOHlsMiuIzSngIXHnegc7xGJ3idUH
	57BOYORdwMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkdL/sYFx8zOoQowAHoxIP74Zl
	riFCrIllxZW5hxglOJiVRHhzhd1ChHhTEiurUovy44tKc1KLDzEycXBKNTC2OXrpZp5N03D7
	t+T6O4nH8xzafOaduXg70Le/1pbTbMpjj3P6FeJ/zgnz+rsYGkdVfT1QNn2JiN+iuTXnfi2Y
	e6LYNuZx18TMsJg1fbM2qAQHa6olF5Ut3Va+eRnj4mX3uipumB5O0WhwvbIoxk5ny9OsfxoP
	NW79vaeY/fSF9KOtoS+28HIosRRnJBpqMRcVJwIASAFnkzsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information which regulators can be disabled during system suspend.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index 678f3cf0b8f0..75fdfaf41831 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -34,6 +34,12 @@ to get matched with their hardware counterparts as follow:
 	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 9.
 			example: BUCK1, BUCK5, BUCK9.
 
+  Regulators which can be turned off during system suspend:
+	-LDOn	:	2, 6-8, 10-12, 14-16,
+	-BUCKn	:	1-4.
+  Use standard regulator bindings for it ('regulator-off-in-suspend').
+
+
 Example:
 
 	max77686@09 {
-- 
1.9.1

