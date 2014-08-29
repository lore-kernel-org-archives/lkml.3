Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaH2JOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:14:11 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:43156 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaH2JOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:14:07 -0400
Date: Fri, 29 Aug 2014 10:13:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Arnaud Ebalard <arno@natisbad.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jonathan Cameron <jic23@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        LINUX SH <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Mark Brown <broonie@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin Fuzzey <mfuzzey@parkeon.com>, Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Silvio F <silvio.fricke@gmail.com>, Simon Horman <horms@verge.net.au>,
        Support Opensource <support.opensource@diasemi.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [GIT PULL] MFD: ARM (IMX & R8): Immutable branch for Dialog
 Semiconductor - vendor prefix consolidation
Message-ID: <20140829091359.GF24579@lee--X1>
References: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMX and R8 sub-arch Maintainers,

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-arm-v3.18

for you to fetch changes up to bd597f47ca4bf7a522a0298a95c7f9b2f0a75b9e:

  devicetree: Dialog Semiconductor consolidate existing vendor prefixes to standardise on 'dlg' (2014-08-29 09:26:29 +0100)

----------------------------------------------------------------
Immutable branch between MFD and some ARM sub-arch maintainers.
----------------------------------------------------------------
Steve Twiss (1):
      devicetree: Dialog Semiconductor consolidate existing vendor prefixes to standardise on 'dlg'

 .../devicetree/bindings/i2c/trivial-devices.txt    |  2 +-
 .../devicetree/bindings/regulator/da9210.txt       |  4 ++--
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/boot/dts/imx53-smd.dts                    |  2 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  2 +-
 arch/arm/boot/dts/r8a7790-lager.dts                |  2 +-
 arch/arm/boot/dts/r8a7791-koelsch.dts              |  2 +-
 drivers/mfd/da9055-core.c                          | 26 +++++++++++-----------
 8 files changed, 21 insertions(+), 20 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
