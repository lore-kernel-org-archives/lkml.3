Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3LFKvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:51:45 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61999 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3LFKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:51:42 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-e8-52a1ac3b8694
From: Kamil Debski <k.debski@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <52A0969A.5070607@ti.com>
In-reply-to: <52A0969A.5070607@ti.com>
Subject: RE: [PATCH v4 0/9] phy: Add new Exynos USB 2.0 PHY driver
Date: Fri, 06 Dec 2013 11:51:38 +0100
Message-id: <009801cef271$245f88b0$6d1e9a10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7xy7Io9nght4jLSg6SC3Nz7YNt4AAo1Kyg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t/xy7rWaxYGGfTMUbVYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBYXnvawWZxtegPk7prDZjHj/D4mi0XLWpkt1h65y25xtv82m8XE
	pmnsFue3dDJZHH7TzmqxfsZrFouOswfZHQQ9Lvf1MnnsnHWX3ePOtT1sHn1bVjF6HL+xncnj
	8ya5ALYoLpuU1JzMstQifbsEroyP25czFUw0rJi97jZ7A+N0lS5GTg4JAROJ/5/XsEPYYhIX
	7q1n62Lk4hASWMooMW3mORYIp4FJYtaGVUxdjBwcbAKaEqvueYDERQRWMEoceHCcGcRhFnjI
	JLHz8Qo2kFFCAgkSpz+eArM5BdQkuuaeYwaxhQWcJBY+7mUEsVkEVCVmdH0Ds3kFHCQuf9jI
	AmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aQIyQE1CUe/dUFMUUEjCQ2P4uEqBCRuNvwnHUC
	o9AsJINmIRk0C8mgWUhaFjCyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQIic0vOxgXH7M6
	xCjAwajEw5uwZkGQEGtiWXFl7iFGCQ5mJRFem+ULg4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	9h36bHLaoj/RPnldibGPTtbujTkzk/ueS9aU5zg8WX5xtaz3+syfQvULGiyNPh6dP61E1EV3
	umKXzb89an1tJ388Se97cu/qFKs3n14fnXLuWk9ngedV+Xmi+QuPV9eXKFqZKfTffLBT5J5C
	t+O6SXfssjbetbua8lxBvCkj1aaX6e7SY9MjlViKMxINtZiLihMBKhW9lasCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Thursday, December 05, 2013 4:07 PM
> 
> Hi,
> 
> On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> > Hi,
> >
> > This is the fourth version of the patchset adding the new Exynos USB
> > 2.0 PHY driver. The driver uses the Generic PHY Framework.
> >
> > A month has passed since the last version. I have addressed numerous
> > comments that appeared on the mailing list in this patch. I would
> like
> > to specially thank Kishon, Tomasz, Matt and Vivek for their comments.
> >
> > This patch contains two necessary patches to the phy core.
> > It is very useful to be able to get phy using a device tree node.
> >
> > In addition this patch depends on:
> > [PATCH V11 1/3] ARM: dts: Add pmu sysreg node to exynos5250 and
> > exynos5420 dtsi files [1].
> >
> > Best wishes,
> > Kamil Debski
> 
> The last four patches are missing [1]

I am sorry, git send-email failed on the 6th patch thus that and the
Following patches were not sent. I guess it is the Murphy's law,
sending patches just before leaving office had high chances of such
a mishap.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland
 
