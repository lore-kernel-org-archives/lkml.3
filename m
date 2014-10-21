Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaJUNUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:20:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56684 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaJUNUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:20:11 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-99-54465d884f8c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 3/4] mfd/regulator: dt-bindings: max77686: Document
 regulators off in suspend
Date: Tue, 21 Oct 2014 15:19:54 +0200
Message-id: <1413897595-28752-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413897595-28752-1-git-send-email-k.kozlowski@samsung.com>
References: <1413897595-28752-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xy7odsW4hBh9nS1lsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKWPqHv2A9R8WThbPYGxj72bsY
	OTkkBEwk1t9+zQRhi0lcuLeerYuRi0NIYCmjxPQZu9khnD4miTeXPjODVLEJGEtsXr6EDcQW
	EehklvjyPQCkiFlgNZPEzyunwIqEBZIk5p39DLaCRUBV4lzTA1YQm1fAXeLHh89sEOvkJE4e
	mwwW5xTwkPi9ey9jFyMH0DZ3iWufUycw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJ
	ERLeX3cwLj1mdYhRgINRiYc3YolriBBrYllxZe4hRgkOZiUR3lxhtxAh3pTEyqrUovz4otKc
	1OJDjEwcnFINjIcD3uWYr13Xf0iH5dnGTdt8BKv9tbQ0Qtn3Cpad29iUfdv2qttLy7Kd11Is
	fsrtd7R4qTIn3uLMpT6jQuvIr/tkiuPMFtw4tnCiEEtkUChz6A6dHfNM3k/iDiqesMjKvMBy
	7maxmf8CTm5/u7R97tIN8vwLefiEZns2LJdYuWKj5SK9TxdiSpRYijMSDbWYi4oTAexOylZN	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information which regulators can be disabled during system suspend.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index 678f3cf0b8f0..75fdfaf41831 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -34,6 +34,11 @@ to get matched with their hardware counterparts as follow:
 	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 9.
 			example: BUCK1, BUCK5, BUCK9.
 
+  Regulators which can be turned off during system suspend:
+	-LDOn	:	2, 6-8, 10-12, 14-16,
+	-BUCKn	:	1-4.
+  Use standard regulator bindings for it ('regulator-off-in-suspend').
+
 Example:
 
 	max77686@09 {
-- 
1.9.1

