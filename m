Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3HHJhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:37:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28580 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097Ab3HHJhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:37:12 -0400
X-AuditID: cbfee68e-b7f276d000002279-a5-520366c6d582
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 00/16] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Thu, 08 Aug 2013 18:37:10 +0900
Message-id: <002401ce941a$dad907c0$908b1740$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6TZsRQtEwyOn45SJWMSMnSOeSkiQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zoe6xNOYgg61vZC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUVw2Kak5mWWpRfp2CVwZG999Zyz4oV0x/Vg7ewPjTaUuRk4OCQETid2XVrJC2GISF+6t
	Z+ti5OIQEljGKPHgdAczTNH1zU1MEIlFjBL7dixmgXD+MkpsWXKIHaSKTUBLYvXc44wgCRGB
	34wSt57NYQVxmAX+M0lsvd0EViUsECux4fILFhCbRUBVYvPD60wgNq+ApcTjN2tYIGxBiR+T
	74HZzEBT1+88zgRhy0tsXvMW6iYFiR1nXzOC2CICehKHzn1ih6gRkdj34h3YFRICCzkkNnQd
	Z4RYJiDxbfIhoKEcQAlZiU0HoOZIShxccYNlAqPYLCSrZyFZPQvJ6llIVixgZFnFKJpakFxQ
	nJReZKRXnJhbXJqXrpecn7uJERL/fTsYbx6wPsSYDLR+IrOUaHI+MH3klcQbGpsZWZiamBob
	mVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx5dcDwt5Jp2yX9K6aO+nV
	7yMnlmW+vGe9bMbinb3RUmXbrbve/X67wZetX8fIveHTHdW5C6wnq/9xjPT0eJu96tyLxo7I
	q2tlMi/P7xSyW6HsciL8pvkC1doN90+FCGrGmtoy1aRJfK4uSt7w/qOqk7lcQ9iHN7YfMy+f
	uLPOfdszy+aNr66wKbEUZyQaajEXFScCAHCI2rUVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAd1jacxBBq+fi1vcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZmx8952x4Id2xfRj7ewN
	jDeVuhg5OSQETCSub25igrDFJC7cW8/WxcjFISSwiFFi347FLBDOX0aJLUsOsYNUsQloSaye
	e5wRJCEi8JtR4tazOawgDrPAfyaJrbebwKqEBWIlNlx+wQJiswioSmx+eB1sB6+ApcTjN2tY
	IGxBiR+T74HZzEBT1+88zgRhy0tsXvOWGeImBYkdZ18zgtgiAnoSh859YoeoEZHY9+Id4wRG
	gVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcXJ5J72Bc1WBx
	iFGAg1GJh3ehG3OQEGtiWXFl7iFGCQ5mJRHei8VMQUK8KYmVValF+fFFpTmpxYcYk4E+ncgs
	JZqcD0x8eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAaPJZ
	K+dU9p3jgT/OnC2OzyhbwFeyLz1n88kX2k/innZPnvLtu1iMWk/+5qUZ5yUeS2w0cH0jJjKX
	fdGrjL8x/qst2Cf8EpnXNWWW1uQfv3hFyjmi07Ys77iQ0nnr2s+bJfGmtqq/fqb5zHbewv5Y
	dwNXo3Wf4MtjtnNV97+Y6CabrXjW+I6ZkRJLcUaioRZzUXEiABU6LNJyAwAA
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
when I/O memory mapping is changed. Because a System MMU resides in the
same H/W block, access to control registers of System MMU while the H/W
block is turned off must be prohibited.

This set of changes solves the above problem with setting each System MMUs
as the parent of the device which owns the System MMU to receive the
information when the device is turned off or turned on.

Another big change to the driver is the support for devicetree.
The bindings for System MMU is described in
Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

In addition, this patchset also includes several bug fixes and enhancements
of the current driver.

Change log:
v9:
- Rebased on the following branches
  git.linaro.org/git-ro/people/mturquette/linux.git/clk-next
  git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/samsung-next
  git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master (3.11-rc4)
- Split "add bus notifier for registering System MMU" into 5 patches
- Call clk_prepare() that was missing in v8.
- Fixed base address of sysmmu_tv in exynos4210.dtsi
- BUG_ON() instead of return -EADDRINUSE when trying mapping on an mapped area
- Moved camif_top to 317 in drivers/clk/samsung/clk-exynos5250.c
- Removed 'iommu' property from 'codec'(mfc) node
- Does not make 'master' clock to be the parent of 'sysmmu' clock.
   'master' clock is enabled before accessing control registers of System MMU
   and disabled after the access.

v8:
- Reordered patch list: moved "change rwloc to spinlock" to the last.
- Fixed remained bug in "fix page table maintenance".
- Always return 0 from exynos_iommu_attach_device().
- Removed prefetch buffer setting when System MMU is enabled
  due to the restriction of prefetch buffers:
  A prefetch buffer must not hit from more than one DMA.
  For instance with GScalers, if a single prefetch buffer is initialized
  with 0x0 ~ 0xFFFFFFFF and a GScaler works on source buffer at 0x10000000
  and target buffer @ 0x20000000, the System MMU may be got deadlock.
  Clients must initialize prefetch buffers with custom function defined
  in exynos-iommu drivers whenever they need to enable prefetch buffers.
- The clock of System MMU has no relationship with the clock of its master H/W.
  The clock of master H/W is always enabled when exynos-iommu driver needs to
  access MMIO area and disabled as soon as the access finishes.
- Removed err_page variable used in exynos_iommu_unmap() in the previous patch
  "fix page table maintenance".
- Split a big patch "add bus notifier for registering System MMU".
   Extracted the following 2 patches: 9/12 and 10/12.
- And some additional fixes...

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

Diffstats:
 .../devicetree/bindings/clock/exynos5250-clock.txt |   26 +
 .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 ++
 arch/arm/boot/dts/exynos4.dtsi                     |  122 +++
 arch/arm/boot/dts/exynos4210.dtsi                  |   25 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |  290 ++++++
 drivers/clk/samsung/clk-exynos4.c                  |   27 +-
 drivers/clk/samsung/clk-exynos5250.c               |   57 +-
 drivers/iommu/Kconfig                              |    5 +-
 drivers/iommu/exynos-iommu.c                       | 1061 +++++++++++++-------
 10 files changed, 1423 insertions(+), 375 deletions(-)

