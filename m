Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaFPJsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:48:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:54038 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbaFPJsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:48:53 -0400
Message-ID: <1402912122.7661.38.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jun 2014 19:48:42 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is a single revert for a patch I should have never merged in the
first place had I reviewed things with a clear mind at the time :-(

Cheers,
Ben.

The following changes since commit
7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 68986c9f0f4552c34c248501eb0c690553866d6e:

  Revert "offb: Add palette hack for little endian" (2014-06-16 19:45:45
+1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      Revert "offb: Add palette hack for little endian"

 drivers/video/fbdev/offb.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)


