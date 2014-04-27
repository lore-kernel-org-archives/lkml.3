Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaD0Hiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:38:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31100 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaD0Hit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:38:49 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-ca-535cb4071d63
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v12 00/31] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Sun, 27 Apr 2014 13:07:32 +0530
Message-id: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkVpd9S0ywwdzj4hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltDjycDe7Rcv1XiaL9TNes1is2vWH0WLmrTUsDiIeTw7OY/KY3XCRxePf
	4X4mj52z7rJ73Lm2h81j85J6j8k3ljN69G1ZxejxeZOcx5WjZ5gCuKK4bFJSczLLUov07RK4
	MiZveMBaMC+gYsJ5+QbGdocuRk4OCQETiXOX5zJB2GISF+6tZwOxhQSWMkq8OygBU9N27RBj
	FyMXUHwRo8Tn7pusEM4EJonbi48yglSxCRhKbL93BSwhIrCaUaLv4hl2EIdZoIdZ4tr+O2A7
	hAXiJC73PQazWQRUJaae/c8MYvMKuEs0NYBM4gDapyAxZ5INSK+EQCOHxJy/jVD1AhLfJh9i
	gaiRldh0gBniPEmJgytusExgFFzAyLCKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIzDOTv97
	1r+D8e4B60OMyUDjJjJLiSbnA+M0ryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+TgoQE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwOqxVkjkekdHS3bdIp677jWOyvanmZCn3Z/m+bFXd/5ouOyyM
	3sVrYnvt4ykmJan02vIrqu77fqzj3S91r1bf60D6koYjM2SyN36YkFNf8fUw4z9Op7poueW1
	Qt1cbTuqD7ZesHh2QVPggny3WPr/oLOKjQFfOMTm7vXhntRfLVph84BlfaASS3FGoqEWc1Fx
	IgDKMvMQyQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAV32LTHBBnM7uSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWh9+0s1qc/NPLaHHk4W52i5brvUwW62e8ZrFYtesPo8XMW2tYHEQ8nhycx+Qxu+Eii8e/
	w/1MHjtn3WX3uHNtD5vH5iX1HpNvLGf06NuyitHj8yY5jytHzzAFcEU1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAP2npFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcyYvOEBa8G8gIoJ5+UbGNsduhg5OSQETCTarh1ihLDF
	JC7cW8/WxcjFISSwiFHic/dNVghnApPE7cVHwarYBAwltt+7ApYQEVjNKNF38Qw7iMMs0MMs
	cW3/HSaQKmGBOInLfY/BbBYBVYmpZ/8zg9i8Au4STQ0gkziA9ilIzJlkM4GRewEjwypG0dSC
	5ILipPRcQ73ixNzi0rx0veT83E2M4Dh+JrWDcWWDxSFGAQ5GJR7eBZIxwUKsiWXFlbmHGCU4
	mJVEeDmnA4V4UxIrq1KL8uOLSnNSiw8xJgMtn8gsJZqcD0wxeSXxhsYm5qbGppYmFiZmlqQJ
	K4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuOBpVbWAXo3OhEo506vZb9ff9ArfuJezPv3w
	h0M7f2+9O+Hb3hBJ8+jt3AteVvUbPha9uqVKptdSj+X/jq1b9JYtNRc+OD9uw6KuZ2JiXy59
	YOE1eVD9pbExLcU8un9vWnFsHUNoxNX/TnrHH3J6e60RjAxnSf1jfsPY5+B2i18vWd3/Jq3O
	UGIpzkg01GIuKk4EAJ3/uNonAwAA
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
v12:
- Rebased to the latest 3.15-rc2 master branch
  git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master (3.15-rc2)
- Addressed v11 review comments from
	'Sachin Kamat', 'Tomasz Figa' and 'Shaik Ameer Basha'
- Uses macro names instead of magic numbers for clock description in DT
- Moved DT binding document to seperate patch
- dtsi changes are separated into multiple patches
- patch description of some patches are updated according to the review comments
- removed the macros which hides the clock operations
- review comments related to compatible strings will be fixed in followup patches

v11:
- Rebased on the latest works on clock, arm/samsung, iommu branches
- Change the property to link System MMU and its master H/W
  'iommu' in the master's node -> 'mmu-masters' in the System MMU's node
