Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaHMLxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:53:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13564 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaHMLxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:53:14 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-2f-53eb51a81e04
Date: Wed, 13 Aug 2014 20:53:13 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v2 1/2] mfd: arizona: Add support for INn_Mode
 register control
Message-id: <20140813205313.65bbe343@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkRHdl4Otgg5ZFjBZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGWc2vmUreAWV8WeOxfZGhivcXQx
	cnJICJhILH0+iRXCFpO4cG89G4gtJLCUUeLzngiYmi+7/zB2MXIBxaczSty88IQFwulnklh3
	pocdpIpFQFXi2p5+RhCbTUBD4vvnzcwgtgjQ1NtzOplBGpgFfjJJNK94ApYQFoiT6FrUANbA
	K+Aqcf76PSaIdTYSq3euY4aIC0r8mHyPBcRmFtCS2LytiRXClpfYvOYt2FAJgZkcEtsvL2GD
	uEJA4tvkQ0ANHEAJWYlNB5ghZkpKHFxxg2UCo8gsJGNnIRk7C8nYBYzMqxhFUwuSC4qT0osM
	9YoTc4tL89L1kvNzNzECI/r0v2e9OxhvH7A+xJgMtHIis5Rocj4wIeSVxBsamxlZmJqYGhuZ
	W5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Nx89HDEyIXbPqQJNL7+7XB
	vWWWmw1l/f4l/Hlhfadp/e2ja1ft+32Ne7LlzxmnLhz57Bmv/O5RxkR1pZ8r9H5rLDD6G/5R
	IefE9RXHLzS/UfwjeTB8j7e/Z7aZUETribaZc076b9Ra+6S84SZP3dXfl7ZcuHvvdvzajHxJ
	5TW9XlsKbe2Pfet4o8RSnJFoqMVcVJwIAPxfqjv+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd0Vga+DDT7sNrW4cvEQk8XUh0/Y
	LP5NucFucf3Lc1aL+UfOsVr0v1nIanHu1UpGi/tfjzJafLvSwWRxedccNoul1y8yWSx/+5/N
	YsL0tSwWrXuPsFuc7mZ14PfY8LmJzWPNvDWMHpf7epk8ds66y+6xcvkXNo9NqzrZPO5c28Pm
	Me9koMfLib/ZPPq2rGL0+LxJLoA7qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DS
	wlxJIS8xN9VWycUnQNctMwfoFyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmgg
	YQ1jxqmdT9kKbnFV7Llzka2B8RpHFyMnh4SAicSX3X8YIWwxiQv31rN1MXJxCAlMZ5S4eeEJ
	C4TTzySx7kwPO0gVi4CqxLU9/WAdbAIaEt8/b2YGsUWAum/P6WQGaWAW+Mkk0bziCVhCWCBO
	omtRA1gDr4CrxPnr95gg1tlIrN65jhkiLijxY/I9FhCbWUBLYvO2JlYIW15i85q3zBMY+WYh
	KZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYITxjPpHYyrGiwOMQpwMCrx
	8O5wfRUsxJpYVlyZe4hRgoNZSYT3sM3rYCHelMTKqtSi/Pii0pzU4kOMpkBvT2SWEk3OByaz
	vJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjMqRIRyHLsScZ67n
	5Sme6HV2rk6OWvCdCQZPX99+cJgleefyxazFh1W7NZW/ML5ctv+2+QFu8YJvBYJBV2Za2Uws
	c322z2nd2Q0nXafVNn+yC9BfEm19fpfUiz2T96fHVSZ8/rrrre/3C4wZccnvjmfP0tnz9LOY
	0Nm23EvXdpq8unYwI4/d3kOJpTgj0VCLuag4EQCTN/K/LgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards need to set the INn_MODE[1:0] register to change
the input signal patch. This wlf,inmode property is optional.
If present values must be specified by the number of
ARIZONA_MAX_INPUT.

Example:
   - wlf,inmode = <2 0 2 0>;	/* IN1, IN3 use DMIC */

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 drivers/mfd/arizona-core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 10a0cb9..2b68ccd 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
 static int arizona_of_get_core_pdata(struct arizona *arizona)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
-	int ret, i;
+	int ret, i, proplen;
 
 	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
 
@@ -560,6 +560,15 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 			ret);
 	}
 
+	proplen = of_property_count_u32_elems(arizona->dev->of_node,
+					      "wlf,inmode");
+	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode)) {
+		for (i = 0; i < proplen; i++)
+			of_property_read_u32_index(arizona->dev->of_node,
+						   "wlf,inmode", i,
+						    &arizona->pdata.inmode[i]);
+	}
+
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8

