Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3JGByU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:54:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64474 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3JGByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:54:15 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-79-5252144548fb
Date: Mon, 07 Oct 2013 10:54:12 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 06/20] iommu/exynos: always enable runtime PM
Message-id: <20131007105412.afe839f84bcaa19de1b7278f@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zQ11XkaAgg12trBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6NFy/VeJov1M16zWMy8tYbFQcDjycF5TB6zGy6yePw73M/kcefaHjaPzUvqPSbfWM7o0bdl
	FaPH501yHleOnmEK4IzisklJzcksSy3St0vgytj69gZbwRH2it8X8xoYl7J1MXJySAiYSLyY
	vIkdwhaTuHBvPVCci0NIYBmjRP/8Q+wwRS+nfGCFSCxilHjQ38QE4Uxikuhe+4YVpIpFQFXi
	wvtlzCA2m4CWxOq5xxlBikQE2pgkvjYeYgFxmAVOM0us2r0CrEpYwFFi7tfzYN28QPbL++eZ
	IPZZSFxo6mCHiAtK/Jh8jwXEZgaaunlbEyuELS+xec1bZpChEgKdHBILL55khzhDQOLbZJBt
	HEAJWYlNB5ghZkpKHFxxg2UCo8gsJGNnIRk7C8nYBYzMqxhFUwuSC4qT0osM9YoTc4tL89L1
	kvNzNzFCIrl3B+PtA9aHGJOBVk5klhJNzgcmgrySeENjMyMLUxNTYyNzSzPShJXEedVarAOF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MArP3GGe/PXbg8tn4033Ni6Qmniv8jVX5bYtd8ya
	/1/YH3x7Zmmp5F8VK6s5Io471jJ2PvT1Oj4r600Yz4QfOZ+SOhu/+f/6qvFLYJPppYdBD0xe
	rHiTcsDnl5r5Wom3W85xzkpynDM3vLGo+1ed6pqdc5ZExsuyrRM2DJ3P8PN/1e09PR8SWucr
	sRRnJBpqMRcVJwIA5bDCDvoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV1XkaAgg+8iFnfunmO1mH8ESLw6
	8oPJYsF+a4vO2RvYLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2iymLDrNaHH7Tzmpx8k8v
	o0XL9V4mi/UzXrNYzLy1hsVBwOPJwXlMHrMbLrJ4/Dvcz+Rx59oeNo/NS+o9Jt9YzujRt2UV
	o8fnTXIeV46eYQrgjGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wB+kJJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLH17Q22
	giPsFb8v5jUwLmXrYuTkkBAwkXg55QMrhC0mceHeeqA4F4eQwCJGiQf9TUwQziQmie61b8Cq
	WARUJS68X8YMYrMJaEmsnnucEaRIRKCNSeJr4yEWEIdZ4DSzxKrdK8CqhAUcJeZ+PQ/WzQtk
	v7x/nglin4XEhaYOdoi4oMSPyfdYQGxmoKmbtzWxQtjyEpvXvGWewMg3C0nZLCRls5CULWBk
	XsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnCSeSe9gXNVgcYhRgINRiYd3x/3AICHWxLLi
	ytxDjBIczEoivJfqgEK8KYmVValF+fFFpTmpxYcYk4H+nsgsJZqcD0xgeSXxhsYmZkaWRmYW
	Ribm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyBntJMLa331wGke+u2dUxvdpDq37
	+yN8Y9YfCNl1N+elsPaUg7+13n96KVahXLawv8vY4ejJ8v7Nby24bxndDF0Q4fbel1+qseHL
	hLPfQm0lo7c98Us5FiQzsYoxXcr4wwUnvaN/H9aYHZnAwm4Wcddt07+k+Q9j+86sOblJiu/J
	Lu/r0gLySizFGYmGWsxFxYkALp45Q1YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking if the probing device has a parent device was just to discover
if the probing device is involved in a power domain when the power
domain controlled by Samsung's custom implementation.
Since generic IO power domain is applied, it is required to remove
the condition to see if the probing device has a parent device.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 191cb3f..20b032f 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -644,8 +644,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	__set_fault_handler(data, &default_fault_handler);
 
-	if (dev->parent)
-		pm_runtime_enable(dev);
+	pm_runtime_enable(dev);
 
 	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
 	return 0;
-- 
1.7.2.5

