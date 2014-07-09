Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaGIF7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:59:09 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:58878 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbaGIF7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:59:06 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: "arm@kernel.org" <arm@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        "'Bjorn Helgaas' (bhelgaas@google.com)" <bhelgaas@google.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mark Nicholson <mark@nicholnet.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "Arnd Bergmann (arnd@arndb.de)" <arnd@arndb.de>
Date: Wed, 9 Jul 2014 13:58:41 +0800
Subject: RE: [GIT PULL] ARM: SPEAr1310 PCIe updates
Thread-Topic: [GIT PULL] ARM: SPEAr1310 PCIe updates
Thread-Index: Ac+bOQmNHftFNS/3QAWQP2M4WgZk3QAAUdSQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48FE@EAPEX1MAIL1.st.com>
References: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48F2@EAPEX1MAIL1.st.com>
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E48F2@EAPEX1MAIL1.st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-09_02:2014-07-08,2014-07-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s695xOLY026575

+ arm@kernel.org

Sorry for previous mail addressed to Olof's personal id.

Thanks
Mohit

> -----Original Message-----
> From: Mohit KUMAR DCG
> Sent: Wednesday, July 09, 2014 11:18 AM
> To: olof@lixom.net
> Cc: Bartlomiej Zolnierkiewicz; Pratyush ANAND; 'Bjorn Helgaas'
> (bhelgaas@google.com); spear-devel; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; linux-pci@vger.kernel.org; Mark Nicholson;
> Viresh Kumar
> Subject: [GIT PULL] ARM: SPEAr1310 PCIe updates
> 
> Hello Olof,
> 
> Please pull PCIe updates for ST's SPEAr1310 SoC.
> 
> Last version of posted V8 patches have been Acked-by respective
> maintainers.
> https://lkml.org/lkml/2014/4/15/260
> 
> Apart from arch/arm/ changes, it also contains patches for drivers/{pci|phy}.
> Bjorn advised to get complete series via arm-soc tree.
> http://www.spinics.net/lists/linux-pci/msg30271.html
> 
>  Regards
>  Mohit
> 
> The following changes since commit
> 4c834452aad01531db949414f94f817a86348d59:
>   Linus Torvalds (1):
>         Linux 3.16-rc3
> 
> are available in the git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/vireshk/linux.git
> spear/pcie-support-v8
> 
> Mohit Kumar (1):
>       SPEAr13xx: defconfig: Update
> 
> Pratyush Anand (8):
>       clk: SPEAr13XX: Fix pcie clock name
>       SPEAr13XX: Fix static mapping table
>       phy: SPEAr1310/40-miphy: Add binding information
>       SPEAr: misc: Add binding information
>       phy: SPEAr1310/40-miphy: Add phy driver for PCIe and SATA
>       SPEAr13XX: Add binding information for PCIe controller
>       SPEAr13XX: dts: Add PCIe node information
>       pcie: SPEAr13xx: Add designware wrapper support
> 
>  .../devicetree/bindings/arm/spear-misc.txt         |    9 +
>  .../devicetree/bindings/pci/spear13xx-pcie.txt     |   14 +
>  .../devicetree/bindings/phy/st-spear1310-miphy.txt |   12 +
>  .../devicetree/bindings/phy/st-spear1340-miphy.txt |   11 +
>  MAINTAINERS                                        |    6 +
>  arch/arm/boot/dts/spear1310-evb.dts                |    4 +
>  arch/arm/boot/dts/spear1310.dtsi                   |   93 +++++-
>  arch/arm/boot/dts/spear1340-evb.dts                |    4 +
>  arch/arm/boot/dts/spear1340.dtsi                   |   30 ++-
>  arch/arm/boot/dts/spear13xx.dtsi                   |    9 +-
>  arch/arm/configs/spear13xx_defconfig               |   16 +
>  arch/arm/mach-spear/Kconfig                        |    4 +
>  arch/arm/mach-spear/include/mach/spear.h           |    4 +-
>  arch/arm/mach-spear/spear1340.c                    |  127 +------
>  arch/arm/mach-spear/spear13xx.c                    |    2 +-
>  drivers/clk/spear/spear1310_clock.c                |    6 +-
>  drivers/clk/spear/spear1340_clock.c                |    2 +-
>  drivers/pci/host/Kconfig                           |    8 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pcie-spear13xx.c                  |  406 ++++++++++++++++++++
>  drivers/phy/Kconfig                                |   12 +
>  drivers/phy/Makefile                               |    2 +
>  drivers/phy/phy-spear1310-miphy.c                  |  274 +++++++++++++
>  drivers/phy/phy-spear1340-miphy.c                  |  300 +++++++++++++++
>  24 files changed, 1217 insertions(+), 139 deletions(-)  create mode 100644
> Documentation/devicetree/bindings/arm/spear-misc.txt
>  create mode 100644 Documentation/devicetree/bindings/pci/spear13xx-
> pcie.txt
>  create mode 100644 Documentation/devicetree/bindings/phy/st-
> spear1310-miphy.txt
>  create mode 100644 Documentation/devicetree/bindings/phy/st-
> spear1340-miphy.txt
>  create mode 100644 drivers/pci/host/pcie-spear13xx.c  create mode 100644
> drivers/phy/phy-spear1310-miphy.c  create mode 100644 drivers/phy/phy-
> spear1340-miphy.c
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
