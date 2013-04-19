Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3DSJ5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:57:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45937 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab3DSJ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:57:47 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <paul@pwsan.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 0/4] ARM: dts: Add USB host support for Panda and Beagle-xm
Date: Fri, 19 Apr 2013 12:57:33 +0300
Message-ID: <1366365457-28972-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit/Tony

I've consolidated all the USB host device tree patches for Panda and Beagles
to one place and addressed Tony's comments.

NOTE: patch 1 depends on OMAP clock binding introduced in
https://lkml.org/lkml/2013/4/12/407

v3:
- updated mux mode to use pulldowns on panda as non-DT boot uses pulldowns.
- fixed usb pin naming for panda, beagle and beagle-xm

The following changes since commit 1fac4fffa719a98ec1047eaece236244333c9afe:

  ARM: dts: Add OMAP3430 SDP NOR flash memory binding (2013-04-09 00:21:35 +0200)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost-omap-dts

Roger Quadros (4):
      ARM: dts: omap4-panda: Add USB Host support
      ARM: dts: omap3-beagle: Make USB host pin naming consistent
      ARM: dts: omap3-beagle-xm: Add USB Host support
      ARM: dts: omap3-beagle-xm: Add USB host supprot for Rev. Ax/Bx

 arch/arm/boot/dts/omap3-beagle-xm-ab.dts  |   19 ++++++++
 arch/arm/boot/dts/omap3-beagle-xm.dts     |   65 ++++++++++++++++++++++++++++-
 arch/arm/boot/dts/omap3-beagle.dts        |   25 ++++++-----
 arch/arm/boot/dts/omap4-panda-common.dtsi |   58 +++++++++++++++++++++++++
 arch/arm/boot/dts/omap4.dtsi              |    5 ++
 5 files changed, 158 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-beagle-xm-ab.dts

-- 
1.7.4.1

