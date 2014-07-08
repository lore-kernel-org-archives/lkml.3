Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaGHDwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:52:21 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:55676 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbaGHDwT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:52:19 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pratyush ANAND <pratyush.anand@st.com>
Cc: "Arnd Bergmann (arnd@arndb.de)" <arnd@arndb.de>,
        "'Bjorn Helgaas' (bhelgaas@google.com)" <bhelgaas@google.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mark Nicholson <mark@nicholnet.com>
Date: Tue, 8 Jul 2014 11:51:59 +0800
Subject: RE: [PATCH V8 0/9] PCI: Add SPEAr13xx PCie support
Thread-Topic: [PATCH V8 0/9] PCI: Add SPEAr13xx PCie support
Thread-Index: Ac+Z+HdPxnacJWr/TI+67tfeXbT9QgAZmtcQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E45ED@EAPEX1MAIL1.st.com>
References: <cover.1397555158.git.mohit.kumar@st.com>
 <2CC2A0A4A178534D93D5159BF3BCB6619B94997E2B@EAPEX1MAIL1.st.com>
 <20140522113119.GA2646@pratyush-vbox> <8677743.Bty96DiF3F@amdc1032>
In-Reply-To: <8677743.Bty96DiF3F@amdc1032>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-08_02:2014-07-07,2014-07-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bartlomiej,

> -----Original Message-----
> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Monday, July 07, 2014 9:01 PM
> To: Pratyush ANAND
> Cc: Arnd Bergmann (arnd@arndb.de); 'Bjorn Helgaas'
> (bhelgaas@google.com); Mohit KUMAR DCG; spear-devel; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; linux-
> pci@vger.kernel.org; Mark Nicholson
> Subject: Re: [PATCH V8 0/9] PCI: Add SPEAr13xx PCie support
> 
> 
> Hi Arnd,
> 
> Any update on status of this patchset?  Is it OK for it to go through arm-soc
> tree or should it be splitted into separate parts which would go through
> pci/phy/arm-soc trees?

- These patches are rebased over 3-16-rc3 to go through arm-soc tree.
Somehow we are having 'sync' issue in providing web link for spear public
repository with these patches. 

It will be resolve soon, and I will provide the link.

