Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3GEM3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36057 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3GEM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:08 -0400
X-AuditID: cbfee68e-b7f276d000002279-1a-51d6bc11f53a
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
Subject: [PATCH v7 00/12] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Fri, 05 Jul 2013 21:29:05 +0900
Message-id: <002801ce797b$3d2fbc80$b78f3580$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55dTMuWbEECCyuQc2y6odHq6V9Yw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zY13BPdcCDZZc0rB4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZfyZ
	WlkwR6HixJ+vLA2MCyS7GDk5JARMJLYvb2SHsMUkLtxbz9bFyMUhJLCMUeLmlR/MMEVP27uY
	IRKLGCUWXXgB5fxllDh6/ClYFZuAlsTquccZQWwRgbuMEi/P84AUMQvcYJLY8KmNBSQhLBAr
	ce3bXLAiFgFViWc3HzGB2LwClhKT7t1ih7AFJX5MvgdWzww0dP3O40wQtrzE5jVvoU5SkNhx
	9jXUMj2J1i9z2SFqRCT2vXjHCLJYQuAvu8T93sVsEMsEJL5NPgQ0lAMoISux6QDUHEmJgytu
	sExgFJuFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCYrpvB+PN
	A9aHGJOB1k9klhJNzgemhLySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MG68N+3xUwVftbiEa5+Fbx9QkN+VahN6aX7fsf2PDpcYbVRf4b3ihkGu
	pInYgk+nPKf+efxqz0zTE3Guz1fvzxFXtEiSVrhcNscgJWtD7bqYB9NfvltzZ+67Txe2OBia
	XvMvkhVImnygPaCSV5tVNbLlvbTyhOy35S7P8l6y/TDsM36W22lVuUaJpTgj0VCLuag4EQC1
	tGqb/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAV3BPdcCDT72KFu8OvKDyWLBfmuL
	ztkb2C02H1zHYtG74CqbReO9CWwWmx5fY7W4vGsOm8WM8/uYLC6s2MhuMWXRYVaLluu9TA48
	Hk8OzmPymN1wkcXjzrU9bB6bl9R7TL6xnNGjb8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMWb8mVpZMEeh4sSfrywNjAskuxg5OSQETCSetncxQ9hiEhfu
	rWfrYuTiEBJYxCix6MILZgjnL6PE0eNPwarYBLQkVs89zghiiwjcZZR4eZ4HpIhZ4AaTxIZP
	bSwgCWGBWIlr3+aCFbEIqEo8u/mICcTmFbCUmHTvFjuELSjxY/I9sHpmoKHrdx5ngrDlJTav
	eQt1koLEjrOvoZbpSbR+mcsOUSMise/FO8YJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOGE8k9rBuLLB4hCjAAejEg+vRdPVQCHWxLLiytxDjBIczEoi
	vPYJ1wKFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YzPJK4g2NTcyMLI3MLIxMzM1JE1YS
	5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgVHH6+3LX87R3zyf+CwxjJRU2H8jxHLpMhujcElt
	19CGzgtv991qktY4elXw/LfK1lV/9zNV/8lgnxjkwLlKUWZDfm5VLce23bYh64ti7k9a3X/Z
	d6GaeNCvJb1l3IErS6eXLH1m0ylvELmVUSc+6LWkSa5d16+aquWd55xbj7MHrCyJNmN7qMRS
	nJFoqMVcVJwIAJt0d85cAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current exynos-iommu(System MMU) driver does not work autonomously
since it is lack of support for power management of peripheral blocks.
For example, MFC device driver must ensure that its System MMU is disabled
before MFC block is power-down not to invalidate IOTLB in the System MMU
when I/O memory mapping is changed. Because A System MMU is resides in the
same H/W block, access to control registers of System MMU while the H/W
block is turned off must be prohibited.

This set of changes solves the above problem with setting each System MMUs
as the parent of the device which owns the System MMU to recieve the
information when the device is turned off or turned on.

Another big change to the driver is the support for devicetree.
The bindings for System MMU is described in
Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

In addition, this patchset also includes several bug fixes and enhancements
of the current driver.

Change log:
v7:
- Rebased on the stable 3.10
- Registered PM domains and gate clocks with DT
- Changed connection method between a System MMU and its master H/W
   'mmu-master' property in the node of System MMU
   --> 'iommu' property in the node of master H/W
- Marking device descriptor of master H/W of a System MMU with bus notifier.
- Power management (PM_RUNTIME, PM_SLEEP) of System MMUs with gpd_dev_ops
   of Generic IO Powerdomain. gpd_dev_ops are set to the master H/Ws
   before they are probed in the bus notifier.
- Removed additional debugging features like debugfs entries and
   version names.
- Removed support for advanced features of System MMU 3.2 and 3.3
   the current IOMMU API cannot handle the feature
  (A kind of L2 TLB that fetches several consequence page table entries.
   It must be initialized by the driver of master H/W whenever it works.)

v6:
- Rebased on the branch, next/iommu-exynos of
  git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git

v5:
- new bugfix: patch 01
- Reordered patches
  * patch 01 ~ 05: Bugfix and enhancements of the existing driver
  * patch 06 ~ 10: Device Tree support and callbacks for power management
  * patch 11     : System MMU 3.2 and 3.3 support
  * patch 12 ~ 14: Debugging features
- Additional code compaction

v4:
- Remove Change-Id from v3 patches
- Change the order of the third and the first patch
  Thanks to Kukjin Kim.
- Fix memory leak when allocating and assigning exynos_iommu_owner to client
  device if the client device has multiple System MMUs.
  Thanks to Rahul Sharma.

v3:
- Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
- Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
  Thanks to Prathyush.

v2:
- Split the patch to iommu/exynos into 9 patches
- Support for System MMU 3.3
- Some code compaction

Patch summary:
[PATCH v7 1/9] iommu/exynos: do not include removed header
[PATCH v7 2/9] iommu/exynos: add missing cache flush for removed page table entries
[PATCH v7 3/9] iommu/exynos: fix page table maintenance
[PATCH v7 4/9] iommu/exynos: allocate lv2 page table from own slab
[PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
[PATCH v7 6/9] clk: exynos5250: add gate clock descriptions of System MMU
[PATCH v7 7/9] ARM: dts: Add description of System MMU of Exynos SoCs
[PATCH v7 8/9] iommu/exynos: support for device tree
[PATCH v7 9/9] iommu/exynos: add bus notifier for registering System MMU

Diffstats:
.../devicetree/bindings/clock/exynos5250-clock.txt |   28 +-
.../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 ++
arch/arm/boot/dts/exynos4.dtsi                     |  122 +++
arch/arm/boot/dts/exynos4210.dtsi                  |   25 +
arch/arm/boot/dts/exynos4x12.dtsi                  |   76 ++
arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++
drivers/clk/samsung/clk-exynos5250.c               |   57 +-
drivers/iommu/Kconfig                              |    5 +-
drivers/iommu/exynos-iommu.c                       | 1011 +++++++++++++-------
9 files changed, 1382 insertions(+), 336 deletions(-)

