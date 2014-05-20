Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaETJPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:15:35 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46655 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaETJPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:15:30 -0400
Date: Tue, 20 May 2014 11:15:25 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] renameat2 arch support
Message-ID: <20140520091525.GI17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I've collected architecture patches for the renameat2 syscall that maintainers
acked and/or asked me to queue.

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git renameat2

This adds architecture support for the renameat2 syscall to m68k, parisc, ia64
and through asm-generic to arc, arm64, c6x, hexagon, metag, openrisc, score,
tile, unicore32.

Thanks,
Miklos
----

James Hogan (2):
      asm-generic: Add renameat2 syscall
      scripts/checksyscalls.sh: Make renameat optional

Miklos Szeredi (3):
      m68k: add renameat2 syscall
      parisc: add renameat2 syscall
      ia64: add renameat2 syscall

---
 arch/ia64/include/asm/unistd.h        | 2 +-
 arch/ia64/include/uapi/asm/unistd.h   | 1 +
 arch/ia64/kernel/entry.S              | 1 +
 arch/m68k/include/asm/unistd.h        | 2 +-
 arch/m68k/include/uapi/asm/unistd.h   | 1 +
 arch/m68k/kernel/syscalltable.S       | 1 +
 arch/parisc/include/uapi/asm/unistd.h | 3 ++-
 arch/parisc/kernel/syscall_table.S    | 1 +
 include/uapi/asm-generic/unistd.h     | 4 +++-
 scripts/checksyscalls.sh              | 5 ++++-
 10 files changed, 16 insertions(+), 5 deletions(-)
