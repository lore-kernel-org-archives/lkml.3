Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3I3GsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 02:48:04 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:53544 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3I3GsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 02:48:02 -0400
Date: Mon, 30 Sep 2013 08:47:59 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 updates for 3.12
Message-ID: <20130930064759.GA30498@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 updates for 3.12

Gabor Juhos (2):
      avr32: fix clockevents kernel warning
      avr32: cast syscall_return to silence compiler warning

Steven Rostedt (1):
      avr32: use Kbuild infrastructure to handle the asm-generic headers

 arch/avr32/include/asm/Kbuild              | 16 +++++++++++++++-
 arch/avr32/include/asm/cputime.h           |  6 ------
 arch/avr32/include/asm/delay.h             |  1 -
 arch/avr32/include/asm/device.h            |  7 -------
 arch/avr32/include/asm/div64.h             |  6 ------
 arch/avr32/include/asm/emergency-restart.h |  6 ------
 arch/avr32/include/asm/futex.h             |  6 ------
 arch/avr32/include/asm/irq_regs.h          |  1 -
 arch/avr32/include/asm/local.h             |  6 ------
 arch/avr32/include/asm/local64.h           |  1 -
 arch/avr32/include/asm/percpu.h            |  6 ------
 arch/avr32/include/asm/scatterlist.h       |  6 ------
 arch/avr32/include/asm/sections.h          |  6 ------
 arch/avr32/include/asm/topology.h          |  6 ------
 arch/avr32/include/asm/xor.h               |  6 ------
 arch/avr32/kernel/process.c                |  2 +-
 arch/avr32/kernel/time.c                   |  9 ++++++++-
 17 files changed, 24 insertions(+), 73 deletions(-)
 delete mode 100644 arch/avr32/include/asm/cputime.h
 delete mode 100644 arch/avr32/include/asm/delay.h
 delete mode 100644 arch/avr32/include/asm/device.h
 delete mode 100644 arch/avr32/include/asm/div64.h
 delete mode 100644 arch/avr32/include/asm/emergency-restart.h
 delete mode 100644 arch/avr32/include/asm/futex.h
 delete mode 100644 arch/avr32/include/asm/irq_regs.h
 delete mode 100644 arch/avr32/include/asm/local.h
 delete mode 100644 arch/avr32/include/asm/local64.h
 delete mode 100644 arch/avr32/include/asm/percpu.h
 delete mode 100644 arch/avr32/include/asm/scatterlist.h
 delete mode 100644 arch/avr32/include/asm/sections.h
 delete mode 100644 arch/avr32/include/asm/topology.h
 delete mode 100644 arch/avr32/include/asm/xor.h

-- 
Best regards,
Hans-Christian Egtvedt