- Changed compatible string:
  "samsung,sysmmu-v1"
  "samsung,sysmmu-v2"
  "samsung,sysmmu-v3.1"
  "samsung,sysmmu-v3.2"
  "samsung,sysmmu-v3.3"
- Change the implementation of retrieving System MMU version -> simpler
- Check NULL pointer before call to clk_enable() and clk_disable()
- Allow a single master to link to multiple System MMUs.
  (fimc-is, fimd/g2d/Scaler in Exynos5420)
- Workarounds of known problems of System MMU
- Code enhancements:
  * Compilable for 64-bit
  * Enhanced error messages

v10:
- Rebased on the following branches
  git.linaro.org/git-ro/people/mturquette/linux.git/clk-next
  git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
  git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
  git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master (3.12-rc3)
- Set parent clock to all System MMU clocks.
- Add clock and DT descriptos for Exynos5420
- Modified error handling in exynos_iommu_init()
- Split "iommu/exynos: support for device tree" patch into the following 6 patches
  iommu/exynos: handle only one instance of System MMU
  iommu/exynos: always enable runtime PM
  iommu/exynos: always use a single clock descriptor
  iommu/exynos: remove dbgname from drvdata of a System MMU
  iommu/exynos: use managed driver helper functions
  iommu/exynos: support for device tree
- Remove 'interrupt-names' and 'status' properties from DT
- Change n:1 relationship between master:System MMU into 1:1 relationship.
- Removed custom fault handler and print the status of System MMU
  whenever System MMU fault is occurred.
- Post Antonios Motakis's commit together:
  "iommu/exynos: add devices attached to the System MMU to an IOMMU group"

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

Antonios Motakis (1):
  iommu/exynos: add devices attached to the System MMU to an IOMMU
    group

Cho KyongHo (30):
  iommu/exynos: do not include removed header
  iommu/exynos: add missing cache flush for removed page table entries
  iommu/exynos: change error handling when page table update is failed
  iommu/exynos: fix L2TLB invalidation
  iommu/exynos: remove prefetch buffer setting
  iommu/exynos: allocate lv2 page table from own slab
  iommu/exynos: always enable runtime PM
  iommu/exynos: handle one instance of sysmmu with a device descriptor
  iommu/exynos: remove dbgname from drvdata of a System MMU
  iommu/exynos: use managed device helper functions
  documentation: iommu: add binding document of Exynos System MMU
  iommu/exynos: support for device tree
  iommu/exynos: gating clocks of master H/W
  iommu/exynos: remove custom fault handler
  iommu/exynos: handle 'mmu-masters' property of DT and improve
    handling sysmmu
  iommu/exynos: turn on useful configuration options
  iommu/exynos: add support for power management subsystems.
  iommu/exynos: allow having multiple System MMUs for a master H/W
  iommu/exynos: change rwlock to spinlock
  iommu/exynos: fix address handling
  iommu/exynos: use exynos-iommu specific typedef
  iommu/exynos: use simpler function to get MMU version
  iommu/exynos: apply workaround of caching fault page table entries
  iommu/exynos: enhanced error messages
  clk: exynos: add gate clock descriptions of System MMU
  ARM: dts: add System MMU nodes of exynos4 series
  ARM: dts: add System MMU nodes of exynos4210
  ARM: dts: add System MMU nodes of exynos4x12
  ARM: dts: add System MMU nodes of exynos5250
  ARM: dts: add System MMU nodes of exynos5420

 .../devicetree/bindings/iommu/samsung,sysmmu.txt   |   79 ++
 arch/arm/Kconfig                                   |    2 +
 arch/arm/boot/dts/exynos4.dtsi                     |  107 ++
 arch/arm/boot/dts/exynos4210.dtsi                  |   23 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   78 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  270 +++-
 arch/arm/boot/dts/exynos5420.dtsi                  |  209 ++-
 drivers/clk/samsung/clk-exynos5250.c               |   36 +
 drivers/clk/samsung/clk-exynos5420.c               |   13 +-
 drivers/iommu/Kconfig                              |    8 +-
 drivers/iommu/exynos-iommu.c                       | 1436 ++++++++++++++------
 include/dt-bindings/clock/exynos5250.h             |   17 +
 include/dt-bindings/clock/exynos5420.h             |    6 +-
 13 files changed, 1852 insertions(+), 432 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
 mode change 100644 => 100755 drivers/iommu/exynos-iommu.c

-- 
1.7.9.5

