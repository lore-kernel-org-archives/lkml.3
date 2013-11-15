Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3KOQPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:15:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3KOQPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:15:22 -0500
Date: Fri, 15 Nov 2013 17:15:20 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ben@decadent.org.uk, mmarek@suse.cz, regid23@nt1.in, walch.martin@web.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig changes for v3.13-rc1
Message-ID: <20131115161520.GA19769@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kconfig changes for v3.13-rc1:
- xconfig stores its setting in a meaningful path
  (~/.config/kernel.org/qconf.conf)
- kconfig symbol search fix
- documentation fixes
- cleanup & comment update
- fix warning when a kconfig symbol is defined with two different types
- Yann is now officially listed as maintainer of kconfig, but he prefers
  me to send pull requests for now

Thanks,
Michal

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

for you to fetch changes up to e125096e733e966e055ee6033169f68233f9bf9c:

  Merge branch 'yem/kconfig-for-next' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/kconfig (2013-10-31 11:58:59 +0100)

----------------------------------------------------------------

Ben Hutchings (1):
      xconfig: Fix the filename for GUI settings

Martin Walch (5):
      kconfig: add short explanation to SYMBOL_WRITE
      kconfig: fix trivial typos and update mconf documentation
      kconfig: adjust warning message for conflicting types
      kconfig: remove unused definition from scanner
      kconfig: fix bug in search results string: use strlen(gstr->s), not gstr->len

Michal Marek (2):
      MAINTAINERS: New kconfig maintainer
      Merge branch 'yem/kconfig-for-next' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/kconfig

Regid Ichira (1):
      Documentation/kbuild/kconfig.txt: 'make listnewconfig' replaces: yes "" | make oldconfig

 Documentation/kbuild/kconfig.txt | 11 ++------
 MAINTAINERS                      |  5 ++--
 scripts/kconfig/expr.h           |  2 +-
 scripts/kconfig/mconf.c          | 60 +++++++++++++++++++---------------------
 scripts/kconfig/menu.c           | 11 ++++----
 scripts/kconfig/qconf.cc         |  5 ++++
 scripts/kconfig/qconf.h          |  1 +
 scripts/kconfig/symbol.c         |  2 +-
 scripts/kconfig/zconf.l          |  1 -
 9 files changed, 48 insertions(+), 50 deletions(-)
