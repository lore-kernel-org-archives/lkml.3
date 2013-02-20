Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490Ab3BTCxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:53:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39119 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab3BTCxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:53:38 -0500
X-AuditID: cbfee691-b7f556d000001a24-26-51243ab0967e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ce0e3b$f1d99170$d58cb450$%han@samsung.com>
 <20130219121801.GB23508@opensource.wolfsonmicro.com>
In-reply-to: <20130219121801.GB23508@opensource.wolfsonmicro.com>
Subject: [PATCH v2] mfd: wm8994: silence bogus warning in wm8994_device_init()
Date: Wed, 20 Feb 2013 11:53:36 +0900
Message-id: <007101ce0f15$7a726410$6f572c30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Omy0efnQv5bXqQ9qplHdDUDc+8wAeiGEA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY90NViqBBsu3q1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M1R8nsBfc4ajY0ryIpYFxDXsXIyeHhICJxJpje1ghbDGJC/fW
	s3UxcnEICSxjlPi35BQjTNG6CctYIRLTGSV2tV1lhHBmM0msWfINrIpNQE3iy5fDQGM5OEQE
	zCR+HuQBqWEWmMooMeX7GyaQGiGBEoltrx6wgNicAo4SjQeugZ0hLOAn8ebWZzYQm0VAVeL+
	wblgcV4BW4lfB46wQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhlkr4SAusSjv7ogYREBI4nd
	829AlYhI7HvxDuxmCYFl7BLrNuxihtglIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9C
	snkWks2zkKxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMktibuYLx/wPoQYzLQ+onM
	UqLJ+cDYzCuJNzQ2NjEzMTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGxubmA49Kdss9mOjs3vfYqzjd7q5P9ZffHttXHDA4tmiGburrx/sit38tn8qyY05638u9
	8Uwl2nekEizWZj5YnHPDKWC+0a53JztfH568+uX2N9PVvfuyb3Fd5VT7bJdbv2iy2+XmM3HZ
	boGSM89NkbZ/9rdR0sZymYJpYkNFiED8RC0/RevjMkosxRmJhlrMRcWJAPLI16LDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO4GK5VAg6udShaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/XHCewFdzgqtjQvYmlg
	XMPexcjJISFgIrFuwjJWCFtM4sK99WxdjFwcQgLTGSV2tV1lhHBmM0msWfKNEaSKTUBN4suX
	w0DdHBwiAmYSPw/ygNQwC0xllJjy/Q0TSI2QQInEtlcPWEBsTgFHicYD18C2CQv4Sby59ZkN
	xGYRUJW4f3AuWJxXwFbi14EjLBC2oMSPyffAbGYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8u
	SFhEwEhi9/wbUCUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxgiP3mfQOxlUNFocYBTgYlXh4GxYqBwqxJpYVV+YeYpTgYFYS4XVnVQkU4k1J
	rKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgUskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0
	xJLU7NTUgtQimC1MHJxSDYzBH2d811H6ExfMlKErsMFd4NKr3gIOHT5nn7U/Oc73692eqXvW
	3sLneKOkVU2XQv65ruTMd7NenfbPEX1yi3nWlJfTZMOvKUjeuzRBZxfH9tjvJ4texvT2hJSd
	vHxgKitr2tosnXS7OEXDiSLhOWW8SwO33hRsUgsRtLOffW9DqPaKHY4Cc5VYijMSDbWYi4oT
	AUFuaF0gAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'patch_regs' cannot be used uninitialized in wm8994_device_init(),
because 'patch_regs' was already guarded by 'regmap_patch'.
Thus, that's a bogus warning.

Without this patch, the build warning happens as below:

drivers/mfd/wm8994-core.c: In function 'wm8994_i2c_probe':
drivers/mfd/wm8994-core.c:595:7: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]
drivers/mfd/wm8994-core.c:408:14: note: 'patch_regs' was declared here

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/wm8994-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 803e93f..97e929e 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -405,7 +405,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	struct regmap_config *regmap_config;
 	const struct reg_default *regmap_patch = NULL;
 	const char *devname;
-	int ret, i, patch_regs;
+	int ret, i, patch_regs = 0;
 	int pulls = 0;
 
 	if (dev_get_platdata(wm8994->dev)) {
-- 
1.7.2.5


