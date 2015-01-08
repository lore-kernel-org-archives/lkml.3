Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbbAHBEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:04:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60304 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbbAHBEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:04:48 -0500
X-AuditID: cbfee691-f79b86d000004a5a-8a-54add7ab6461
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [RESEND PATCH] mfd: wm8994: set mfd id-base for regulator
 devs creation to avoid conflicts
Date: Thu, 08 Jan 2015 10:04:33 +0900
Message-id: <1420679073-3316-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkQHf19bUhBr+2m1hcuXiIyWLqwyds
	Fv+m3GC32PX3PqPF/a9HGS2+Xelgsri8aw6bxfK3/9ksTnezOnB6bPjcxOaxc9Zddo9NqzrZ
	PO5c28PmMe9koMfLib/ZPPq2rGL0+LxJLoAjissmJTUnsyy1SN8ugSvj7qMJrAVfOCu+T73E
	3MD4mb2LkZNDQsBE4umJ7YwQtpjEhXvr2boYuTiEBJYySvx7sYIJpujZsjksEIlFjBIHdq1j
	hXDmMEnMOfGAFaSKTUBD4vvnzcwgtohAhsTiD5fARjELLGSUeLLnMViRsECRxLyzN8BsFgFV
	iWdHd7OB2LwCrhKf/i5ihVinLbGvYSYbhL2MXWLfUhaIegGJb5MPAdkcQHFZiU0HmCFKJCUO
	rrjBMoFRcAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwDA//e/ZxB2M9w9YH2IU4GBU
	4uEt6FsTIsSaWFZcmXuI0RRow0RmKdHkfGA05ZXEGxqbGVmYmpgaG5lbmimJ8+pI/wwWEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwKi0UNFUsy3a+6yKsoz4fr1dpQrd2x/M3Pvt4iYVrUNs
	AQuvhN7jiHX6s0Fu0anfj+2Onkzp2/m+fuHu1Rr+OoUfFJm835XnGFfozvzFGLPy8mQGhrsS
	s7zamswnzvOZ0Fizc4eAvt/7bq47TxxCZJnXtMme8rGtDpeNe7dkzbJnnO8fbdY78EaJpTgj
	0VCLuag4EQBj/DmhbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jAd3V19eGGKx/pGNx5eIhJoupD5+w
	WfybcoPdYtff+4wW978eZbT4dqWDyeLyrjlsFsvf/mezON3N6sDpseFzE5vHzll32T02repk
	87hzbQ+bx7yTgR4vJ/5m8+jbsorR4/MmuQCOqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hT
	MwNDXUNLC3MlhbzE3FRbJRefAF23zByg85QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYE
	wfUYGaCBhDWMGXcfTWAt+MJZ8X3qJeYGxs/sXYycHBICJhLPls1hgbDFJC7cW8/WxcjFISSw
	iFHiwK51rBDOHCaJOScesIJUsQloSHz/vJkZxBYRyJBY/OESWAezwEJGiSd7HoMVCQsUScw7
	ewPMZhFQlXh2dDcbiM0r4Crx6e8iVoh12hL7GmayTWDkXsDIsIpRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjOI6eSe9gXNVgcYhRgINRiYe3oG9NiBBrYllxZe4hRgkOZiUR3q6za0OEeFMS
	K6tSi/Lji0pzUosPMZoCbZ/ILCWanA+M8bySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU
	7NTUgtQimD4mDk6pBsZ1B5b2im9VFZ3Ds1Bc6aou7yfltTsn/rQVufUxUj78b7oWV9ek2QeT
	W1bPF3Gp2/nlC5v4/4j4HOfzKpZMVw7efbf1/6/3UkLifREeWzf2pK+M0tQ8KnVXNSiSudI+
	Pljpw8RjK5n1mhd8embZ8mD2xdNCDfI/bH4W9531vf03M9rSfdGh7BwlluKMREMt5qLiRACr
	wJeQuQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit: 6e3f62f0793e ("mfd: core: Fix platform-device id generation")
We must set the id base when register a duplicate name of mfd_cell.
If not, duplicate filename error was reported.

- sysfs: cannot create duplicate filename '/devices/.../wm8994-ldo'

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 drivers/mfd/wm8994-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index e6fab94..47cd3cc 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -36,12 +36,12 @@
 static const struct mfd_cell wm8994_regulator_devs[] = {
 	{
 		.name = "wm8994-ldo",
-		.id = 1,
+		.id = 0,
 		.pm_runtime_no_callbacks = true,
 	},
 	{
 		.name = "wm8994-ldo",
-		.id = 2,
+		.id = 1,
 		.pm_runtime_no_callbacks = true,
 	},
 };
@@ -344,7 +344,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	dev_set_drvdata(wm8994->dev, wm8994);
 
 	/* Add the on-chip regulators first for bootstrapping */
-	ret = mfd_add_devices(wm8994->dev, -1,
+	ret = mfd_add_devices(wm8994->dev, 0,
 			      wm8994_regulator_devs,
 			      ARRAY_SIZE(wm8994_regulator_devs),
 			      NULL, 0, NULL);
-- 
2.0.0.390.gcb682f8

