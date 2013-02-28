Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3B1KkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:40:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11354 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3B1KkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:40:17 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-1a-512f341020a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ce159f$94e48270$bead8750$%han@samsung.com>
In-reply-to: <000901ce159f$94e48270$bead8750$%han@samsung.com>
Subject: [PATCH 7/7] rtc: rtc-tegra: add __init/__exit annotation
Date: Thu, 28 Feb 2013 19:40:15 +0900
Message-id: <000f01ce159f$fec01e70$fc405b50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vn5THVyS/kU1xRpiO8bTmT1G2WgAAFYbA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI10BE/1Ag/l3mC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOPvhAnPBVa6KF9132RsYv3F0MXJySAiYSJzfupsVwhaTuHBvPRuILSSwjFHi9Mzo
	LkYOsJqp9wW7GLmAwtMZJX6eucwG4fxilDh3fStYM5uAmsSXL4fZQRpEBPQl2lo0QGqYBXoZ
	Jc707maHGGorsaq7FayeU8BOYs/8Sawg9cICjhJrf/KAhFkEVCW+d69lAbF5gcrndn5jhrAF
	JX5MvgcWZxbQkti8rYkVwpaX2LzmLTPEneoSj/7qgoRFBIwkvi+7DFUiIrHvxTtGkHMkBO6x
	S5zvmckCsUtA4tvkQywQvbISmw4wQ4JBUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHU
	guSC4qT0ImO94sTc4tK8dL3k/NxNjJAo7d/BePeA9SHGZKD1E5mlRJPzgVGeVxJvaGxsYmZi
	amJuaWpuSpqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Me14enLUw5P2Kix1Z
	8mYPfv65LRNeb81ovfn7zo9qe7OYfhp8W+J+Zad8wp0Hofmfvzw133FeMOdx2KRZXXqfFRqa
	Fuw+//jYp7Cr15ol5Zg3Rk2d2XP8K++OBdyOoiwTZtSe2+EQVnT4l7CFrMD9jSsLrFYbHZ4p
	2LW0XfmH4q5V6Y7/VOak6yqxFGckGmoxFxUnAgCc3uga6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV1+E/1Ag9PrbSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDj74QJzwVWuihfdd9kbGL9xdDFycEgImEhM
	vS/YxcgJZIpJXLi3nq2LkYtDSGA6o8TPM5ehnF+MEueub2UFqWITUJP48uUwO0iziIC+RFuL
	BkgNs0Avo8SZ3t3sIDVCArYSq7pbweo5Bewk9syfxApSLyzgKLH2Jw9ImEVAVeJ791oWEJsX
	qHxu5zdmCFtQ4sfke2BxZgEtic3bmlghbHmJzWveMkPcrC7x6K8uSFhEwEji+7LLUCUiEvte
	vGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgpPAM6kd
	jCsbLA4xCnAwKvHwdpjoBQqxJpYVV+YeYpTgYFYS4XXh1w8U4k1JrKxKLcqPLyrNSS0+xJgM
	9OhEZinR5HxggsoriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxS
	DYwcdvJNvXuX3HV4+CG2oyW5gtE58sSDSjFXrjv+m6MX56mtSPpczc5e+zyUZaE3/7tNHz+3
	Zt/pf/WU8/7X/sjOlWEfzhjdfbCNQ4ynfl2d0oUNDStP/LfPP/J8vVGMvXnEtWsGj997l7xi
	z9hUu0bvka1D9cLfC2rbl4dvcVArZ1a7sXjpmclKLMUZiYZazEXFiQD4O1dxRgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tegra.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 7c03375..0020bab 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -309,7 +309,7 @@ static const struct of_device_id tegra_rtc_dt_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tegra_rtc_dt_match);
 
-static int tegra_rtc_probe(struct platform_device *pdev)
+static int __init tegra_rtc_probe(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info;
 	struct resource *res;
@@ -379,7 +379,7 @@ err_dev_unreg:
 	return ret;
 }
 
-static int tegra_rtc_remove(struct platform_device *pdev)
+static int __exit tegra_rtc_remove(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
 
@@ -439,7 +439,7 @@ static void tegra_rtc_shutdown(struct platform_device *pdev)
 
 MODULE_ALIAS("platform:tegra_rtc");
 static struct platform_driver tegra_rtc_driver = {
-	.remove		= tegra_rtc_remove,
+	.remove		= __exit_p(tegra_rtc_remove),
 	.shutdown	= tegra_rtc_shutdown,
 	.driver		= {
 		.name	= "tegra_rtc",
-- 
1.7.2.5


