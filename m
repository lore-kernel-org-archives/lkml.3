Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaABQUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:20:20 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35829 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaABQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:20:16 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-e0-52c591bd2daf
From: Kamil Debski <k.debski@samsung.com>
To: "'Kamil Debski'" <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, kishon@ti.com
Cc: kyungmin.park@samsung.com, p.paneri@samsung.com,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de,
        stern@rowland.harvard.edu
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
Subject: RE: [PATCH v5 0/9] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 02 Jan 2014 17:20:12 +0100
Message-id: <02e201cf07d6$84110f20$8c332d60$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac79htC/vZHEUsAAQQKkPyLSx7C3qwKTJ8JQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t/xq7p7Jx4NMlj+zcxiye4brBbzj5xj
	teh/s5DVou3KQXaLywsvsVr8eH2BzeLC0x42i7NNb4Biu+awWcw4v4/JYtGyVmaLtUfusluc
	7b/NZjGxaRq7xfktnUwWh9+0s1pM+A3Utn7GaxaLttUfWC06zh5kdxDxuNzXy+Sxc9Zddo87
	1/awefw7xu4x++4PRo++LasYPY7f2M7k8XmTXABHFJdNSmpOZllqkb5dAlfGt9nTmAoa7Spe
	dHQxNzCe1Oti5OCQEDCReP8mtYuRE8gUk7hwbz1bFyMXh5DAUkaJh29fM0M4DUwSMw9tZQNp
	YBPQlFh1zwMkLiKwhVHiYF8fK4jDLDCbWeLV92dMIKOEBJwlfp99xApicwq4SMxcvIgNxBYW
	cJLYevQ9mM0ioCqxoGUJWD2vgIPEg9tPGSFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHG1
	usSjv7ogYREBI4lXN29BlYtI3G14zjqBUWgWkkmzkEyahWTSLCQtCxhZVjGKppYmFxQnpeca
	6RUn5haX5qXrJefnbmKExPLXHYxLj1kdYhTgYFTi4f1QdzRIiDWxrLgy9xCjBAezkghvXDFQ
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA2OTzqyHNqeWp2RKim+ZfeCEb/XGVS031VkV5qdrvt4r
	t/llCE/Z0yCR2iu9IWcUH5conFiY9et01ddnznERTmwfJc9siYlymPZx+/YP86aem3Qq4/NE
	iUmafU6ibvKJWe/OXZFYdDdYiS1Y55ndspDv+svmbHLr4rpw1lhQ+2Gj19WOnKp0e2UlluKM
	REMt5qLiRAD0PKS+wwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

I wanted to ask about your comments to this patchset. As I mentioned 
there are two alternative version where the Exynos 4210 and 4212
support is merged in one file.

I would be grateful if you had some time to look at the patchset
and share your comments.

Best wishes and happy new year!
-- 
Kamil Debski
Samsung R&D Institute Poland


