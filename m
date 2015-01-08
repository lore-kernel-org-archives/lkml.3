Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbbAHKtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:49:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299AbbAHKtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:49:35 -0500
Date: Thu, 8 Jan 2015 11:49:33 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] make mrproper fix for v3.19-rc4
Message-ID: <20150108104933.GA25083@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

make mrproper / distclean stopped removing the generated debian/
directory in v3.16. Please pull the fix.

Thanks,
Michal

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git 

for you to fetch changes up to a16c5f99a28c9945165c46da27fff8e6f26f8736:

  kbuild: Fix removal of the debian/ directory (2015-01-02 14:51:27 +0100)

----------------------------------------------------------------
Michal Marek (1):
      kbuild: Fix removal of the debian/ directory

 scripts/Makefile.clean | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)
