Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3KOKhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:37:08 -0500
Received: from mail.southpole.se ([37.247.8.11]:45734 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab3KOKhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:37:00 -0500
Message-ID: <5285F97E.6020601@southpole.se>
Date: Fri, 15 Nov 2013 11:37:50 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: torvalds@linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] OpenRISC updates for 3.13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 11815-04252
X-Assp-Session: 7F739AA38050 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

   Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

   git://git.openrisc.net/~jonas/linux tags/for-3.13

for you to fetch changes up to 621c2cd853fca98258b720d9fe7e8c031ec7f96f:

   openrisc: Refactor or32_early_setup() (2013-11-15 11:03:51 +0100)

----------------------------------------------------------------
OpenRISC updates for 3.13

- small cleanups to make allmodconfig pass
- defconfig refresh
- a handful of code sanitization patches

----------------------------------------------------------------
Chen Gang (2):
       openrisc: Makefile: append "-D__linux__" to KBUILD_CFLAGS
       openrisc: include: asm: Kbuild: add default "vga.h"

Geert Uytterhoeven (5):
       openrisc: Refactor 16-bit constant relocation
       openrisc: Refresh or1ksim_defconfig for v3.12
       openrisc: Use the declarations provided by <asm/sections.h>
       openrisc: Remove unused declaration of __initramfs_start
       openrisc: Refactor or32_early_setup()

  arch/openrisc/Makefile                  |  2 +-
  arch/openrisc/configs/or1ksim_defconfig | 10 ++--------
  arch/openrisc/include/asm/Kbuild        |  1 +
  arch/openrisc/kernel/module.c           |  6 ++----
  arch/openrisc/kernel/setup.c            | 25 +++++++++++++------------
  arch/openrisc/kernel/vmlinux.h          |  2 --
  6 files changed, 19 insertions(+), 27 deletions(-)
