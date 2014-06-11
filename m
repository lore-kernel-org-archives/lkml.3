Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaFKSoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:37 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:19427 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaFKSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:31 -0400
X-CheckPoint: {5398A38F-0-2100090A-C0000000}
Message-ID: <5398A38E.8000800@tilera.com>
Date: Wed, 11 Jun 2014 14:44:30 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile changes for 3.16
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.16 from:

   git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These mostly just address smaller issues reported to me.

Thanks!

Daniel Walter (1):
       replace strict_strto* call with kstrto*

Fabian Frederick (1):
       drivers/tty/hvc/hvc_tile.c: use PTR_ERR_OR_ZERO

Geert Uytterhoeven (1):
       tile: Update comments for generic idle conversion

Rickard Strandqvist (1):
       arch: tile: kernel: unaligned.c: Cleaning up uninitialized variables

Wang Sheng-Hui (2):
       tile: use BOOTMEM_DEFAULT instead of magic number 0 for reserve_bootmem flags
       tile: cleanup the comment in init_pgprot

  arch/tile/include/asm/thread_info.h |  2 +-
  arch/tile/kernel/setup.c            | 12 +++++-------
  arch/tile/kernel/signal.c           |  7 +++----
  arch/tile/kernel/traps.c            |  5 ++---
  arch/tile/kernel/unaligned.c        | 15 ++-------------
  arch/tile/mm/init.c                 |  8 ++++----
  drivers/tty/hvc/hvc_tile.c          |  2 +-
  7 files changed, 18 insertions(+), 33 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

