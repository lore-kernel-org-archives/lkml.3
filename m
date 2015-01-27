Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbbA0Fsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:48:55 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14433 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbbA0Fsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:48:53 -0500
X-AuditID: cbfee691-f79b86d000004a5a-95-54c726b761bd
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: rui.zhang@intel.com, edubezval@gmail.com, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        l.majewski@samsung.com, amit.daniel@samsung.com,
        kesavan.abhilash@gmail.com, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 1/2] dts: Documentation: Add documentation for Exynos7 SoC
 thermal bindings
Date: Tue, 27 Jan 2015 11:18:21 +0530
Message-id: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkRne72vEQg3Wn9C0aroZYbJyxntVi
	/pVrrBZr/ipZ9C64ymbx5uFmRovLu+awWXzuPcJoMeP8PiaLJw/72By4PHbOusvusXjPSyaP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgytjZu4214CBvxfnz95gbGPu4uxg5OSQETCQ2H/jI
	DGGLSVy4t56ti5GLQ0hgKaNE1+YprDBFDbufs4PYQgLTGSUeHeKFKOpjkpg3sZEFJMEmoCex
	4N9XsEkiAvESy1ZuZwEpYhZYxyjx5PEusEnCAgkS8xZ+AmtgEVCV6Oo8AxbnFXCVmDBzGZDN
	AbRNQWLOJBuQXgmBbnaJVV//sUHUC0h8m3yIBaJGVmLTAairJSUOrrjBMoFRcAEjwypG0dSC
	5ILipPQiU73ixNzi0rx0veT83E2MwDA+/e/ZxB2M9w9YH2IU4GBU4uHdcPNYiBBrYllxZe4h
	RlOgDROZpUST84HRklcSb2hsZmRhamJqbGRuaaYkzqsj/TNYSCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA2Pq3XUzbF47CqxTmbXTQ9v0aHO/mk665mSWr3s3XKvtD7P528KzQC0ybmv8yXX1
	Ssrf7vOp73vN0Xd7KaPc7zZppq/rc2all8YHRt5iiVwfe+NOX5j9rUajJRuZFv1NOH/zfkC2
	8VNHtuU3J9i2b9Ldetz5YvW0jaUGb3TLngTKBu9W/nv/C7sSS3FGoqEWc1FxIgD/PxLJXgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd3tasdDDF7O1rBouBpisXHGelaL
	+VeusVqs+atk0bvgKpvFm4ebGS0u75rDZvG59wijxYzz+5gsnjzsY3Pg8tg56y67x+I9L5k8
	+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGzt5trAUH
	eSvOn7/H3MDYx93FyMkhIWAi0bD7OTuELSZx4d56NhBbSGA6o8SjQ7xdjFxAdh+TxLyJjSwg
	CTYBPYkF/74yg9giAvESy1ZuZwEpYhZYxyjx5PEuVpCEsECCxLyFn8AaWARUJbo6z4DFeQVc
	JSbMXAZkcwBtU5CYM8lmAiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBUfJMegfj
	qgaLQ4wCHIxKPLwbbh4LEWJNLCuuzD3EKMHBrCTCO/kEUIg3JbGyKrUoP76oNCe1+BCjKdDy
	icxSosn5wAjOK4k3NDYxNzU2tTSxMDGzVBLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgLBAo
	zV1r9PPllvb64w6aMRe2rJh+uDo+Luv5t6tdEn9CtZimsFpfTWZ9VfojTOeVpvLGgwHvFS2C
	5PMCa/9uf3RcOWBH98lDJ4/XV117ySwWvVTajS/E8cq1LdtK7Wp5qu3SXt/+kLzxnwTzNvme
	ONaq7I7O8CeeP1cwt9bH7jcoYLmjr3RFiaU4I9FQi7moOBEAM6gCSKgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for exynos7 thermal bindings including compatible
name and special clock properties.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 0f44932..695150a 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -12,6 +12,7 @@
 	       "samsung,exynos5420-tmu-ext-triminfo" for TMU channels 2, 3 and 4
 			Exynos5420 (Must pass triminfo base and triminfo clock)
 	       "samsung,exynos5440-tmu"
+	       "samsung,exynos7-tmu"
 - interrupt-parent : The phandle for the interrupt controller
 - reg : Address range of the thermal registers. For soc's which has multiple
 	instances of TMU and some registers are shared across all TMU's like
@@ -32,10 +33,13 @@
 - clocks : The main clocks for TMU device
 	-- 1. operational clock for TMU channel
 	-- 2. optional clock to access the shared registers of TMU channel
+	-- 3. optional special clock for functional operation
 - clock-names : Thermal system clock name
 	-- "tmu_apbif" operational clock for current TMU channel
 	-- "tmu_triminfo_apbif" clock to access the shared triminfo register
 		for current TMU channel
+	-- "tmu_sclk" clock for functional operation of the current TMU
+		channel
 - vtmu-supply: This entry is optional and provides the regulator node supplying
 		voltage to TMU. If needed this entry can be placed inside
 		board/platform specific dts file.
-- 
1.7.9.5

