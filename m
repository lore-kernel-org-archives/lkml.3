Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbaJ2PMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:12:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47969 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738AbaJ2PLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:07 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-a5-545103887c05
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
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
Subject: [PATCH v2 7/8] mfd/regulator: dt-bindings: max77686: Document gpio
 property
Date: Wed, 29 Oct 2014 16:06:45 +0100
Message-id: <1414595206-1437-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
References: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7odzIEhBhv/21hsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKuDnnNnPBM7aKu/NusDQw3mft
	YuTkkBAwkZh+5iuULSZx4d56ti5GLg4hgaWMErsX9rJDOH1MEv+2/WQBqWITMJbYvHwJWJWI
	QCezRM/BXmYQh1lgNZPEzyunmEGqhAXCJBp/TgCbyyKgKvF+4Wp2EJtXwE3i0MTlUPvkJE4e
	mwxmcwq4Syxs+cAIYgsB1bxdNollAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxgh
	Qf5lB+PiY1aHGAU4GJV4eB02BoQIsSaWFVfmHmKU4GBWEuH9/AsoxJuSWFmVWpQfX1Sak1p8
	iJGJg1OqgXFhw8ro/Re6HuR6Tnod4Bs1zWxF+qJMnpI1P87x97Jw5ESfSzgUOZ83MMWhRusG
	190Q68REgRUrPnUcdW1Ibvlzxz9d/GZT6naPiHqrS0pNsTyysTceG17e+XDqtd8rcjmi+NdJ
	8Grx98Xapf7b6jQ5cuOCdo/e/z5CN/5VbVbKmpXTUCD8W4mlOCPRUIu5qDgRAB5aACJQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document usage of gpio property which turns on external/GPIO control
over regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index 75fdfaf41831..7a62baa406a2 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -39,6 +39,9 @@ to get matched with their hardware counterparts as follow:
 	-BUCKn	:	1-4.
   Use standard regulator bindings for it ('regulator-off-in-suspend').
 
+  Optional properties:
+  - gpio : GPIO to use for enable control. Valid only for LDO20, LDO21,
+    LDO22, BUCK8 and BUCK9 regulators.
 
 Example:
 
-- 
1.9.1

