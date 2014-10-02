Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaJBOpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:45:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59841 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaJBOo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:44:58 -0400
Date: Thu, 2 Oct 2014 16:44:52 +0200
From: Robert Richter <rric@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL] arm64, thunder: Enable Cavium Thunder SoC Family
Message-ID: <20141002144452.GO20170@rric.localhost>
References: <1410544187-15876-1-git-send-email-rric@kernel.org>
 <20140923104122.GE20170@rric.localhost>
 <20140923104641.GF26472@arm.com>
 <20140923112105.GV30085@e104818-lin.cambridge.arm.com>
 <20140923141429.GH20170@rric.localhost>
 <20141002072938.GM20170@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002072938.GM20170@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

([GIT PULL] in the subject)

On 02.10.14 09:29:38, Robert Richter wrote:
> On 23.09.14 16:14:29, Robert Richter wrote:
> > On 23.09.14 12:21:05, Catalin Marinas wrote:
> > > On Tue, Sep 23, 2014 at 11:46:41AM +0100, Will Deacon wrote:
> > > > On Tue, Sep 23, 2014 at 11:41:22AM +0100, Robert Richter wrote:
> > > > > On 12.09.14 19:49:43, Robert Richter wrote:
> > > > > > From: Robert Richter <rrichter@cavium.com>
> > > > > > 
> > > > > > This initial patches enable Cavium Thunder SoC Family. The patches add
> > > > > > devicetree and Kconfig support and then add Thunder to the defconfig.
> > > > > > 
> > > > > > The Thunder system needs more enablement patches for subsystems and
> > > > > > devices, this includes network, ahci, gicv3/gicv3-its, pci, smmu, kvm.
> > > > > > We will send separate patch sets for these. All of them base on this
> > > > > > initial patches.
> > > > > > 
> > > > > > I sent a separate patch set independently that introduces support for
> > > > > > dts vendor subdirs. After both patch sets have been applied I will
> > > > > > send a patch in addition that moves the dts file into a subdirectory.
> > > > > > 
> > > > > > I sent another separate patch that sets NR_CPUS to 64 per default.
> > > > > > 
> > > > > > The first patch introduces dts files without having a Kconfig option
> > > > > > for the soc (ARCH_THUNDER). However, this is introduced in patch 3 and
> > > > > > added to defconfig in patch 4 as this is my preferred solution. If
> > > > > > there is still resistance having an ARCH_THUNDER option, just drop
> > > > > > them.
> > > > > > 
> > > > > > Patches are available here:
> > > > > > 
> > > > > >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git thunder/init
> > > > > 
> > > > > it would be good if these patches could be applied.
> > > > 
> > > > Catalin's handling the 3.18 merge window, but this looks like arm-soc
> > > > material anyway and should go via Olof/Arnd.
> > > 
> > > Yes. Olof said he's cherry-picking arm64 SoC patches (or Robert could
> > > send him a pull request).
> > 
> > just in case you want to pull, please pull from:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git tags/for-arm-soc-v3.18

Olof, Arnd,

please pull or apply.

Thanks,

-Robert



The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git tags/for-arm-soc-v3.18

for you to fetch changes up to 1200e87a26b6b4fe1f473267c83515117e08ee39:

  arm64, defconfig: Enable Cavium Thunder SoC in defconfig (2014-09-23 15:10:55 +0200)

----------------------------------------------------------------
Enablement patches for Cavium Thunder SoC Family. The patches add
devicetree and Kconfig support and then add Thunder to the defconfig.

----------------------------------------------------------------
Radha Mohan Chintakuntla (3):
      arm64, thunder: Add initial dts for Cavium Thunder SoC
      arm64, thunder: Document devicetree bindings for Cavium Thunder SoC
      arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family

Robert Richter (1):
      arm64, defconfig: Enable Cavium Thunder SoC in defconfig

 Documentation/devicetree/bindings/arm/cavium-thunder.txt |  10 ++++
 Documentation/devicetree/bindings/arm/cpus.txt           |   1 +
 arch/arm64/Kconfig                                       |   5 ++
 arch/arm64/boot/dts/Makefile                             |   1 +
 arch/arm64/boot/dts/thunder-88xx.dts                     |  67 +++++++++++++++++++++
 arch/arm64/boot/dts/thunder-88xx.dtsi                    | 401 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/configs/defconfig                             |   1 +
 7 files changed, 486 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cavium-thunder.txt
 create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
 create mode 100644 arch/arm64/boot/dts/thunder-88xx.dtsi