> [1] -> https://lkml.org/lkml/2013/12/5/166
> 
> Thanks
> Kishon
> >
> > [1] - http://www.spinics.net/lists/linux-samsung-soc/msg24528.html
> >
> > ----------------
> > Changes from v3:
> > - using PMU and system registers indirectly via syscon
> > - change labelling
> > - change Kconfig name
> > - fixed typos/stray whitespace
> > - move of_phy_provider_register() to the end of probe
> > - add a regular error return code to the rate_to_clk functions
> > - cleanup code and remove unused code
> > - change struct names to avoid collisions
> > - add mechanism to support multiple phys by the ehci driver
> >
> > ----------------
> > Changes from v2:
> > - rebase all patches to the usb-next branch
> > - fixes in the documentation file
> >   - remove wrong entries in the phy node (ranges, and #address- &
> #size-cells)
> >   - add clocks and clock-names as required properites
> >   - rephrase a few sentences
> > - fixes in the ehci-exynos.c file
> >   - move phy_name variable next to phy in exynos_ehci_hcd
> >   - remove otg from exynos_ehci_hcd as it was no longer used
> >   - move devm_phy_get after the Exynos5440 skip_phy check
> > - fixes in the s3c-hsotg.c file
> >   - cosmetic fixes (remove empty line that was wrongfully added)
> > - fixes in the main driver
> >   - remove cpu_type in favour for a boolean flag matched with the
> compatible
> >     value
> >   - rename files, structures, variables and Kconfig entires - change
> from simple
> >     "uphy" to "usb2_phy"
> >   - fix multiline comments style
> >   - simplify #ifdefs in of_device_id
> >   - fix Kconfig description
> >   - change dev_info to dev_dbg where reasonable
> >   - cosmetic changes (remove wrongful blank lines)
> >   - remove unnecessary reference counting
> >
> > ----------------
> > Changes from v1:
> > - the changes include minor fixes of the hardware initialization of
> the PHY
> >   module
> > - some other minor fixes were introduced
> >
> > ----------------------
> > Original cover letter:
> >
> > Hi,
> >
> > This patch adds a new drive for USB PHYs for Samsung SoCs. The driver
> > is using the Generic PHY Framework created by Kishon Vijay Abrahan I.
> > It can be found here https://lkml.org/lkml/2013/8/21/29. This patch
> > adds support to Exynos4 family of SoCs. Support for Exynos3 and
> > Exynos5 is planned to be added in the near future.
> >
> > I welcome your comments.
> >
> > ----------------------
> >
> > [1] https://lkml.org/lkml/2013/8/21/29
> >
> >
> > Kamil Debski (8):
> >   phy: core: Change the way of_phy_get is called
> >   phy: core: Add devm_of_phy_get to phy-core
> >   phy: Add new Exynos USB PHY driver
> >   usb: ehci-s5p: Change to use phy provided by the generic phy
> >     framework
> >   usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic
> >     phy framework
> >   phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver
> >   dts: Add usb2phy to Exynos 4
> >   dts: Add usb2phy to Exynos 5250
> >
> > Mateusz Krawczuk (1):
> >   phy: Add support for S5PV210 to the Exynos USB PHY driver
> >
> >  .../devicetree/bindings/arm/samsung/pmu.txt        |    2 +
> >  .../devicetree/bindings/phy/samsung-usbphy.txt     |   56 +++
> >  .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 +
> >  Documentation/devicetree/bindings/usb/usb-ehci.txt |   35 ++
> >  arch/arm/boot/dts/exynos4.dtsi                     |   31 ++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   17 +
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   17 +
> >  arch/arm/boot/dts/exynos5250.dtsi                  |   33 +-
> >  drivers/phy/Kconfig                                |   35 ++
> >  drivers/phy/Makefile                               |    5 +
> >  drivers/phy/phy-core.c                             |   43 ++-
> >  drivers/phy/phy-exynos4210-usb2.c                  |  264
> ++++++++++++++
> >  drivers/phy/phy-exynos4212-usb2.c                  |  312
> +++++++++++++++++
> >  drivers/phy/phy-exynos5250-usb2.c                  |  363
> ++++++++++++++++++++
> >  drivers/phy/phy-s5pv210-usb2.c                     |  206
> +++++++++++
> >  drivers/phy/phy-samsung-usb2.c                     |  240
> +++++++++++++
> >  drivers/phy/phy-samsung-usb2.h                     |   74 ++++
> >  drivers/usb/gadget/s3c-hsotg.c                     |   11 +-
> >  drivers/usb/host/ehci-exynos.c                     |   95 +++--
> >  include/linux/phy/phy.h                            |    3 +
> >  20 files changed, 1789 insertions(+), 57 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> >  create mode 100644 drivers/phy/phy-exynos4210-usb2.c  create mode
> > 100644 drivers/phy/phy-exynos4212-usb2.c  create mode 100644
> > drivers/phy/phy-exynos5250-usb2.c  create mode 100644
> > drivers/phy/phy-s5pv210-usb2.c  create mode 100644
> > drivers/phy/phy-samsung-usb2.c  create mode 100644
> > drivers/phy/phy-samsung-usb2.h
> >

