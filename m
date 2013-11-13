Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab3KMR44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:56:56 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:43859 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3KMR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:56:48 -0500
Date: Wed, 13 Nov 2013 18:56:43 +0100
From: Robert Richter <rric@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: [GIT PULL] edac/calxeda changes for v3.13
Message-ID: <20131113175643.GS7429@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git tags/edac_calxeda_for_3.13

with updates for edac.

The patches mostly contain updates for the Calxeda Highbank driver. I
will maintain this driver in the future, so I also added a MAINTAINERS
file update which was acked by Rob Herring and Borislav Petkov.

Note that I have used my oprofile tree for this pull request, though
these changes are not related to oprofile. This tree was available to
me for putting the changes into linux-next. I am currently in the
process to setup a more generic tree for future use that is also
pulled by linux-next.

Thanks,

-Robert




The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

  Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git tags/edac_calxeda_for_3.13

for you to fetch changes up to 78cfbf0bbf6e085fd71e156c6147d205fba29f2b:

  edac, highbank: Moving error injection to sysfs for edac (2013-11-04 17:01:11 -0600)

----------------------------------------------------------------
edac_calxeda_for_3.13

----------------------------------------------------------------
Rob Herring (1):
      ARM: dts: calxeda: move memory-controller node out of ecx-common.dtsi

Robert Richter (6):
      edac, highbank: Fix interrupt setup of mem and l2 controller
      edac, highbank: Add Calxeda ECX-2000 support
      edac, highbank: Improve and unify naming
      edac: Unify reporting of device info for device, mc and pci
      edac, highbank: Add MAINTAINERS entry
      edac, highbank: Moving error injection to sysfs for edac

 .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt         |   4 +-
 MAINTAINERS                                               |   8 ++
 arch/arm/boot/dts/ecx-2000.dts                            |   6 +
 arch/arm/boot/dts/ecx-common.dtsi                         |   6 -
 arch/arm/boot/dts/highbank.dts                            |   6 +
 drivers/edac/edac_device.c                                |   9 +-
 drivers/edac/edac_mc.c                                    |   6 +-
 drivers/edac/edac_pci.c                                   |   8 +-
 drivers/edac/highbank_l2_edac.c                           |  33 +++--
 drivers/edac/highbank_mc_edac.c                           | 175 ++++++++++++++-----------
 10 files changed, 151 insertions(+), 110 deletions(-)
