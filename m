Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaJ0P3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:29:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48572 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaJ0P3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:29:35 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-11-544e64ddb69a
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
Subject: [PATCH 7/8] mfd/regulator: dt-bindings: max77686: Document gpio
 property
Date: Mon, 27 Oct 2014 16:03:45 +0100
Message-id: <1414422226-10948-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7p3U/xCDNbs57HYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBb3P96lNHi25UOJotNj6+xWlze
	NYfNYsb5fUwWty/zWqw9cpfd4nQ3q4OgR0tzD5vH3+fXWTz+rnrB7LFz1l12j02rOtk87lzb
	w+Yx72Sgx+Yl9R59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVcW/OD9aCx2wVS343sTcw3mHt
	YuTkkBAwkXi+7DkzhC0mceHeerYuRi4OIYGljBKft65lBEkICfQxSez4pAFiswkYS2xevgSs
	SESgk1mi52AvM4jDLLCaSeLnlVNgo4QFgiWun30AZrMIqErs6/nC1MXIwcEr4C6xYJspxDY5
	iZPHJoNdwSngIfH6/ldmiGXuEp/fb2WcwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7u
	JkZIgH/Zwbj4mNUhRgEORiUe3h3TfEOEWBPLiitzDzFKcDArifCeCvALEeJNSaysSi3Kjy8q
	zUktPsTIxMEp1cA47fizOc0tcavCYueasPJs7f2t4PTr+rFS1ef/HqxdOGXFqkc/btxNf/1T
	3an0wM68+/18q9J3V03w5dTTvGZ18RHn+RdNGpzr5gUvu3Em9cbdnFDhf1EzukVKD/382RDD
	ZXM8pXzpH4GLe729z+svnPgtc/rt5mWNjBNfcq2oSn0+KfWMn9FDJyWW4oxEQy3mouJEAEXv
	N7VOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document usage of gpio property which turns on external control over
regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index 75fdfaf41831..e41dfa7e2b90 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -39,6 +39,9 @@ to get matched with their hardware counterparts as follow:
 	-BUCKn	:	1-4.
   Use standard regulator bindings for it ('regulator-off-in-suspend').
 
+  Optional properties:
+  - gpio : GPIO to use for external control. Valid only for LDO20, LDO21,
+    LDO22, BUCK8 and BUCK9 regulators.
 
 Example:
 
-- 
1.9.1