> 
> [ The patchset applies fine to next-20140707 after fixing trivial
>   reject in drivers/pci/host/Makefile in patch #8.  To make it build
>   the following line from patch #8 needs to be dropped:
> 
>   +       spin_lock_init(&pp->conf_lock);

- yes, I have already considered this while rebasing.

Thanks
Mohit

> ]
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> On Thursday, May 22, 2014 05:01:19 PM Pratyush Anand wrote:
> > Hi Arnd/Bjorn,
> >
> > On Mon, May 19, 2014 at 07:55:12PM +0800, Mohit KUMAR wrote:
> > > Hello Arnd,
> > >
> > > > -----Original Message-----
> > > > From: Mohit KUMAR DCG
> > > > Sent: Tuesday, April 15, 2014 5:20 PM
> > > > To: spear-devel; linux-kernel@vger.kernel.org;
> > > > devicetree@vger.kernel.org; linux-pci@vger.kernel.org;
> > > > linux-arm-kernel@lists.infradead.org
> > > > Cc: Mohit KUMAR DCG
> > > > Subject: [PATCH V8 0/9] PCI: Add SPEAr13xx PCie support
> > > >
> > > > Patch# 1 and 2: Improvement and fixes for SPEAr13xx support.
> > > > Patch# 3,4 and 6: Add DT bindings for spear1310/40-miphy, misc and
> > > > pcie node Patch# 5: Add spear1310/40-miphy driver and support for
> > > > spear1310/40 miphy wrapper.
> > > > Patch# 7-9: Add SPEAr13xx PCIe driver and dt support.
> > > >
> > > > These pathes are tested with linux-3.15 tag of arm-soc tree.
> > > > Tested with SPEAr1310 evaluation board with:
> > > > 	- INTEL PRO 100/100 EP card
> > > > 	- USB xhci gen2 card
> > > >  	- Above cards connected through LeCROY PTC switch
> > > >
> > > > Modifications for SATA are tested with SPEAr1340-evb board
> > > >
> > >
> > > I think 3.16 windows is about to close, are you planning to merge this
> series?
> > > Pls let me know if something pending on our part.
> >
> > If you could let us know the status of this patch series inclusion.
> >
> > Regards
> > Pratyush
> >
> > >
> > > Regards
> > > Mohit
> > >
> > > > Changes since v7:
> > > > - Rebase over for-linus-3.15 tag of arm-soc tree so that complete
> > > > patch series can be applied cleanly.
> > > > - Incorporated few comments on comment style and superfluous
> > > > comments Changes since v6:
> > > > - Split miphy driver for SPEAr1310 and SPEAr1340
> > > > - Some cleanup and incorporated other minor comments Changes since
> v5:
> > > > - Split DT bindings for misc, miphy-40lp and pcie node into
> > > > sepearte patches
> > > > - Merge config options PCIE_SPEAR13XX and PCI_MSI into defconfig
> > > > patch
> > > > - Incorporated other minor comments Changes since v4:
> > > > - Uses per device function pointers passed from .data field to
> > > >   the of_device_id instead of of_device_is_compatible.
> > > > - Incorporated other minor comments from v4
> > > >
> > > > Changes since v3:
> > > > - Phy driver renamed to phy-miphy40lp
> > > > - ahci phy hook patch used as suggested by Arnd
> > > > - Incorporated other minor comments from v3
> > > >
> > > > Changes since v2:
> > > > - Incorporated comments to move SPEAr13xx PCIe and SATA phy
> > > > specific routines to
> > > >   the phy framework
> > > > - Modify ahci driver to include phy hooks
> > > > - phy-core driver modifications for subsys_initcall()
> > > >
> > > > Changes since v1:
> > > > - Few patches of the series are already accepted and applied to
> mainline e.g.
> > > >  pcie designware driver improvements,fixes for IO translation bug,
> > > > PCIe dw driver maintainer. So dropped these from v2.
> > > > - Incorporated comment to move the common/reset PCIe code to the
> > > > seperate driver
> > > > - PCIe and SATA share common PHY configuration registers, so move
> > > > SATA platform code to the system config driver Fourth patch is
> > > > improves pcie designware driver and fixes the IO translation bug.
> > > > IO translation bug fix leads to the working of PCIe EP devices connected
> to RC through switch.
> > > >
> > > > Mohit Kumar (1):
> > > >   SPEAr13xx: defconfig: Update
> > > >
> > > > Pratyush Anand (8):
> > > >   clk: SPEAr13XX: Fix pcie clock name
> > > >   SPEAr13XX: Fix static mapping table
> > > >   phy: SPEAr1310/40-miphy: Add binding information
> > > >   SPEAr: misc: Add binding information
> > > >   phy: SPEAr1310/40-miphy: Add phy driver for PCIe and SATA
> > > >   SPEAr13XX: Add binding information for PCIe controller
> > > >   SPEAr13XX: dts: Add PCIe node information
> > > >   pcie: SPEAr13xx: Add designware wrapper support
> > > >
> > > >  .../devicetree/bindings/arm/spear-misc.txt         |    9 +
> > > >  .../devicetree/bindings/pci/spear13xx-pcie.txt     |   14 +
> > > >  .../devicetree/bindings/phy/st-spear1310-miphy.txt |   12 +
> > > >  .../devicetree/bindings/phy/st-spear1340-miphy.txt |   11 +
> > > >  MAINTAINERS                                        |    6 +
> > > >  arch/arm/boot/dts/spear1310-evb.dts                |    4 +
> > > >  arch/arm/boot/dts/spear1310.dtsi                   |   93 +++++-
> > > >  arch/arm/boot/dts/spear1340-evb.dts                |    4 +
> > > >  arch/arm/boot/dts/spear1340.dtsi                   |   30 ++-
> > > >  arch/arm/boot/dts/spear13xx.dtsi                   |    9 +-
> > > >  arch/arm/configs/spear13xx_defconfig               |   16 +
> > > >  arch/arm/mach-spear/Kconfig                        |    4 +
> > > >  arch/arm/mach-spear/include/mach/spear.h           |    4 +-
> > > >  arch/arm/mach-spear/spear1340.c                    |  127 +------
> > > >  arch/arm/mach-spear/spear13xx.c                    |    2 +-
> > > >  drivers/clk/spear/spear1310_clock.c                |    6 +-
> > > >  drivers/clk/spear/spear1340_clock.c                |    2 +-
> > > >  drivers/pci/host/Kconfig                           |    8 +
> > > >  drivers/pci/host/Makefile                          |    1 +
> > > >  drivers/pci/host/pcie-spear13xx.c                  |  407
> ++++++++++++++++++++
> > > >  drivers/phy/Kconfig                                |   12 +
> > > >  drivers/phy/Makefile                               |    2 +
> > > >  drivers/phy/phy-spear1310-miphy.c                  |  274 +++++++++++++
> > > >  drivers/phy/phy-spear1340-miphy.c                  |  300 ++++++++++++++
> > > >  24 files changed, 1218 insertions(+), 139 deletions(-)  create
> > > > mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt
> > > >  create mode 100644
> > > > Documentation/devicetree/bindings/pci/spear13xx-
> > > > pcie.txt
> > > >  create mode 100644 Documentation/devicetree/bindings/phy/st-
> > > > spear1310-miphy.txt
> > > >  create mode 100644 Documentation/devicetree/bindings/phy/st-
> > > > spear1340-miphy.txt
> > > >  create mode 100644 drivers/pci/host/pcie-spear13xx.c  create mode
> > > > 100644 drivers/phy/phy-spear1310-miphy.c  create mode 100644
> > > > drivers/phy/phy- spear1340-miphy.c

