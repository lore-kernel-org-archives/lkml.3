Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab3F3Em1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 00:42:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:53767 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3F3EmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 00:42:23 -0400
Message-ID: <1372567331.18612.97.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sun, 30 Jun 2013 14:42:11 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Earlier today I mentioned that while we had fixed the kernel crashes,
EEH error recovery didn't always recover... It appears that I had
a fix for that already in powerpc-next (with a stable CC).

I cherry-picked it today and did a few tests and it seems that things
now work quite well. The patch is also pretty simple, so I see no reason
to wait before merging it.

Please pull.

Cheers,
Ben.

The following changes since commit 6c355beafdbd0a62add3a3d89825ca87cf8ecec0:

  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-06-29 17:02:48 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to ea461abf61753b4b79e625a7c20650105b990f21:

  powerpc/eeh: Fix fetching bus for single-dev-PE (2013-06-30 14:08:34 +1000)

----------------------------------------------------------------
Gavin Shan (1):
      powerpc/eeh: Fix fetching bus for single-dev-PE

 arch/powerpc/platforms/pseries/eeh_pe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


