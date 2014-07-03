Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbaGCVz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:55:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759877AbaGCVzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:55:25 -0400
Date: Thu, 3 Jul 2014 23:55:23 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild fix for v3.16-rc4
Message-ID: <20140703215523.GA23681@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there is one more fix for the relative paths series from -rc1: Print the
path to the build directory at the start of the build, so that editors
and IDEs can match the relative paths to source files.

Thanks,
Michal

The following changes since commit c14105628b2e2eee04b2d6950e068eeddf49f2f1:

  kbuild: fix a typo in a kbuild document (2014-06-18 21:38:18 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to c2e28dc975ea87feed84415006ae143424912ac7:

  kbuild: Print the name of the build directory (2014-07-03 15:25:11 +0200)

----------------------------------------------------------------
Michal Marek (1):
      kbuild: Print the name of the build directory

 Makefile | 3 +++
 1 file changed, 3 insertions(+)
