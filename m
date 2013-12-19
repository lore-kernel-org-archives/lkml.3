Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3LSVLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:11:45 -0500
Received: from seketeli.net ([91.121.166.71]:38291 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab3LSVLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:11:44 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] Update platform data for JZ4740 usb device controller
Date: Thu, 19 Dec 2013 22:11:42 +0100
Message-Id: <1387487503-26161-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following a few patches sent to the linux-usb mailing list to add USB
support for the Ingenic JZ4740 MIPS SoC found in the Ben Nanonote,
here is a patch that updates platform data for JZ4740 usb device
controller.

The patch that comes as a follow-up of this message was originally
part of the patch set sent to linux-usb but was split out to separate
arch/ from drivers/ files.

Changes were rebased on top of Ralf Baechle's Linux MIPS master
branch, built and tested on device successfully.

The following changes since commit a9b7663:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

are available in the git repository at:

  git://seketeli.fr/~apelete/linux-mips.git update-jz4740-arch

Apelete Seketeli (1):
  arch: mips: update platform data for JZ4740 usb device controller

 arch/mips/include/asm/mach-jz4740/platform.h |    1 +
 arch/mips/jz4740/board-qi_lb60.c             |    1 +
 arch/mips/jz4740/platform.c                  |   40 +++++++++++++++-----------
 3 files changed, 26 insertions(+), 16 deletions(-)

-- 
1.7.10.4

