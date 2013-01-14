Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3ANFJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:09:17 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:49750 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3ANFJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:09:15 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, arm@kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [GIT PULL] timer: vt8500: Move timer code to drivers/clocksource
Date: Mon, 14 Jan 2013 18:09:30 +1300
Message-Id: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

Not sure if I have done this correctly but this is the patch to move the
vt8500/timer.c code into drivers/clocksource.

I based it on timer/cleanup from armsoc (hopefully this is right - if not, a
few pointers in the right direction would be appreciated).

Regards
Tony P


The following changes since commit 1c2584c3a1c882fec729147a46d822522552e38c:

  ARM: sunxi: fix struct sys_timer removal (2013-01-08 10:50:43 -0800)

are available in the git repository at:

  git://server.prisktech.co.nz/git/linuxwmt.git tags/vt8500/timer

for you to fetch changes up to ff7ec345f0ece9ddbb28538b70ba0c7f0acc17dc:

  timer: vt8500: Move timer code to drivers/clocksource (2013-01-14 17:58:21 +1300)

----------------------------------------------------------------
Move arch-vt8500/timer.c to drivers/clocksource/vt8500-timer.c

----------------------------------------------------------------
Tony Prisk (1):
      timer: vt8500: Move timer code to drivers/clocksource

 arch/arm/mach-vt8500/Kconfig                       |    1 +
 arch/arm/mach-vt8500/Makefile                      |    2 +-
 arch/arm/mach-vt8500/common.h                      |    1 -
 arch/arm/mach-vt8500/vt8500.c                      |    1 +
 drivers/clocksource/Kconfig                        |    3 +++
 drivers/clocksource/Makefile                       |    1 +
 .../timer.c => drivers/clocksource/vt8500_timer.c  |    0
 include/linux/vt8500_timer.h                       |   22 ++++++++++++++++++++
 8 files changed, 29 insertions(+), 2 deletions(-)
 rename arch/arm/mach-vt8500/timer.c => drivers/clocksource/vt8500_timer.c (100%)
 create mode 100644 include/linux/vt8500_timer.h
