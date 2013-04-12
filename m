Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3DLO3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:29:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40372 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3DLO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:29:29 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v4 0/5]  LPAE remaining device tree file
Date: Fri, 12 Apr 2013 16:29:05 +0200
Message-Id: <1365776950-30094-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

I have just rebased the commits that you haven't applied yet. They are
rebased on mvebu/dt. I check that all the dtb can be built.

Thanks,

Gregory CLEMENT (3):
  ARM: dts: mvebu: Convert all the mvebu files to use the range
    property
  ARM: dts: mvebu: introduce internal-regs node
  ARM: dts: mvebu: Convert mvebu device tree files to 64 bits

Thomas Petazzoni (2):
  ARM: dts: mvebu: fix cpus section indentation
  ARM: dts: mvebu: move all peripherals inside soc

 arch/arm/boot/dts/armada-370-db.dts              |  134 +++---
 arch/arm/boot/dts/armada-370-mirabox.dts         |  176 ++++----
 arch/arm/boot/dts/armada-370-rd.dts              |   96 ++---
 arch/arm/boot/dts/armada-370-xp.dtsi             |  336 +++++++--------
 arch/arm/boot/dts/armada-370.dtsi                |  330 +++++++--------
 arch/arm/boot/dts/armada-xp-db.dts               |  202 ++++-----
 arch/arm/boot/dts/armada-xp-gp.dts               |  222 +++++-----
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         |  284 ++++++-------
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         |  342 +++++++--------
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         |  484 +++++++++++-----------
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  262 ++++++------
 arch/arm/boot/dts/armada-xp.dtsi                 |  202 ++++-----
 12 files changed, 1549 insertions(+), 1521 deletions(-)

-- 
1.7.9.5

