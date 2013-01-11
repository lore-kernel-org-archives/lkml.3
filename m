Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3AKUMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:12:35 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:55882 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3AKUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:12:33 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 0/4] arm: vt8500: Add support for Wondermedia WM8750/WM8850
Date: Sat, 12 Jan 2013 09:12:38 +1300
Message-Id: <1357935162-7672-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://server.prisktech.co.nz/git/linuxwmt.git tags/armsoc-3.9

for you to fetch changes up to 82c8f175662873f7f7f4c78698888ee963d7d967:

  arm: vt8500: Remove remaining mach includes (2012-12-28 21:05:19 +1300)

----------------------------------------------------------------
arm: vt8500: Add support for WM8750/WM8850. Cleanup multiplatform changes

This patchset adds support for the WM8750 (ARMv6) and WM8850 (ARMv7), and
cleans up changes for multiplatform configuration.

Single platform Kconfig options are removed, along with the remaining
mach/includes.

The debug-macro.s is moved to arm/include/debug/ to allow DEBUG_LL on
multi-platform.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

----------------------------------------------------------------
Tony Prisk (4):
      arm: vt8500: Add support for Wondermedia WM8750/WM8850
      arm: vt8500: Remove single platform Kconfig options
      arm: vt8500: Convert debug-macro.S to be multiplatform friendly
      arm: vt8500: Remove remaining mach includes

 Documentation/devicetree/bindings/arm/vt8500.txt   |    8 +++++
 arch/arm/Kconfig                                   |   16 ---------
 arch/arm/Kconfig.debug                             |    8 +++++
 .../mach/debug-macro.S => include/debug/vt8500.S}  |   24 ++++++++-----
 arch/arm/mach-vt8500/Kconfig                       |   26 ++++++++++++--
 arch/arm/mach-vt8500/include/mach/timex.h          |   26 --------------
 arch/arm/mach-vt8500/include/mach/uncompress.h     |   37 --------------------
 arch/arm/mach-vt8500/vt8500.c                      |    2 ++
 8 files changed, 56 insertions(+), 91 deletions(-)
 rename arch/arm/{mach-vt8500/include/mach/debug-macro.S => include/debug/vt8500.S} (56%)
 delete mode 100644 arch/arm/mach-vt8500/include/mach/timex.h
 delete mode 100644 arch/arm/mach-vt8500/include/mach/uncompress.h
