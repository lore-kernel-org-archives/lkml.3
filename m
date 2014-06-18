Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaFRAbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:31:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51577 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaFRAbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:31:35 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-f6-53a0dde47414
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Murali Karicheri'" <m-karicheri2@ti.com>
Cc: "'linux-arm'" <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
 <CAErSpo6=vi0SR0A3u5BCLgiGxoH48N5R=e8VAnFDG=K61qLxnw@mail.gmail.com>
In-reply-to: <CAErSpo6=vi0SR0A3u5BCLgiGxoH48N5R=e8VAnFDG=K61qLxnw@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
Date: Wed, 18 Jun 2014 09:31:31 +0900
Message-id: <003f01cf8a8c$a6f3be00$f4db3a00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+KiYVib/UUKXa6RciEbBiK1wPFgwAAaHmA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSWUxTURCGc3oXCkJyZZEDCUpqkEACylI8CriEqJcXNRJ90EQoeANEltqC
	+iaLgiAUBKGxKrSIrBWwmJSIBQQEArJWARFRVhe2BBskbFp6Memrb9+Z+Wf+PyfDxSxnCHtu
	ZEwcI4oRRPFIM7xrc8bLbeqzPOjA2m9ztJHTZoKKkyLQj2YXVNjaQ6CsOQWBmtbrAOr5WQ6Q
	VjFAoL7pDBKpJgcJpEgpxpH21WMSdRe0k+iT1gJJMptINJeSCNCzoX4OepG3ClC29DmOUgf2
	okmZFZofleLojqbVBM1KlNgxSCsLlIC+nZxB0murOYDWSjI5dIGsA6c3W7I4tFwVT5eX6ki6
	tsyVVlWkkfTo4Gv9q/gWLXlZAejpFQ1Gtw+rOfQv1e6z1EUzvytMVOR1RrT/SIhZxJPsfFyo
	dbvZNraOJYBhXjow5ULKGz4dqcJY3gX7xqrJdGDGtaRKAHzYPwL+iTqXsgwiS0oK4NIKwYrW
	AHycr8C3GiS1D+p0LSZbbE2dh9Nr64Y6RtWQsLjLkR1IBzAnU2fYakoFwfGSDwaRFXUUamuU
	hmGccoKNvX3EFltQ/jB1IBdneSdcyR3bXuoMcwqKMJb3wFrlvJ65+qTOcGLDjc3gCcfk3wAr
	sYYN3xfAVgZIlZrCjso0DutFweXcZpyddYCqpu2fsINvyobxbABlRs4yI2eZkbPMyEIO8Apg
	wwjDhOLQcJGnu1gQLY6PCXcPi41WAfbGJHXgY5NvMwjT29/H7G3CYvU3GBMX7OHl44n43nwv
	z4OHfP6vzLO1KBoPPWdJhQvimKsMI2REwaL4KEbcDDhcU/sEcMIpqX2Sf2NRPbRjdDHx/aBX
	x5lqv5OPHHMb/FvGXQJq+ZUap9kq/obL5S+dd6OX70lTCJlKrbb17b+W/ifa52swPRECNRe0
	5r3EJbvChcLDpOQ4mdkdX6tOSnY4rXsQGDDHSAMTFC31to2uMEJVf8rt7ZRjZY9CEjwSGpT3
	joeLIwQerphILPgLZp90hHkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsVy+t9jQd0ndxcEG0z7wGLxd9IxdoslTRkW
	Lw9pWsw/co7Vov/NQlaLA392MFqce7WS0eLywkusFhee9rBZbHp8jdViYdsSFovLu+awWZyd
	d5zN4vZlXou+3gNsFm/aGhktll6/yGSxceovRosJ09eyWLRfUrZ4PEvY4u2d6SwWrXuPsFu8
	7lvD7CDhsWbeGkaPluYeNo/fvyYxelzu62XymDfrBIvHv8P9TB4LNpV6rFz+hc1j8wotj02r
	Otk87lzbA+Qtqffo27KK0ePpj73MHsdvbGfy+LxJLkAgqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwcYFkoKZYk5pUChgMTiYiV9O0wTQkPcdC1g
	GiN0fUOC4HqMDNBAwjrGjLkTprEUXNatOHbvD3MD4w2lLkZODgkBE4lTn/qZIWwxiQv31rOB
	2EIC0xklPv1g7WLkArJ/M0rMmbaQBSTBJqAm8eXLYXYQW0QgVOLp7z9gcWaBDWwSS04rQDR0
	MUpM6v3CCJLgFAiWeLjsKliRsIC9xOUNa8CaWQRUJfafv8AKYvMK2Eq0X5rMAmELSvyYfA9q
	qLrEpHmLmCFseYnNa94C2RxAl6pLPPqrC3GDkcS9Bc8ZIUpEJPa9eMc4gVFoFpJJs5BMmoVk
	0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCfJZ1I7GFc2WBxiFOBgVOLh5chd
	ECzEmlhWXJl7iFGCg1lJhFflHFCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84EJPK8k3tDY
	xMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGO31nu8u847+8bmviEcg
	lPn9lTXupRG3G/p/Cfd/N654PofxoFiMVPyNtKV2J7eKfA3YFaP55/Ova9ruvaVyXRmN05kz
	Flt4MJwLXd8e6aCZtohrufxUO0bdytOTuh8kTeDiOaCfzcvUsWHLlaxDp3zuvX2zcPOqGTuV
	RWy5Cp9dTdU/f22dtBJLcUaioRZzUXEiALzw5zHWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 9:09 AM, Bjorn Helgaas wrote:
