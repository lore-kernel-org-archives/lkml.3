Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3BDEXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:23:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:34273 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab3BDEW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:22:59 -0500
Message-ID: <1359951767.14701.22.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 04 Feb 2013 15:22:47 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Just so that you don't get too bored on your Island here's a patch for
3.8 fixing a nasty bug that affects the new 64T support that was merged
in 3.7. Please apply whenever you have a chance (and an internet
connection !)

Cheers,
Ben.

The following changes since commit 689dfa894c57842a05bf6dc9f97e6bb71ec5f386:

  powerpc: Max next_tb to prevent from replaying timer interrupt (2013-01-29 10:18:16 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to eda8eebdd153c48a4e2a3a3ac3cd9e2e31f5c6b3:

  powerpc/mm: Fix hash computation function (2013-02-04 15:15:08 +1100)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      powerpc/mm: Fix hash computation function

 arch/powerpc/mm/hash_low_64.S |   62 +++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 27 deletions(-)