> From: Kamil Debski [mailto:k.debski@samsung.com]
> Sent: Friday, December 20, 2013 2:24 PM
> 
> Hi,
> 
> This is the fifth version of the patchset. It adds a new Exynos USB 2.0
> PHY driver. The driver uses the Generic PHY Framework.
> 
> I would like to thank everyone who contributed with comments and took
> the time to read through the patches in the previous versions of this
> patchset.
> We had a lengthy discussion with Kishon about how the driver should
> look like.
> This patchset contains the updated version of my original idea, where
> support for Exynos 4210 and 4212 is done in separate files. Kishon's
> idea is to join these two into a single file. I have prepared two
> alternative version which I will send soon after this patchset.
> 
> Just like the fourth version this patch depends on:
> [PATCH V11 1/3] ARM: dts: Add pmu sysreg node to exynos5250 and
> exynos5420 dtsi files [1].
> 
> Best wishes,
> Kamil Debski
> 
> [1] - http://www.spinics.net/lists/linux-samsung-soc/msg24528.html
> 
> ----------------
> Changes from v4:
> 1) phy: core: Add an exported of_phy_get function
> - the new exported function of_phy_get was changed to take the phy's
> name as a
>   parameter instead of the index
> 2) phy: core: Add devm_of_phy_get to phy-core
> - fixes made in the comments to devm_of_phy_get
> 3) phy: Add new Exynos USB PHY driver
> - move the documentation from a new to an existing file - samsung-
> phy.txt
> - fix typos and uppercase hex addresses
> - add more explanations to Kconfig (checkpatch still complains, but I
> find it
>   hard to think what else could I add)
> - add selects MFD_SYSCON as the driver needs it (Thank you, Tobias!)
> - cleanup included headers in both *.c and .h files
> - use BIT(x) macro instead of (1 << x)
> - replaced HOST and DEV with PHY0 and PHY1 in phy-exynos4212-usb2.c,
> the
>   registers are described as PHYx in the documentation hence the
> decision to
>   leave the PHYx naming
> - fixed typo in exynos4210_rate_to_clk reg -> *reg
> - change hax_mode_switch and enabled type to bool
> 4) usb: ehci-s5p: Change to use phy provided by the generic phy
> framework
> - Put the issue of phy->otg in order - since the new phy driver does
> not provide
>   this field. With the new driver the switch between host and device is
> done in
>   power_on of the respective host and device phys.
> 5) usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic
> phy
>    framework
> - fixed the example in the documentation
> 6) phy: Add support for S5PV210 to the Exynos USB PHY driver
> - include files cleanup
> - use BIT(x) macro instead of (1 << x)
> 7) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver
> - include files cleanup
> - use BIT(x) macro instead of (1 << x)
> 8) dts: Add usb2phy to Exynos 4
> - no changes
> 9) dts: Add usb2phy to Exynos 5250
> - no changes
> 
> ----------------
> Changes from v3:
> - using PMU and system registers indirectly via syscon
> - change labelling
> - change Kconfig name
> - fixed typos/stray whitespace
> - move of_phy_provider_register() to the end of probe
> - add a regular error return code to the rate_to_clk functions
> - cleanup code and remove unused code
> - change struct names to avoid collisions
> - add mechanism to support multiple phys by the ehci driver
> 
> ----------------
> Changes from v2:
> - rebase all patches to the usb-next branch
> - fixes in the documentation file
>   - remove wrong entries in the phy node (ranges, and #address- &
> #size-cells)
>   - add clocks and clock-names as required properites
>   - rephrase a few sentences
> - fixes in the ehci-exynos.c file
>   - move phy_name variable next to phy in exynos_ehci_hcd
>   - remove otg from exynos_ehci_hcd as it was no longer used
>   - move devm_phy_get after the Exynos5440 skip_phy check
> - fixes in the s3c-hsotg.c file
>   - cosmetic fixes (remove empty line that was wrongfully added)
> - fixes in the main driver
>   - remove cpu_type in favour for a boolean flag matched with the
> compatible
>     value
>   - rename files, structures, variables and Kconfig entires - change
> from simple
>     "uphy" to "usb2_phy"
>   - fix multiline comments style
>   - simplify #ifdefs in of_device_id
>   - fix Kconfig description
>   - change dev_info to dev_dbg where reasonable
>   - cosmetic changes (remove wrongful blank lines)
>   - remove unnecessary reference counting
> 
> ----------------
> Changes from v1:
> - the changes include minor fixes of the hardware initialization of the
> PHY
>   module
> - some other minor fixes were introduced
> 
> ----------------------
> Original cover letter:
> 
> Hi,
> 
> This patch adds a new drive for USB PHYs for Samsung SoCs. The driver
> is using the Generic PHY Framework created by Kishon Vijay Abrahan I.
> It can be found here https://lkml.org/lkml/2013/8/21/29. This patch
> adds support to Exynos4 family of SoCs. Support for Exynos3 and Exynos5
> is planned to be added in the near future.
> 
> I welcome your comments.
> 
> ----------------------
> 
> [1] https://lkml.org/lkml/2013/8/21/29
> 
> Kamil Debski (8):
>   phy: core: Add an exported of_phy_get function
>   phy: core: Add devm_of_phy_get to phy-core
>   phy: Add new Exynos USB PHY driver
>   usb: ehci-s5p: Change to use phy provided by the generic phy
>     framework
>   usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic
>     phy framework
>   phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver
>   dts: Add usb2phy to Exynos 4
>   dts: Add usb2phy to Exynos 5250
> 
> Mateusz Krawczuk (1):
>   phy: Add support for S5PV210 to the Exynos USB PHY driver
> 
>  .../devicetree/bindings/arm/samsung/pmu.txt        |    2 +
>  .../devicetree/bindings/phy/samsung-phy.txt        |   57 +++
>  .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 +
>  Documentation/devicetree/bindings/usb/usb-ehci.txt |   35 ++
>  arch/arm/boot/dts/exynos4.dtsi                     |   31 ++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   17 +
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   17 +
>  arch/arm/boot/dts/exynos5250.dtsi                  |   33 +-
>  drivers/phy/Kconfig                                |   50 +++
>  drivers/phy/Makefile                               |    5 +
>  drivers/phy/phy-core.c                             |   76 +++-
>  drivers/phy/phy-exynos4210-usb2.c                  |  257
> +++++++++++++
>  drivers/phy/phy-exynos4212-usb2.c                  |  306
> +++++++++++++++
>  drivers/phy/phy-exynos5250-usb2.c                  |  406
> ++++++++++++++++++++
>  drivers/phy/phy-s5pv210-usb2.c                     |  199 ++++++++++
>  drivers/phy/phy-samsung-usb2.c                     |  238 ++++++++++++
>  drivers/phy/phy-samsung-usb2.h                     |   69 ++++
>  drivers/usb/gadget/s3c-hsotg.c                     |   11 +-
>  drivers/usb/host/ehci-exynos.c                     |   97 +++--
>  include/linux/phy/phy.h                            |    3 +
>  20 files changed, 1853 insertions(+), 60 deletions(-)  create mode
> 100644 drivers/phy/phy-exynos4210-usb2.c  create mode 100644
> drivers/phy/phy-exynos4212-usb2.c  create mode 100644 drivers/phy/phy-
> exynos5250-usb2.c  create mode 100644 drivers/phy/phy-s5pv210-usb2.c
> create mode 100644 drivers/phy/phy-samsung-usb2.c  create mode 100644
> drivers/phy/phy-samsung-usb2.h
> 
> --
> 1.7.9.5

