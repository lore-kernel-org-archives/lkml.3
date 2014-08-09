Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaHIIbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 04:31:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56314 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaHIIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 04:31:42 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-4f-53e5dc6b2295
Date: Sat, 09 Aug 2014 17:31:38 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH 1/2] mfd: arizona: Add support for INn_MODE
 register control
Message-id: <20140809173138.767b97fd@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkQDf7ztNgg/O3ZS2uXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+CO4rJJSc3JLEst0rdL4Mro2X2BreABW0V35wG2BsYDrF2M
	nBwSAiYST172M0LYYhIX7q1nA7GFBJYySrx+4wdTs3rHNvYuRi6g+CJGiYYnq5ggnH4micVz
	3oF1sAioSnx50wM2iU1AQ+L7583MILYI0NTbczqZQRqYBX4ySTSveAKWEBaIluhcsg+smVfA
	VWLX/7XsEOtsJFbvXMcMEReU+DH5HguIzSygJbF5WxMrhC0vsXnNW7ChEgJTOSSe7znBBHGF
	gMS3yYeAGjiAErISmw4wQ8yUlDi44gbLBEaRWUjGzkIydhaSsQsYmVcxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525iBEb06X/P+nYw3jxgfYgxGWjlRGYp0eR8YELIK4k3NDYzsjA1MTU2Mrc0
	I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M07VOhWSJnGZZsrml9s92htbu
	xoUNwW+nx6t7Oc60mHmU+dfNzQKnt0RoTV3ZrHwz6r39N/nvVn+W9zldl41v/l/2PueIkajV
	vy2LF6ndFvYsMUve+6beXqPlRopxhh1Dk+I5/9yj/ZIaaxK+ibFzz49rKo8wsPLY0JxmzZxk
	s7ixTKN7LZcSS3FGoqEWc1FxIgBdjMKV/gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd3sO0+DDT5sELW4cvEQk8XUh0/Y
	LP5NucFucf3Lc1aL+UfOsVr0v1nIanHu1UpGi/tfjzJafLvSwWRxedccNoul1y8yWSx/+5/N
	YsL0tSwWrXuPsFuc7mZ14PfY8LmJzWPNvDWMHpf7epk8ds66y+6xcvkXNo9NqzrZPO5c28Pm
	Me9koMfLib/ZPPq2rGL0+LxJLoA7qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DS
	wlxJIS8xN9VWycUnQNctMwfoFyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmgg
	YQ1jRs/uC2wFD9gqujsPsDUwHmDtYuTkkBAwkVi9Yxs7hC0mceHeerYuRi4OIYFFjBINT1Yx
	QTj9TBKL57xjA6liEVCV+PKmhxHEZhPQkPj+eTMziC0C1H17TiczSAOzwE8mieYVT8ASwgLR
	Ep1L9oE18wq4Suz6vxZqnY3E6p3rmCHighI/Jt9jAbGZBbQkNm9rYoWw5SU2r3nLPIGRbxaS
	sllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhhPJPewbiqweIQowAHoxIP
	7wqbp8FCrIllxZW5hxglOJiVRHiDzwGFeFMSK6tSi/Lji0pzUosPMZoCvT2RWUo0OR+YzPJK
	4g2NTcyMLI3MDS2MjM2VxHkPtloHCgmkJ5akZqemFqQWwfQxcXBKNTA2znogwtdg3/fk09cX
	3HkizvNql4q+8Fj5R1D9lcbN4Ku7uVXfzohv8Gc1+Hp/RvrlGusS5pSqORNkvya4Fwm4ZxUo
	Fqzf/VVUhW9S86E/h03z792PymOaOiFsd5zUH0MpbqNb4QL7l1s85LnG8oq15ebyhx+UM/lt
	EnYceva9zD8jOiApJk2JpTgj0VCLuag4EQCRVNYwLgMAAA==
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
 drivers/mfd/arizona-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 10a0cb9..4b2eb73 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -560,6 +560,10 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 			ret);
 	}
 
+	of_property_read_u32_array(arizona->dev->of_node,
+					 "wlf,inmode",
+					 arizona->pdata.inmode,
+					 ARRAY_SIZE(arizona->pdata.inmode));
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8
