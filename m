Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbaKUKRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:17:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49543 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbaKUKRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:17:11 -0500
From: Vignesh R <vigneshr@ti.com>
To: Paul Walmsley <paul@pwsan.com>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vignesh R <vigneshr@ti.com>
Subject: [PATCH v3 0/2] Add support for ADC on am437x-gp and am43x-epos-evm
Date: Fri, 21 Nov 2014 15:44:20 +0530
Message-ID: <1416564862-23056-1-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches enable ADC on am437x-gp-evm and am43x-epos-evm.
tscadc DT node has been added to am437x-gp and am43x-epos DT files.
With these patches, ADC functionalities are now available on am43xx.

Change log:

v3:
Add ADC hwmod data to AM43xx hwmod file instead
of sharing hwmod structures betweem AM33xx and
AM43xx.

v2:
Removed phy addresses in hwmod. Using DT instead.
Removed unused "ti,am4372" compatible string.
Use macro to set clk domain name.
Fixed subject format of all patches


Vignesh R (2):
  ARM: OMAP2+: hwmod: AM43x: add hwmod support for ADC on AM43xx
  ARM: dts: AM43xx: add tscadc DT entries for am437x-evm and
    am43x-epos-evm

 arch/arm/boot/dts/am4372.dtsi              | 20 +++++++++++++++
 arch/arm/boot/dts/am437x-gp-evm.dts        |  8 ++++++
 arch/arm/boot/dts/am43x-epos-evm.dts       |  8 ++++++
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 39 ++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

-- 
1.9.1

