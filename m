Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3FEOMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:12:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab3FEOMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:12:09 -0400
Date: Wed, 5 Jun 2013 16:12:06 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: chauplac@gmail.com, dirk@gouders.net, matthijs@stdin.nl, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild fixes for v3.10-rc5
Message-ID: <20130605141206.GA1573@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There is one fix for a kbuild regression, plus three kconfig fixes for
bugs that have alway been there, but are simple enough to be fixed in an
-rc.

Thanks,
Michal

The following changes since commit f66ba560943ae21f5d1e505bad0a3591823b2b37:

  package: Makefile: unbreak binrpm-pkg target (2013-05-16 09:46:45 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to 42a0940d9d582214a8d0f8ba41f2b4fe987e21b0:

  Merge branch 'yem-kconfig-rc-fixes' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes (2013-05-30 15:21:48 +0200)

----------------------------------------------------------------

Clement Chauplannaz (1):
      scripts/config: fix assignment of parameters for short version of --*-after options

Dirk Gouders (2):
      mconf: handle keys in empty dialogs
      kconfig/menu.c: fix multiple references to expressions in menu_add_prop()

Matthijs Kooijman (1):
      kbuild: Don't assume dts files live in arch/*/boot/dts

Michal Marek (1):
      Merge branch 'yem-kconfig-rc-fixes' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes

 scripts/Makefile.lib               |  2 +-
 scripts/config                     |  2 +-
 scripts/kconfig/lxdialog/menubox.c |  9 +++++----
 scripts/kconfig/mconf.c            | 11 ++++++-----
 scripts/kconfig/menu.c             | 15 ++++++++++++++-
 5 files changed, 27 insertions(+), 12 deletions(-)
