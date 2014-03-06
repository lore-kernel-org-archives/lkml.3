Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaCFLR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:17:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:37023 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaCFLRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:17:54 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-81-53185953374d
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu,
        sander@humilis.net
Subject: [PATCH v10 0/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 06 Mar 2014 12:16:45 +0100
Message-id: <1394104609-28242-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd3gSIlgg479MhZLdt9gtZh/5Byr
	Rf+bhawWbVcOsltcXniJ1eLH6wtsFhee9rBZnG16AxTbNYfNYsb5fUwWi5a1MlusPXKX3eJs
	/202i4lN09gtzm/pZLI4/Kad1WLFvd3sFhN+A/Wun/GaxaJt9QdWi46zB9kdRD0u9/Uyeeyc
	dZfd49Pbxcwed67tYfP4d4zdY/bdH4wefVtWMXocv7GdyePzJrkAzigum5TUnMyy1CJ9uwSu
	jJ3n9jMVvPaomPZRrYHxsEUXIyeHhICJxOLl85kgbDGJC/fWs3UxcnEICSxilHj8YBUjhNPB
	JLHzyGegKg4ONgFNiVX3PEAaRARqJKbcusIOUsMsMI9Z4sOX6SwgCWEBe4kjtzczg9gsAqoS
	c5fcZAOxeQVcJBZ8b2cHmSMhoCAxZ5LNBEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNz
	NzGCg/qZ9A7GVQ0WhxgFOBiVeHg3+IkHC7EmlhVX5h5ilOBgVhLh3WIoESzEm5JYWZValB9f
	VJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qB0bUr9Xes3e+F/hvbNE+fOHOD
	r+/45uNFlxYZn+BjevzQ8k+o7b3XT+e8ST6173Vz1wdpibtKS0s+X59Ue7BreQj3Q5a98zun
	HwyLvcOy6bmtiXXjrU/qfzRN8m49WPDRJ0ZgZ7JzWLPHvZ6FUW3tynY8tkcUGqcWH2GZ46Dl
	ndQj+WpmoqLAUyWW4oxEQy3mouJEAM4hGj1mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the tenth version of this patchset. The only difference since v9
is correction in the documentation.

Best wishes,
Kamil Debski

--------------
Changes from v9:
1) phy: core: Add an exported of_phy_get function
   - No changes since v9.
2) phy: core: Add devm_of_phy_get to phy-core
   - No changes since v9.
3) phy: Add new Exynos USB 2.0 PHY driver
   - Fixed missing callback in the documentation of the
     samsung_usb2_phy_config structure.
4) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
   - No changes since v9.

--------------
Changes from v8:
1) phy: core: Add an exported of_phy_get function
   - No changes since v8.
2) phy: core: Add devm_of_phy_get to phy-core
   - No changes since v8.
3) phy: Add new Exynos USB 2.0 PHY driver
   - Fix empty blank line at EOF errors
4) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
   - Fix empty blank line at EOF error

--------------
Changes from v7:
1) phy: core: Add an exported of_phy_get function
   - No changes since v7.
2) phy: core: Add devm_of_phy_get to phy-core
   - No changes since v7.
3) phy: Add new Exynos USB 2.0 PHY driver
   - Fix checkpatch errors with code indentation and corrected whitespace.
4) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
   - Fix checkpatch errors with code indentation and corrected whitespace.

--------------
Changes from v6: (not including the change that controller patches were removed
form this patchset, also this patchset excludes S5PV210 support - it needs more
testing)
1) phy: core: Add an exported of_phy_get function
   - No changes since v6.
2) phy: core: Add devm_of_phy_get to phy-core
   - No changes since v6.
3) phy: Add new Exynos USB 2.0 PHY driver
   - Changed the way clocks are supplied to the driver. Prior to version v7
     there were reference clocks for every phy instance, now a single "ref"
     clock was introduced.
   - Updated documentation to match the aforementioned change.
   - Add offset EXYNOS_*_UPHYCLK_PHYFSEL_OFFSET to the clock register content
     defines.
   - Corrected way clock register is modified. Instead of a simple write, a
     proper read, modify, write sequence was introduced.
   - Important stability fix - added udelay after PHY reset. This fixes a bug
     causing instability in USB LAN adapters. Without the delay the DMA burst
     mode was could not be enabled.
4) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
   - Changed handling of clocks to use a single "ref" clock.

----------------
Changes from v5:
1) phy: core: Add an exported of_phy_get function
- corrected behaviour of the modification when GENERIC_PHY is not enabled
  by adding a stub of the of_phy_get function
2) phy: core: Add devm_of_phy_get to phy-core
- corrected behaviour of the modification when GENERIC_PHY is not enabled
  by adding a stub of the devm_of_phy_get function
3) dts: Add usb2phy to Exynos 4
- no change
4) dts: Add usb2phy to Exynos 5250
- in the previous version, this patch included some phy-exynos5250-usb2.c code
  by mistake, the code has been remove and added to the proper patch
5) phy: Add new Exynos USB PHY driver
- changed strings from Exynos 4212 to Exynos 4x12, as the Exynos 4212 driver is
  actually a driver for the whole Exynos 4x12 family
- added documentation to the Exynos USB 2.0 PHY driver adaptaion layer
- corrected strings HSCI -> HSIC
- fixed a problem introduced by previous change - on Exynos 4x12 the HSIC did
  not work on its own
