Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaFRVg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:36:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbaFRVgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:36:24 -0400
Date: Wed, 18 Jun 2014 23:36:22 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: fathi.boudra@linaro.org, mmarek@suse.cz, yamada.m@jp.panasonic.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild fixes for v3.16-rc2
Message-ID: <20140618213622.GA21153@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There are three fixes for regressions caused by the relative paths
series: deb-pkg, tar-pkg and *docs did not work with O=. Plus, there is
a fix for the linux-headers deb package and a fixed typo. These are not
regression fixes but are safe enough.

Thanks,
Michal

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to c14105628b2e2eee04b2d6950e068eeddf49f2f1:

  kbuild: fix a typo in a kbuild document (2014-06-18 21:38:18 +0200)

----------------------------------------------------------------
Fathi Boudra (1):
      builddeb: fix missing headers in linux-headers package

Masahiro Yamada (1):
      kbuild: fix a typo in a kbuild document

Michal Marek (3):
      deb-pkg: Fix for relative paths
      kbuild: Fix tar-pkg with relative $(objtree)
      Documentation: Fix DocBook build with relative $(srctree)

 Documentation/DocBook/media/Makefile |  4 ++--
 Documentation/kbuild/makefiles.txt   |  2 +-
 scripts/package/builddeb             | 14 ++++++++------
 scripts/package/buildtar             |  3 +--
 4 files changed, 12 insertions(+), 11 deletions(-)
