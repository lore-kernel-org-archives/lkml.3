Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546Ab3BZHOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:14:11 -0500
Received: from mail.southpole.se ([37.247.8.11]:60362 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab3BZHOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:14:09 -0500
Message-ID: <512C60C6.8070903@southpole.se>
Date: Tue, 26 Feb 2013 08:14:14 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] OpenRISC updates for 3.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 62845-09318
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

   Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

   git://openrisc.net/jonas/linux for-upstream

for you to fetch changes up to 160d83781a32e94a1e337efd6722939001e62398:

   openrisc: add missing header inclusion (2013-02-26 07:44:08 +0100)

----------------------------------------------------------------
OpenRISC updates for 3.9

An equal number of bug fixes and trivial cleanups; no new features.

* Two patches to fix errors thrown by the updated toolchain.
* Three other bug fixes.
* Four trivial cleanups.

----------------------------------------------------------------
James Hogan (1):
       openrisc: remove CONFIG_SYMBOL_PREFIX

Jonas Bonn (4):
       openrisc: remove unused current_regs
       openrisc: fix up vmalloc page table loading
       openrisc: update DTLB-miss handler last
       openrisc: really pass correct arg to schedule_tail

Len Brown (1):
       openrisc idle: delete pm_idle

Sebastian Macke (1):
       Add bitops include needed for ext2 filesystem

Stefan Kristiansson (2):
       openrisc: avoid using function parameter regs in reset vector
       openrisc: add missing header inclusion

  arch/openrisc/Kconfig                 |    4 ----
  arch/openrisc/include/asm/bitops.h    |    1 +
  arch/openrisc/include/asm/processor.h |    1 -
  arch/openrisc/kernel/entry.S          |   16 +++++++++++++---
  arch/openrisc/kernel/head.S           |   13 ++++++-------
  arch/openrisc/kernel/idle.c           |    5 -----
  arch/openrisc/mm/init.c               |   17 ++++++++++++++---
  7 files changed, 34 insertions(+), 23 deletions(-)

