Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaCLLtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:49:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26002 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaCLLsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:48:18 -0400
Date: Wed, 12 Mar 2014 20:48:02 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4/4] devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
 instead of legacy method
In-reply-to: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-id: <1394624882-2989-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
DLP-Filter: Pass
X-AuditID: cbfee691-b7efc6d0000039d3-f6-532049812d24
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkRLfRUyHY4PVVdovrX56zWpxtesNu
	0f0j2+LyrjlsFp97jzBa3G5cwWbx5sdZJovHK96yO3B4LN7zksmjb8sqRo/jN7YzeXzeJBfA
	EsVlk5Kak1mWWqRvl8CVMe3wV8aCJt6Kpyt/sTUwPuXqYuTgkBAwkbhyg72LkRPIFJO4cG89
	WxcjF4eQwFJGia5761khEiYSP3+9YIZITGeUOH1hGZTTyCTx5GcrI0gVm4CWxP4XN9hAbBEB
	c4ldS3+CjWIWWMso8ejTHLCEsECyxJqtn5lBbBYBVYnjR7vAVvAKuEh8uNoOdYecxIc9j8Bs
	TgFXiatrjoMtEAKq+XNxCwvIUAmB6ewS7/sfs0IMEpD4NvkQC8Q/shKbDjBDzJGUOLjiBssE
	RuEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQLD/PS/ZxN3MN4/YH2IMRlo3ERmKdHk
	fGCc5JXEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	o/gbIaH7dfMT929uu3PT78fxcpMziau2sAs263VtVq7WmSOb8LqYo+uuzzK7zMBlWrJSJgWZ
	h1yuPoq9qr64abv+pMV9nwWLs6ceeG3yu8fv4MV7jsUX3VLOlXn1LZuqdHIdi2+4UdI+pS8u
	KzLn1RRy+zxZ8mdf9oNbF79x3rlz/8Dyqas9upVYijMSDbWYi4oTAUcXRgWJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd1GT4Vgg8v+Fte/PGe1ONv0ht2i
	+0e2xeVdc9gsPvceYbS43biCzeLNj7NMFo9XvGV34PBYvOclk0ffllWMHsdvbGfy+LxJLoAl
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoCiWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxrTDXxkLmngrnq78xdbA+JSr
	i5GTQ0LAROLnrxfMELaYxIV769m6GLk4hASmM0qcvrCMGcJpZJJ48rOVEaSKTUBLYv+LG2wg
	toiAucSupT/BOpgF1jJKPPo0BywhLJAssWbrZ7CxLAKqEsePdrGC2LwCLhIfrrazQ6yTk/iw
	5xGYzSngKnF1zXGwBUJANX8ubmGZwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw
	FD2T3sG4qsHiEKMAB6MSD+9CTflgIdbEsuLK3EOMEhzMSiK8u2wVgoV4UxIrq1KL8uOLSnNS
	iw8xJgNdNZFZSjQ5HxjheSXxhsYmZkaWRuaGFkbG5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXAKHd6yarnP7YeE9g9/2ou65QtaX6zw7YL/Jpd67PFMrejcYGm9Z9FQS2FbE5rSuTk
	liS2dXK/nrebw2D6rN+2cpf2ZZslnGsPt7m+Pcvmynan+pO69/3lbA9O2Pp5fb3CtFSVw/+y
	6qqjljTpHm55q7bk1TOL3OPV61h/b3Ngvcz321PUaJPhXyWW4oxEQy3mouJEAA7/fiHmAgAA
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use SET_SYSTEM_SLEEP_PM_OPS macro instead of legacy method. Also,
Before entering suspend state, disable ppmu's clock to remove power-leakage
in suspend state.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 0c5b99e..7e1540a 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -1229,16 +1229,40 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int exynos4_busfreq_resume(struct device *dev)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
+	int i;
+
+	/* Enable clock after wake-up from suspend state */
+	for (i = 0; i < PPMU_END; i++)
+		clk_prepare_enable(data->clk_ppmu[i]);
 
+	/* Reset PPMU to check utilization again */
 	busfreq_mon_reset(data);
+
+	return 0;
+}
+
+static int exynos4_busfreq_suspend(struct device *dev)
+{
+	struct busfreq_data *data = dev_get_drvdata(dev);
+	int i;
+
+	/*
+	 * Disable clock before entering suspend state
+	 * to reduce leakage power on suspend state.
+	 */
+	for (i = 0; i < PPMU_END; i++)
+		clk_disable_unprepare(data->clk_ppmu[i]);
+
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops exynos4_busfreq_pm = {
-	.resume	= exynos4_busfreq_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(exynos4_busfreq_suspend, exynos4_busfreq_resume)
 };
 
 static const struct platform_device_id exynos4_busfreq_id[] = {
-- 
1.8.0

