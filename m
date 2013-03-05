Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab3CEEsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:48:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30553 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab3CEEsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:48:01 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-6a-51357900de19
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
In-reply-to: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
Subject: [PATCH 2/3] mfd: htc-pasic3: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 13:47:59 +0900
Message-id: <006401ce195c$9cd7d840$d68788c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ZXH0Yw9kuA009QHe2/LULknNrfgAAA++Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY12GStNAg7nzuS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGx2nHglfsFZumHGdsYLzD1sXIySEhYCJx6MUuFghbTOLCvfVA
	cS4OIYFljBILLy1khCk6tmYhK0RiEaPE1iW/GSGc2UwSB881soJUsQmoSXz5cpgdxBYR0JLo
	PnYeaBQHB7OAi8TRaSIgYSEBW4mtv5+BlXAK2ElcfXsA7AphAQ+JlVtOgtksAqoSE453gF3E
	C1R/ZPcaKFtQ4sfke2A2M9D4zduaWCFseYnNa94yg6ySEFCXePRXF8QUETCS6LoVCVEhIrHv
	xTuwiyUE5rFLXHj2khlilYDEt8mHWCBaZSU2HWCGeFdS4uCKGywTGCVmIVk8C8niWUgWz0Ky
	YgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkKiauIPx/gHrQ4zJQOsnMkuJJucDozKv
	JN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjXPvv6
	Zl3e0eziB7vy9GuUjCUv77zyuCkuVHK9JDerwfcl0/Jvfqx4czPrqVl0UYOO85fZx1seKbzf
	ISrjcsf/7PK4Nw0pvQudxLcX83xd9LJ4wqRt5daz12xLPXD9K+/FRx+KS/r2dKSks74xD7UV
	mbTezcUicM4H36UXNld+/8qY8enbr6h5SizFGYmGWsxFxYkA8o8EEcACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgC5DpWmgwdrfbBaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo+O0Y8Er9opNU44zNjDe
	Yeti5OSQEDCROLZmISuELSZx4d56oDgXh5DAIkaJrUt+M0I4s5kkDp5rBKtiE1CT+PLlMDuI
	LSKgJdF97DxQBwcHs4CLxNFpIiBhIQFbia2/n4GVcArYSVx9ewBsmbCAh8TKLSfBbBYBVYkJ
	xztYQGxeoPoju9dA2YISPybfA7OZgcZv3tbECmHLS2xe85YZZJWEgLrEo7+6IKaIgJFE161I
	iAoRiX0v3jFOYBSahWTQLCSDZiEZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsY
	wTH7THoH46oGi0OMAhyMSjy8DEdNAoVYE8uKK3MPMUpwMCuJ8N7nNQ0U4k1JrKxKLcqPLyrN
	SS0+xJgM9OdEZinR5HxgOskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTUgtQi
	mC1MHJxSDYxyXjPX7Ztu8I1jwk5+VSGJhNfa51mvW/w7ccL0/9xGc33O1pkLvctOnxd/EvWs
	s8R90o3QdBvfNRtEOrr9fUI+RHD/Us1yDpa8ViV1zFzzrMxxHcbjRQHzDGNn5t21Cu08tmTy
	CbcYv43XkgS1slaUHt2/wGdjLF/ekooVGomfu9hW7+o8OVeJpTgj0VCLuag4EQBMBzVsHQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/htc-pasic3.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 9e5453d..0285fce 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -208,18 +208,7 @@ static struct platform_driver pasic3_driver = {
 	.remove		= pasic3_remove,
 };
 
-static int __init pasic3_base_init(void)
-{
-	return platform_driver_probe(&pasic3_driver, pasic3_probe);
-}
-
-static void __exit pasic3_base_exit(void)
-{
-	platform_driver_unregister(&pasic3_driver);
-}
-
-module_init(pasic3_base_init);
-module_exit(pasic3_base_exit);
+module_platform_driver_probe(pasic3_driver, pasic3_probe);
 
 MODULE_AUTHOR("Philipp Zabel <philipp.zabel@gmail.com>");
 MODULE_DESCRIPTION("Core driver for HTC PASIC3");
-- 
1.7.2.5


