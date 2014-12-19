Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLSUvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:51:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaLSUvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:51:05 -0500
Date: Fri, 19 Dec 2014 21:51:00 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: k.khlebnikov@samsung.com, mmarek@suse.cz, syntheticpp@gmx.net,
        yamada.m@jp.panasonic.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild changes for v3.19-rc1
Message-ID: <20141219205100.GA4174@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

sorry for the late pull request. Here are the kbuild changes for
v3.19-rc1:

* Cleanups and deduplication in the main Makefile and scripts/Makefile.*
* Sort the output of *config targets in make help
* Old <linux/version.h> is always removed to avoid a surprise during
  bisecting
* Warning fix in kconfig

There is some more stuff in my backlog -- will submit this for 3.20-rc1.

Michal

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

for you to fetch changes up to 1846dfbde3e8a53f3673dcb1c1b79fd9b3f8d40d:

  kbuild: remove redundant -rR flag of hdr-inst (2014-12-03 14:14:07 +0100)

----------------------------------------------------------------
Konstantin Khlebnikov (1):
      Makefile: sort list of defconfig targets in make help output

Masahiro Yamada (2):
      kbuild: collect shorthands into scripts/Kbuild.include
      kbuild: remove redundant -rR flag of hdr-inst

Michal Marek (3):
      kbuild: Remove duplicate $(cmd) definition in Makefile.clean
      kbuild: Automatically remove stale <linux/version.h> file
      kbuild: Fix make help-<board series> on powerpc

Peter Kümmel (1):
      kconfig: Fix warning "‘jump’ may be used uninitialized"

 Makefile                     | 17 ++++++-----------
 scripts/Kbuild.include       | 12 ++++++++++++
 scripts/Makefile.clean       | 10 +---------
 scripts/Makefile.headersinst |  1 -
 scripts/kconfig/menu.c       |  4 ++--
 5 files changed, 21 insertions(+), 23 deletions(-)
