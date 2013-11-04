Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3KDB4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:56:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35671 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3KDB4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:56:11 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-ba-5276feb466b0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 0/3] ARM: dts: exynos: Add missing dt data to bring up kernel
 featurea
Date: Mon, 04 Nov 2013 10:55:58 +0900
Message-id: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSrLvlX1mQQV+7nMX1L89ZLeYfOcdq
	ce7VSkaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxdLrF5ksJkxfy2JxeMUBJotX
	B9tYLNbPeM3iwOexZt4aRo+W5h42jwWfr7B7rFz+hc1j85J6j74tqxg9Pm+S89g4NzSAI4rL
	JiU1J7MstUjfLoEr48mMsoIvLBXL+3qZGxjfMXcxcnJICJhInFywkA3CFpO4cG89kM3FISSw
	lFHiz/IrTDBFm1/9YoRITGeUeHFhNTuE08gk0fT3LFgVm4CWxP4XN8BGiQjoSkyZeYcVpIhZ
	4D6TxI/jq8ASwgJREqdnHgFq4OBgEVCV+P8zEcTkFXCVuHBFEWKZnMSHPY/A5ksInGKXmH31
	MyNIgkVAQOLb5EMsIPUSArISmw5AfSApcXDFDZYJjIILGBlWMYqmFiQXFCelFxnpFSfmFpfm
	pesl5+duYgTGxOl/z/p2MN48YH2IMRlo3ERmKdHkfGBM5ZXEGxqbGVmYmpgaG5lbmpEmrCTO
	u+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxnVTfDXu1ieEGPJveXjq2/b9O3+J7BJT
	ib9wc03v38yX7FLes5WDLi1kfPltklHloRt9P6dY31ZZPe1TiBqLZD7zVKb/djfYO+/tFuc4
	bLDsU2VuRaiPFO+U58ez4yyvmQQwrlovPzEheXcnX+D8E55BHoJXXPewMnxlb9i4uPrImyId
	Ea/WE0osxRmJhlrMRcWJAOoDl4efAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQd0t/8qCDO61iFpc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWh1ccYLJ4
	dbCNxWL9jNcsDnwea+atYfRoae5h81jw+Qq7x8rlX9g8Ni+p9+jbsorR4/MmOY+Nc0MDOKIa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGY8mVFW8IWlYnlfL3MD4zvmLkZO
	DgkBE4nNr34xQthiEhfurWfrYuTiEBKYzijx4sJqdginkUmi6e9ZJpAqNgEtif0vbrCB2CIC
	uhJTZt5hBSliFrjPJPHj+CqwhLBAlMTpmUeAGjg4WARUJf7/TAQxeQVcJS5cUYRYJifxYc8j
	9gmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfcM6kdjCsbLA4xCnAwKvHwSlwu
	CxJiTSwrrsw9xCjBwawkwut8DijEm5JYWZValB9fVJqTWnyIMRlo90RmKdHkfGAyyCuJNzQ2
	MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxlObThnN+1jWmH3VocIn
	dx8P00bX8i3tsxecs9V8a2hdmxG/aO0Kly8JbM+6Du1k8jf+z3T0wCHjiesERI/7Ha7Yf6Ts
	3Yq9Jft6Dzz/uFs4d6PXBYkXe4qOV5ooXpZYV/nvl3+fd+7/82uf7/Mu6SqzyZ15+u6N/ldi
	RrfXKV1TfBmz3Yz/mJsSS3FGoqEWc1FxIgD9XD05/AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add missing dt data to bring up kernel feature
- GPS_ALIVE power domain
- PMU
- Clock data for Multi core timer

Changes since v2:
- Delete MAUDIO power domain

Changes since v1:
- Fix wrong address of GPS_ALIVE power domain

Chanwoo Choi (2):
  ARM: dts: exynos4212: Add PMU dt data for pmu-irq
  ARM: dts: exynos4x12: Add gps_alive power domain for exynos4x12

Marek Szyprowski (1):
  ARM: dts: exynos4212: Add missing clock for multi core timer

 arch/arm/boot/dts/exynos4212.dtsi | 8 ++++++++
 arch/arm/boot/dts/exynos4x12.dtsi | 5 +++++
 2 files changed, 13 insertions(+)

-- 
1.8.0

