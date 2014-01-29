Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaA2VuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:50:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaA2VuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:50:13 -0500
Date: Wed, 29 Jan 2014 22:50:11 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ben@decadent.org.uk, mmarek@suse.cz, nm@ti.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.14-rc1
Message-ID: <20140129215011.GA1803@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the non-critical part of kbuild is small this time:
- Three fixes for make deb-pkg
- A new coccinelle check

One of the deb-pkg fixes is a leftover from the last merge window, hence
the merge commit.

Thanks,
Michal

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Ben Hutchings (3):
      deb-pkg: Inhibit initramfs builders if CONFIG_BLK_DEV_INITRD is not set
      deb-pkg: Fix cross-building linux-headers package
      deb-pkg: Fix building for MIPS big-endian or ARM OABI

Michal Marek (1):
      Merge commit v3.13-rc1 into kbuild/misc

Nishanth Menon (1):
      scripts: Coccinelle script for pm_runtime_* return checks with IS_ERR_VALUE

 scripts/coccinelle/api/pm_runtime.cocci |  109 +++++++++++++++++++++++++++++++
 scripts/package/builddeb                |   25 +++++--
 2 files changed, 126 insertions(+), 8 deletions(-)
 create mode 100644 scripts/coccinelle/api/pm_runtime.cocci
