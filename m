Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbaAMBQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 20:16:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:55719 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaAMBQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 20:16:04 -0500
Message-ID: <1389575749.4672.118.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jan 2014 12:15:49 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's one regression fix for 3.13 that I would appreciate if you could still
pull in. It was an "interesting" one to debug, basically it's an old bug that
got somewhat "exposed" by new code breaking the boot on PA Semi boards (yes,
it does appear that some people are still using these !).

Cheers,
Ben.

The following changes since commit f991db1cf1bdca43675b5d2df0af991719727029:

  Merge remote-tracking branch 'agust/merge' into merge (2013-12-30 14:48:27 +1100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 10348f5976830e5d8f74e8abb04a9a057a5e8478:

  powerpc: Check return value of instance-to-package OF call (2014-01-13 09:49:17 +1100)

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      powerpc: Check return value of instance-to-package OF call

 arch/powerpc/kernel/prom_init.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)