- mode switch support was added to Exynos 4x12 (same io pins are used by host
  and device)
- support for phy_set_bus_width introduced by Matt Porter was added
6) phy: Add support for S5PV210 to the Exynos USB PHY
- setting of clk register was fixed
7) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
- supoprt was added for HSIC and device
8) usb: ehci-exynos: Change to use phy provided by the generic phy framework
- DT documentation was moved from usb-ehci.txt to exynos-usb.txt

----------------
Changes from v4:
1) phy: core: Add an exported of_phy_get function
- the new exported function of_phy_get was changed to take the phy's name as a
  parameter instead of the index
2) phy: core: Add devm_of_phy_get to phy-core
- fixes made in the comments to devm_of_phy_get
3) phy: Add new Exynos USB PHY driver
- move the documentation from a new to an existing file - samsung-phy.txt
- fix typos and uppercase hex addresses
- add more explanations to Kconfig (checkpatch still complains, but I find it
  hard to think what else could I add)
- add selects MFD_SYSCON as the driver needs it (Thank you, Tobias!)
- cleanup included headers in both *.c and .h files
- use BIT(x) macro instead of (1 << x)
- replaced HOST and DEV with PHY0 and PHY1 in phy-exynos4212-usb2.c, the
  registers are described as PHYx in the documentation hence the decision to
  leave the PHYx naming
- fixed typo in exynos4210_rate_to_clk reg -> *reg
- change hax_mode_switch and enabled type to bool
4) usb: ehci-s5p: Change to use phy provided by the generic phy framework
- Put the issue of phy->otg in order - since the new phy driver does not provide
  this field. With the new driver the switch between host and device is done in
  power_on of the respective host and device phys.
5) usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic phy
   framework
- fixed the example in the documentation
6) phy: Add support for S5PV210 to the Exynos USB PHY driver
- include files cleanup
- use BIT(x) macro instead of (1 << x)
7) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver
- include files cleanup
- use BIT(x) macro instead of (1 << x)
8) dts: Add usb2phy to Exynos 4
- no changes
9) dts: Add usb2phy to Exynos 5250
- no changes

----------------
Changes from v3:
- using PMU and system registers indirectly via syscon
- change labelling
- change Kconfig name
- fixed typos/stray whitespace
- move of_phy_provider_register() to the end of probe
- add a regular error return code to the rate_to_clk functions
- cleanup code and remove unused code
- change struct names to avoid collisions
- add mechanism to support multiple phys by the ehci driver

----------------
Changes from v2:
- rebase all patches to the usb-next branch
- fixes in the documentation file
  - remove wrong entries in the phy node (ranges, and #address- & #size-cells)
  - add clocks and clock-names as required properites
  - rephrase a few sentences
- fixes in the ehci-exynos.c file
  - move phy_name variable next to phy in exynos_ehci_hcd
  - remove otg from exynos_ehci_hcd as it was no longer used
  - move devm_phy_get after the Exynos5440 skip_phy check
- fixes in the s3c-hsotg.c file
  - cosmetic fixes (remove empty line that was wrongfully added)
- fixes in the main driver
  - remove cpu_type in favour for a boolean flag matched with the compatible
    value
  - rename files, structures, variables and Kconfig entires - change from simple
    "uphy" to "usb2_phy"
  - fix multiline comments style
  - simplify #ifdefs in of_device_id
  - fix Kconfig description
  - change dev_info to dev_dbg where reasonable
  - cosmetic changes (remove wrongful blank lines)
  - remove unnecessary reference counting

----------------
Changes from v1:
- the changes include minor fixes of the hardware initialization of the PHY
  module
- some other minor fixes were introduced

----------------------
Original cover letter:

Hi,

This patch adds a new drive for USB PHYs for Samsung SoCs. The driver is
using the Generic PHY Framework created by Kishon Vijay Abrahan I. It
can be found here https://lkml.org/lkml/2013/8/21/29. This patch adds
support to Exynos4 family of SoCs. Support for Exynos3 and Exynos5 is
planned to be added in the near future.

I welcome your comments.

----------------------
Kamil Debski (4):
  phy: core: Add an exported of_phy_get function
  phy: core: Add devm_of_phy_get to phy-core
  phy: Add new Exynos USB 2.0 PHY driver
  phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver

 .../devicetree/bindings/phy/samsung-phy.txt        |   54 +++
 Documentation/phy/samsung-usb2.txt                 |  135 +++++++
 drivers/phy/Kconfig                                |   40 ++
 drivers/phy/Makefile                               |    4 +
 drivers/phy/phy-core.c                             |   76 +++-
 drivers/phy/phy-exynos4210-usb2.c                  |  261 +++++++++++++
 drivers/phy/phy-exynos4x12-usb2.c                  |  328 ++++++++++++++++
 drivers/phy/phy-exynos5250-usb2.c                  |  404 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.c                     |  228 +++++++++++
 drivers/phy/phy-samsung-usb2.h                     |   67 ++++
 include/linux/phy/phy.h                            |   14 +
 11 files changed, 1602 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/phy/samsung-usb2.txt
 create mode 100644 drivers/phy/phy-exynos4210-usb2.c
 create mode 100644 drivers/phy/phy-exynos4x12-usb2.c
 create mode 100644 drivers/phy/phy-exynos5250-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.h

-- 
1.7.9.5

