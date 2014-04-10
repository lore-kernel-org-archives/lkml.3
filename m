Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329AbaDJKGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:06:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24362 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935022AbaDJKGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:21 -0400
X-AuditID: cbfee690-b7f266d00000287c-4f-53466d1b41e5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/27] ARM: dts: exynos3250: Add new exynos3250.dtsi file
Date: Thu, 10 Apr 2014 19:06:00 +0900
Message-id: <1397124377-16969-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkSFc61y3Y4NM9YYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MpY0f2LteA4b8X6r6+ZGhgncncxcnJICJhITDl3
	kx3CFpO4cG89G4gtJLCUUWL3d3mYmuevz7B0MXIBxRcxSmx9toIRwmlikjj0byZYB5uAlsT+
	FzfAbBGBAIkfx9+B2cwCNxkljr0PA7GFBTwlbjy9zARiswioSmw/2gFm8wq4SizZ2M0EsU1O
	4sOeR2AXcQq4ScxcdBLqIleJnkcXmUEWSwisYpd4f2UPO8QgAYlvkw8BnccBlJCV2HSAGWKO
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGPin/z2bsIPx3gHrQ4zJ
	QOMmMkuJJucDIyevJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhgt5PLf66usuRGcc+hhy7I8nsX81lxzZnCF7op3CJ3qKmy7+s6ankBe655Vvixi
	53x5P5TYd+zYzSgRHlV+2eGL/DOxSVMiP3Ntb38Sa5IQI+essqLzxqfKrIZO38ofkkHclnZ3
	8zk8BW2+ePnX/ktdZJpyOnxjYkec0492u4OFUTO+CHJrKLEUZyQaajEXFScCAH1fr5ySAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAV3pXLdgg0NPuSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxoruX6wF
	x3kr1n99zdTAOJG7i5GTQ0LAROL56zMsELaYxIV769m6GLk4hAQWMUpsfbaCEcJpYpI49G8m
	G0gVm4CWxP4XN8BsEYEAiR/H34HZzAI3GSWOvQ8DsYUFPCVuPL3MBGKzCKhKbD/aAWbzCrhK
	LNnYzQSxTU7iw55H7CA2p4CbxMxFJ8HmCAHV9Dy6yDyBkXcBI8MqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjODIeia1g3Flg8UhRgEORiUe3gPLXIOFWBPLiitzDzFKcDArifDuznQLFuJN
	SaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YNTnlcQbGpuYGVkamRtaGBmbkyasJM57oNU6UEgg
	PbEkNTs1tSC1CGYLEwenVAPjcUON1/O+bP7X9/A5y7MtO099M7r1X2trgvezq7ELaxo3fQp3
	T/rZ7KUkcdHFYP30FY5ScrIcfx4dYqi5Vh64QfbpvPT1ahkWW/kZfdZtkpEP2/T1b9gmxlNL
	xFY8nVfWsODSP/HLLQLy0pNvHJ/w4vET5jfNve9tAmM4C0x7d2dKHXm+44vIFCWW4oxEQy3m
	ouJEACroCAfwAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add new exynos3250.dtsi to support Exynos3250 SoC and includes
chipid/sys_reg dt node.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos3250.dtsi

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
new file mode 100644
index 0000000..3c8cee6
--- /dev/null
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -0,0 +1,34 @@
+/*
+ * Samsung's Exynos3250 SoC device tree source
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung's Exynos3250 SoC device nodes are listed in this file. Exynos3250
+ * based board files can include this file and provide values for board specfic
+ * bindings.
+ *
+ * Note: This file does not include device nodes for all the controllers in
+ * Exynos3250 SoC. As device tree coverage for Exynos3250 increases, additional
+ * nodes can be added to this file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "skeleton.dtsi"
+
+/ {
+	compatible = "samsung,exynos3250";
+
+	chipid@10000000 {
+		compatible = "samsung,exynos4210-chipid";
+		reg = <0x10000000 0x100>;
+	};
+
+	sys_reg: syscon@10010000 {
+		compatible = "samsung,exynos3-sysreg", "syscon";
+		reg = <0x10010000 0x400>;
+	};
+};
-- 
1.8.0

