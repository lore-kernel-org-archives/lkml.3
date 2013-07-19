Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab3GSJ7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:59:36 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760137Ab3GSJ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:59:35 -0400
Message-ID: <51E90E00.4030305@nod.at>
Date: Fri, 19 Jul 2013 11:59:28 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PULL] UML fixes for 3.11-rc2
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

Special thanks goes to Toralf Föster for continuously testing UML and reporting issues!

Thanks,
//richard

----------------------------------------------------------------
Richard Weinberger (5):
      um: Fix return value of strnlen_user()
      um: Mark stub pages mapping with VM_PFNMAP
      um: Fix wait_stub_done() error handling
      um: siginfo cleanup
      um: remove dead code

Tristan Schmelcher (1):
      uml: Fix which_tmpdir failure when /dev/shm is a symlink, and in other edge cases

 arch/um/include/shared/frame_kern.h |   8 +-
 arch/um/kernel/signal.c             |   4 +-
 arch/um/kernel/skas/mmu.c           |   2 +-
 arch/um/kernel/skas/uaccess.c       |   2 +-
 arch/um/os-Linux/mem.c              | 230 +++++++++++++++++++++++++++++-------
 arch/um/os-Linux/signal.c           |   8 +-
 arch/um/os-Linux/skas/process.c     |  19 +--
 arch/x86/um/signal.c                |   1 -
 8 files changed, 213 insertions(+), 61 deletions(-)
