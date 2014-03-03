Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaCCOzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:55:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41330 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbaCCOvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:51:09 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>, <nm@ti.com>,
        <balajitk@ti.com>, <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND Patch 0/9] dts pending patches for TI omap
Date: Mon, 3 Mar 2014 20:20:17 +0530
Message-ID: <1393858226-32595-2-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit/Tony

Here I am send all the pending patches that can go into 3.15 merge window,
all the patches were already posted to mailing list and has beed reviewed.

Here I am rebasing the patches on top of
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git omap-for-v3.15/dt
and fixed all the merge conflicts.

Here I am pasting the mail archieve for the patches series

* Add ABB device nodes
http://linux-kernel.2935.n7.nabble.com/PATCH-0-4-ARM-dts-OMAP3630-Add-ABB-device-nodes-td794852.html

* MMC hot plug support
http://mail.blameitonlove.com/lists/linux-omap/msg101933.html
Dropped [PATCH 2/3] ARM: dts: am335x-evmsk: add SD card hotplug support as this
is already merged with commit id 29ea5efb0bb612d352aa360de26e2095cb230e4a

* DRA7 Cross bar DTS patches
Cross bar driver has been pulled for next merge, so the dts patches can also
be pulled for next merge window.

Here is the pull request for the same set.


The following changes since commit f777ba1780584b100ab9664cc06d04f3bb273a84:

  Merge tag 'for_3.15/dts_signed' of git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt into omap-for-v3.15/dt (2014-03-02 14:22:03 -0800)

are available in the git repository at:


  git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git omapdt-for-3.15

for you to fetch changes up to 5f78b45aa45c5b2c4de895c3b0740fda4684dae4:

  ARM: DTS: DRA7: Add routable-irqs property for gic node (2014-03-03 19:53:25 +0530)

----------------------------------------------------------------
Andrii.Tseglytskyi (2):
      ARM: dts: OMAP36xx: Add device node for ABB
      ARM: dts: OMAP4: Add device nodes for ABB

Balaji T K (3):
      ARM: dts: am437x gp-evm: add sd card dt nodes
      ARM: dts: am335x-evm: add SD card hotplug support
      ARM: dts: am43x-epos-evm: add SD card hotplug support

Nishanth Menon (1):
      ARM: dts: DRA7: Add device nodes for ABB

Sricharan R (3):
      ARM: DTS: DRA7: Add crossbar device binding
      ARM: DTS: DRA7: Replace peripheral interrupt numbers with crossbar inputs
      ARM: DTS: DRA7: Add routable-irqs property for gic node

 arch/arm/boot/dts/am335x-evm.dts     |   9 ++
 arch/arm/boot/dts/am4372.dtsi        |   1 +
 arch/arm/boot/dts/am437x-gp-evm.dts  |  27 +++++
 arch/arm/boot/dts/am43x-epos-evm.dts |   9 ++
 arch/arm/boot/dts/dra7.dtsi          | 227 ++++++++++++++++++++++++++++-------
 arch/arm/boot/dts/omap36xx.dtsi      |  20 +++
 arch/arm/boot/dts/omap4.dtsi         |  26 ++++
 arch/arm/boot/dts/omap443x.dtsi      |  26 ++++
 arch/arm/boot/dts/omap4460.dtsi      |  37 ++++++
 9 files changed, 339 insertions(+), 43 deletions(-)

-- 
1.9.0