> 
> On Tue, Jun 10, 2014 at 02:51:19PM -0400, Murali Karicheri wrote:
> > This patch adds a PCIe controller driver for Keystone SoCs. This
> > is based on v1 of the series posted to the mailing list.
> >
> > CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > CC: Russell King <linux@arm.linux.org.uk>
> > CC: Grant Likely <grant.likely@linaro.org>
> > CC: Rob Herring <robh+dt@kernel.org>
> > CC: Mohit Kumar <mohit.kumar@st.com>
> > CC: Jingoo Han <jg1.han@samsung.com>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Pratyush Anand <pratyush.anand@st.com>
> > CC: Richard Zhu <r65037@freescale.com>
> > CC: Kishon Vijay Abraham I <kishon@ti.com>
> > CC: Marek Vasut <marex@denx.de>
> > CC: Arnd Bergmann <arnd@arndb.de>
> > CC: Pawel Moll <pawel.moll@arm.com>
> > CC: Mark Rutland <mark.rutland@arm.com>
> > CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> > CC: Kumar Gala <galak@codeaurora.org>
> > CC: Randy Dunlap <rdunlap@infradead.org>
> > CC: Grant Likely <grant.likely@linaro.org>
> >
> >
> > Changelog:
> >
> > V2
> >  - Split the designware pcie enhancement patch to multiple
> >    patches based on functionality added
> >  - Remove the quirk code and add a patch to fix mps/mrss
> >    tuning for ARM. Use kernel command line parameter
> >    pci=pcie_bus_perf to work with Keystone PCI Controller.
> >    Following patch addressed this.
> >      [PATCH v1] ARM: pci: add call to pcie_bus_configure_settings()
> >  - Add documentation for device tree bindings
> >  - Add separate interrupt controller nodes for MSI and Legacy
> >    IRQs and use irq map for legacy IRQ
> >  - Use compatibility to identify v3.65 version of the DW hardware
> >    and use it to customize the designware common code.
> >  - Use reg property for configuration space instead of range
> >  - Other minor updates based on code inspection.
> >
> > V1
> >  - Add an interrupt controller node for Legacy irq chip and use
> >    interrupt map/map-mask property to map legacy IRQs A/B/C/D
> >  - Add a Phy driver to replace the original serdes driver
> >  - Move common application register handling code to a separate
> >    file to allow re-use across other platforms that use older
> >    DW PCIe h/w
> >  - PCI quirk for maximum read request size. Check and override only
> >    if the maximum is higher than what controller can handle.
> >  - Converted to a module platform driver.
> >
> >
> > Murali Karicheri (8):
> >   PCI: designware: add rd[wr]_other_conf API
> >   PCI: designware: refactor host init code to re-use on v3.65 DW pci hw
> >   PCI: designware: update pcie core driver to work with dw hw version
> >     3.65
> >   PCI: designware: add msi controller functions for v3.65 hw
> >   PCI: designware: add PCI controller functions for v3.65 DW hw
> >   phy: Add serdes phy driver for keystone
> >   PCI: keystone: add pcie driver based on designware core driver
> >   ARM: keystone: add pcie related options
> >
> >  .../devicetree/bindings/pci/designware-pcie.txt    |   42 ++
> >  .../devicetree/bindings/pci/pci-keystone.txt       |   56 +++
> >  .../bindings/phy/phy-keystone-serdes.txt           |   25 ++
> >  arch/arm/mach-keystone/Kconfig                     |    1 +
> >  drivers/pci/host/Kconfig                           |   12 +
> >  drivers/pci/host/Makefile                          |    2 +
> >  drivers/pci/host/pci-dw-v3_65-msi.c                |  149 +++++++
> >  drivers/pci/host/pci-dw-v3_65.c                    |  390 ++++++++++++++++++
> >  drivers/pci/host/pci-dw-v3_65.h                    |   34 ++
> >  drivers/pci/host/pci-keystone.c                    |  418 ++++++++++++++++++++
> >  drivers/pci/host/pcie-designware.c                 |  175 +++++---
> >  drivers/pci/host/pcie-designware.h                 |   42 +-
> >  drivers/phy/Kconfig                                |    6 +
> >  drivers/phy/Makefile                               |    1 +
> >  drivers/phy/phy-keystone-serdes.c                  |  230 +++++++++++
> >  15 files changed, 1531 insertions(+), 52 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
> >  create mode 100644 Documentation/devicetree/bindings/phy/phy-keystone-serdes.txt
> >  create mode 100644 drivers/pci/host/pci-dw-v3_65-msi.c
> >  create mode 100644 drivers/pci/host/pci-dw-v3_65.c
> >  create mode 100644 drivers/pci/host/pci-dw-v3_65.h
> >  create mode 100644 drivers/pci/host/pci-keystone.c
> >  create mode 100644 drivers/phy/phy-keystone-serdes.c
> 
> I'm not willing to merge phy-keystone-serdes.c because I don't
> maintain drivers/phy and because of the binary blob of register values
> it contains, but maybe somebody else will.  I assume it could be
> merged by itself before the rest of this.

I think so, too.

DT maintainers and arch maintainers should review the following
dt bindings.
  .../devicetree/bindings/pci/designware-pcie.txt    |   42 ++
  .../devicetree/bindings/pci/pci-keystone.txt       |   56 +++

Generic PHY maintainer (Kishon Vijay Abraham I) should review the
following phy driver.
  drivers/phy/phy-keystone-serdes.c

> 
> I'm looking for acks from Mohit and/or Jingoo for the pci/host
> changes, and from Arnd for the devicetree/bindings changes.
> 
> Adding these "-dw-3_64" files is sort of ugly.  If that code is only
> used by keystone, maybe it could just be moved to pci-keystone.c?  But
> I'll defer to Mohit and Jingoo on that and the way you modify
> pcie-designware.c.

I agree with Bjorn Helgaas's opinion. These three "-dw-3_64" files
look terrible! I don't have a good way to handle this; however,
moving this code to pci-keystone.c looks better.

Best regards,
Jingoo Han

> 
> Bjorn

