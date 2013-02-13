Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3BMJ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:28:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50186 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3BMJ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:28:15 -0500
From: Sourav Poddar <sourav.poddar@ti.com>
To: <balbi@ti.com>, <santosh.shilimkar@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 0/5] omap[4/5] I2c/Spi dts patches
Date: Wed, 13 Feb 2013 14:58:00 +0530
Message-ID: <1360747680-1438-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, 

These patches were send as seperate ones before[1], but did not recieve any 
comments. Resending them all as a single patch series, as some affect the same files.
[1]: https://patchwork.kernel.org/patch/2054891/
     https://patchwork.kernel.org/patch/2054871/ 
     https://patchwork.kernel.org/patch/2070991/ 	
     https://patchwork.kernel.org/patch/2089751/
     http://www.spinics.net/lists/linux-omap/msg86137.html	 

If you are Ok with the patch and there are no comments, Can it be picked?
	
The following changes since commit 6edacf05c8362f4c368991b55d85e8122cfc9a24:

  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-02-04 16:58:41 +1100)

are available in the git repository at:

  git@gitorious.org:linux-connectivity/linux-connectivity.git spi_i2c_dev

Felipe Balbi (1):
      arm: dts: omap5: add SPI devices to OMAP5 DeviceTree file

Sourav Poddar (4):
      arm: dts: omap4-sdp: Add I2c pinctrl data
      arm: dts: omap5-evm: Add I2c pinctrl data
      arm: dts: omap4-panda: Add I2c pinctrl data
      arm: dts: omap5-evm: Add mcspi data

 arch/arm/boot/dts/omap4-panda.dts |   40 ++++++++++++++
 arch/arm/boot/dts/omap4-sdp.dts   |   40 ++++++++++++++
 arch/arm/boot/dts/omap5-evm.dts   |  108 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap5.dtsi      |   40 ++++++++++++++
 4 files changed, 228 insertions(+), 0 deletions(-)
