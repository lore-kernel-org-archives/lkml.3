Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaDETGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:06:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaDETGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:06:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 7/8] ARM: SoC: sh driver changes
Date: Sat, 5 Apr 2014 20:06:32 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404052106.32628.arnd@arndb.de>
X-Provags-ID: V02:K0:6xpKRJAyUyCA6uqmFeDYJ+d14ut5owlQBXK0frU7ewt
 jTGye/NkRAC8OnczUGWvAGQ6KytnWxcSOTA7iUvuizY+k4YVIX
 kXRkg07rk6CtvIpPSDnXAojMuiePyJoUUi2q1sB2/Hd27o/E6R
 sCylj23KE2+mcMDE6fGUgMoMdgVYvYIDuf7JeJCsEJtFSIbXqJ
 MMw88zACWQBcrzdmWJohL33qc80KYFTmg3wGHsUmLDy7QKLWhy
 CzGwJBO+ZVs7gZXTmunQyiK1EiK+13fDs/HQ7Phv6HHhrOJ7XA
 /1iQLkxE/D/LPBx+Rg06wYpyMT4Ujbpez4zgDh08+X5EaLxLg9
 2YPl4+NAqQQ0YPmQbFLU5NKTCAddyeDftfAu17LoT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/sh-3.15

for you to fetch changes up to 13ce64c8f7750ce59066a987951faff38bb7dd97:

  Merge tag 'renesas-intc-for-v3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/sh (2014-03-16 23:30:04 -0700)

----------------------------------------------------------------

ARM: SoC: sh driver changes

The drivers/sh subdirectory used to get merged through the SH architecture
tree, but things are in flux there and some of the drivers are shared
with ARM shmobile, we have picked it up for the time being.

There is only one trivial patch from Laurent Pinchart this time.

----------------------------------------------------------------
Laurent Pinchart (1):
      sh: intc: Enable driver compilation with COMPILE_TEST

Olof Johansson (1):
      Merge tag 'renesas-intc-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/sh

 drivers/sh/intc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
