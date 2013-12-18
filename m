Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3LRVhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:37:04 -0500
Received: from seketeli.net ([91.121.166.71]:43300 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3LRVhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:37:01 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] Add defconfig for Ben NanoNote
Date: Wed, 18 Dec 2013 22:36:58 +0100
Message-Id: <1387402619-22921-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following a few patches sent to the linux-usb mailing list to add USB
support for the Ingenic JZ4740 MIPS SoC found in the Ben Nanonote,
here is patch that adds defconfig for the aforementioned device.

Ben NanoNote is a handheld computer built by the Qi-Hardware community
and is already supported in the kernel, albeit missing a defconfig
file until now.

Changes were rebased on top of Ralf Baechle's Linux MIPS master
branch, built and tested on device successfully.

The following changes since commit a9b766365f58654af3b7d0a8f4e3504ccde26c23:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

are available in the git repository at:

  git://seketeli.fr/~apelete/linux-mips.git ben-config

Apelete Seketeli (1):
  mips: qi_lb60: add defconfig for Ben NanoNote

 arch/mips/configs/qi_lb60_defconfig |  188 +++++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100644 arch/mips/configs/qi_lb60_defconfig

-- 
1.7.10.4

