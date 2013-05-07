Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3EGMmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:42:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650Ab3EGMms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:42:48 -0400
Date: Tue, 7 May 2013 14:42:46 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: antonynpavlov@gmail.com, rob@landley.net, schwab@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.10-rc1
Message-ID: <20130507124246.GA12891@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild commits for v3.10-rc1:

* Fix make mrproper after mod/file2alias rework
* Fix ld-option Makefile function
* Rewrite headers_install to shell to drop Perl dependency.

There are some more patches I have to look at, so I might send another
pull request later. Or just queue them for 3.11.

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Andreas Schwab (1):
      Fix cleaning in scripts/mod

Antony Pavlov (1):
      kbuild: fix ld-option function

Rob Landley (1):
      headers_install.pl: convert to headers_install.sh

 Documentation/kbuild/makefiles.txt |    2 +-
 scripts/Kbuild.include             |    2 +-
 scripts/Makefile.headersinst       |    4 +-
 scripts/headers_install.pl         |   63 ------------------------------------
 scripts/headers_install.sh         |   43 ++++++++++++++++++++++++
 scripts/mod/Makefile               |    2 +
 6 files changed, 49 insertions(+), 67 deletions(-)
 delete mode 100644 scripts/headers_install.pl
 create mode 100644 scripts/headers_install.sh
