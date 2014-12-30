Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaL3MHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:07:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30847 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaL3MHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:07:20 -0500
X-AuditID: cbfee68d-f79296d000004278-82-54a29576f937
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH] mfd: wm8994: set mfd id-base for regulator devs
 creation to avoid conflicts
Date: Tue, 30 Dec 2014 21:06:51 +0900
Message-id: <1419941211-17667-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkQLd86qIQg4XzWSyuXDzEZDH14RM2
	i39TbrBb7Pp7n9Hi/tejjBbfrnQwWVzeNYfNYvnb/2wWp7tZHTg9NnxuYvPYOesuu8emVZ1s
	Hneu7WHzmHcy0OPlxN9sHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+XwJVx99EE1oIvnBXfp15i
	bmD8zN7FyMkhIWAicfTTdSYIW0ziwr31bF2MXBxCAksZJZY83MgCU9R6dDsrRGIRo0T72YXM
	EM4cJokf/bMYQarYBDQkvn/ezAxiiwg4Sjxeug9sLLPAMUaJ2Y2FILawQLbE87+TwaayCKhK
	zDvwhw3E5hVwk5i7cA8rxDZtiX0NM8HOkBBYxC7Rd62FDaJBQOLb5ENAzRxACVmJTQeYIeol
	JQ6uuMEygVFwASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAMD/971nvDsbbB6wPMQpw
	MCrx8G54vzBEiDWxrLgy9xCjKdCGicxSosn5wGjKK4k3NDYzsjA1MTU2Mrc0UxLnVZT6GSwk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB8YbtT2HZKQ239KU640rvXFyXMVHrQfP8ZovYt18/
	5IU9XMbRJtfLG+zInTDh7szJNZHVdqr3GTK7JlQfe7Xy0NWXh3cfWhu54XSK+dqEG6ZTT0SI
	/snY2dCZ/8pWUW2JistPxj15QvPZZk6L/F64O3bxvt+vsqX+6PFPZCr9rXnQ7s33u97z5yqx
	FGckGmoxFxUnAgALa5H1bgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jAd2yqYtCDH6strS4cvEQk8XUh0/Y
	LP5NucFusevvfUaL+1+PMlp8u9LBZHF51xw2i+Vv/7NZnO5mdeD02PC5ic1j56y77B6bVnWy
	edy5tofNY97JQI+XE3+zefRtWcXo8XmTXABHVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjLuPJrAWfOGs+D71EnMD42f2LkZODgkBE4nWo9tZIWwxiQv31rN1MXJxCAks
	YpRoP7uQGcKZwyTxo38WI0gVm4CGxPfPm5lBbBEBR4nHS/cxgdjMAscYJWY3FoLYwgLZEs//
	TmYBsVkEVCXmHfjDBmLzCrhJzF24B2qbtsS+hplsExi5FzAyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIjqJnUjsYVzZYHGIU4GBU4uHd8H5hiBBrYllxZe4hRgkOZiUR3kaDRSFCvCmJ
	lVWpRfnxRaU5qcWHGE2Btk9klhJNzgdGeF5JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6Yklq
	dmpqQWoRTB8TB6dUA2N6hH2Vjthc/x7mW1v29a4U9uR/eaPrUnm1xmqmd82vo3O4zZeen8N7
	paDi0qvYzxb7PTy3NXLO7dsmkvnk1nqLHR3tDJu2vbx+jNH+QIxky+HjnbGyOVJFk4zWKujf
	Tn7FYfua+dhbKz4dz4N9CbeNLyXkKezVYQvvefwiVMYpdqPPapkFKkosxRmJhlrMRcWJAI/X
	CnO4AgAA
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

