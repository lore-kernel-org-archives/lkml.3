Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaBQIks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:40:48 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37664 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaBQIkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:40:43 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c7-5301cb09fada
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v3 07/13] regulator: s2mps11: Constify regulator_desc array
Date: Mon, 17 Feb 2014 09:40:21 +0100
Message-id: <1392626427-4518-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
References: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7qcpxmDDeZcs7LYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eL+16OMFt+udDBZXN41h81ixvl9TBZrj9xltzjdzWpxccUXJov1M16zWMyZ
	/o7Jgddj56y77B6bVnWyedy5tofNY97JQI++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKWHxQ
	t2AyW8Xya1fYGxhns3YxcnJICJhITNw+HcoWk7hwbz1bFyMXh5DAUkaJ7k/bGSGcPiaJy43T
	WUCq2ASMJTYvXwJWJSKwmVFi8ferrCAOs8BDJolVX2azgVQJC3hLfFvczNzFyMHBIqAq0b6k
	CiTMK+AmsXXOLhaQsISAgsScSTYgYU4Bd4mnfVNZQcJCQCX7N4ZNYORdwMiwilE0tTS5oDgp
	PddIrzgxt7g0L10vOT93EyMkJL/uYFx6zOoQowAHoxIPr0E1Y7AQa2JZcWXuIUYJDmYlEV7b
	dUAh3pTEyqrUovz4otKc1OJDjEwcnFINjCknd0TydS7auuJZy6Ff5zqYFMw6l96ee+3idrkd
	nSu/KT26vJhXWbAse1FhnoORToXM++0TorOfR+Rs4Vvz8nZu1NK1qncTZqfH77xgU3LktMKB
	5/8i10+Z9TQvyHPy5TPbuH4Kvt1ZeLqStfDH4R09s7RXrxE6PGFS0ZMtyxeo/J8jJOp24X2x
	EktxRqKhFnNRcSIAGv+JgicCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constify the regulator_desc 'regulators' array.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 drivers/regulator/s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index acdd3b92b8d6..caf3977761e7 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -343,7 +343,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	regulator_desc_ldo2(1),
 	regulator_desc_ldo1(2),
 	regulator_desc_ldo1(3),
-- 
1.7.9.5

