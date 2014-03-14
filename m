Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaCNE7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 00:59:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49741 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaCNE7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 00:59:41 -0400
X-AuditID: cbfee690-b7f266d00000287c-7b-53228c9cd193
Date: Fri, 14 Mar 2014 13:59:08 +0900
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
Subject: [PATCH v11 00/27] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Message-id: <20140314135908.91d5da82f455051e56bee4d6@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zY905PUrBBrevaljcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK+P+7musBRt9Kh48/cHYwHjStouRk0NCwERi
	yqoJ7BC2mMSFe+vZQGwhgWWMEo+OlMPUXP80lREiPp1R4tl24S5GLiB7MpPEvJ3nmUESLAKq
	Ekt2XwIbxCagJbF67nFGkCIRgTYmia+Nh1hAHGaB08wSq3avAOsQFoiTWH31NROIzSvgKHHj
	9iFWiHUWEheaOtgh4oISPybfYwGxmYGmbt7WxAphy0tsXvOWGWSohMBUDomXD+4yQpwhIPFt
	Msg2DqCErMSmA8wQMyUlDq64wTKBUWQWkrGzkIydhWTsAkbmVYyiqQXJBcVJ6UUmesWJucWl
	eel6yfm5mxghcTxhB+O9A9aHGJOBVk5klhJNzgemgbySeENjMyMLUxNTYyNzSzPShJXEedUe
	JQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJw3STc1c9mVWrtXB8/6OWe8Mio8vepz1ewP
	d3+G/luUHyt78XvEPxuBgwxb7/hZrBZecP3Hzwezc+NfZ8Y8Pr5hSabV5MT0l9xKanHVivzW
	/Vq71QyfnY1pzOTWD80sv37kj8XSmQbH/0orPPevkJwpNbfo2+eXXdsfrs2/Mc/i+f/cxtVe
	a9WUWIozEg21mIuKEwEaXX+W+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQd05PUrBBptvKlrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gNJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG/d3X
	WAs2+lQ8ePqDsYHxpG0XIyeHhICJxPVPUxkhbDGJC/fWs4HYQgLTGSWebRfuYuQCsiczSczb
	eZ4ZJMEioCqxZPcldhCbTUBLYvXc44wgRSICbUwSXxsPsYA4zAKnmSVW7V4B1iEsECex+upr
	JhCbV8BR4sbtQ6wQ6ywkLjR1sEPEBSV+TL7HAmIzA03dvK2JFcKWl9i85i3zBEa+WUjKZiEp
	m4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4DTxTGoH48oGi0OMAhyMSjy8DocV
	g4VYE8uKK3MPMUpwMCuJ8FZFKAUL8aYkVlalFuXHF5XmpBYfYkwG+nsis5Rocj4wheWVxBsa
	m5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2PY3uC+Zec/L99wr2O2
	z8HPnZlrnodo3IvlkGX88Lu/y/p/usSJtxveR8Z0Ff41C7XO1Zt3v+e52MSi6mSDxB2rWS5X
	31jqzLDrVmnx2d235M9ssjw44alDlhhHo+hhmcmJaQdW6+czfG3PTqpTFeC749d31myNz63T
	2vod50WiHN/HzHhmw6TEUpyRaKjFXFScCABkZu55VwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed posting the v11 patchset.

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


Patch summary:
[PATCH v11 01/27] iommu/exynos: do not include removed header
[PATCH v11 02/27] iommu/exynos: add missing cache flush for removed page table entries
[PATCH v11 03/27] iommu/exynos: change error handling when page table update is failed
[PATCH v11 04/27] iommu/exynos: fix L2TLB invalidation
[PATCH v11 05/27] iommu/exynos: remove prefetch buffer setting
[PATCH v11 06/27] iommu/exynos: allocate lv2 page table from own slab
[PATCH v11 07/27] iommu/exynos: always enable runtime PM
[PATCH v11 08/27] iommu/exynos: always use a single clock descriptor
[PATCH v11 09/27] iommu/exynos: remove dbgname from drvdata of a System MMU
[PATCH v11 10/27] iommu/exynos: use managed device helper functions
[PATCH v11 11/27] clk: exynos: add gate clock descriptions of System MMU
[PATCH v11 12/27] ARM: dts: Add description of System MMU of Exynos SoCs
[PATCH v11 13/27] iommu/exynos: support for device tree
[PATCH v11 14/27] iommu/exynos: gating clocks of master H/W
[PATCH v11 15/27] iommu/exynos: use convenient macro to handle gate clocks
[PATCH v11 16/27] iommu/exynos: remove custom fault handler
[PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API functions
[PATCH v11 18/27] iommu/exynos: turn on useful configuration options
[PATCH v11 19/27] iommu/exynos: add support for power management subsystems.
[PATCH v11 20/27] iommu/exynos: allow having multiple System MMUs for a master H/W
[PATCH v11 21/27] iommu/exynos: change rwlock to spinlock
[PATCH v11 22/27] iommu/exynos: add devices attached to the System MMU to an IOMMU group
[PATCH v11 23/27] iommu/exynos: fix address handling
[PATCH v11 24/27] iommu/exynos: use exynos-iommu specific typedef
[PATCH v11 25/27] iommu/exynos: use simpler function to get MMU version
[PATCH v11 26/27] iommu/exynos: apply workaround of caching fault page table entries
[PATCH v11 27/27] iommu/exynos: enhanced error messages

Diffstats:
 .../devicetree/bindings/clock/exynos5250-clock.txt |    3 +
 .../devicetree/bindings/clock/exynos5420-clock.txt |    3 +
 .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   86 ++
 arch/arm/boot/dts/exynos4.dtsi                     |  107 ++
 arch/arm/boot/dts/exynos4210.dtsi                  |   23 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   77 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  266 +++-
 arch/arm/boot/dts/exynos5420.dtsi                  |  205 ++-
 drivers/clk/samsung/clk-exynos5250.c               |    5 +
 drivers/clk/samsung/clk-exynos5420.c               |   13 +-
 drivers/iommu/Kconfig                              |    5 +-
 drivers/iommu/exynos-iommu.c                       | 1421 ++++++++++++++------
 include/dt-bindings/clock/exynos5250.h             |    4 +
 include/dt-bindings/clock/exynos5420.h             |    6 +-
 14 files changed, 1798 insertions(+), 426 deletions(-)
