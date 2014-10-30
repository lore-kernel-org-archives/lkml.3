Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbaJ3SG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:06:26 -0400
Received: from tex.lwn.net ([70.33.254.29]:53238 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760178AbaJ3SGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:06:25 -0400
Date: Thu, 30 Oct 2014 14:06:22 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Various documentation fixes
Message-ID: <20141030140622.7b2df134@lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is my first pull request since I rashly agreed to look after the
documentation subtree.  It contains some typo fixes, a few minor
documentation improvements, and, most importantly, fixes for a couple of
build problems in various bits of sample code.

I fully intend to start sending pull requests with signed tags.  However,
due to poor planning on my part and the general obnoxiousness of life,
I'm 2000 miles away from my private key which is sitting on a
powered-down machine.  This should be fixed before my next request.
Meanwhile git.lwn.net is a machine under my control, the patches are all
trivial, and all have done time in linux-next.

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.lwn.net/linux-2.6.git/ tags/docs-for-linus

for you to fetch changes up to d75ef707ea5eb3015f7b72cb3b81c6cdca376fea:

  Documentation/SubmittingPatches: Reported-by tags and permission (2014-10-29 08:56:46 -0400)

----------------------------------------------------------------
Alexander Graf (1):
      Documentation: Restrict TSC test code to x86

Dan Carpenter (1):
      Documentation/SubmittingPatches: Reported-by tags and permission

Javier Martinez Canillas (1):
      Documentation: dt-bindings: Explain order in patch series

Jeff Mahoney (1):
      vdso: don't require 64-bit math in standalone test

Jim Davis (1):
      Documentation: remove outdated references to the linux-next wiki

Kirill Smelkov (1):
      Docs: Document that the sticky bit is understood by hugetlbfs

Maciej W. Rozycki (1):
      doc: kernel-parameters.txt: Add ide-generic.probe-mask

Masanari Iida (2):
      Documentation: Add default kmemleak off case in kernel-parameters.txt
      Documentation: Add CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF case

Peter Foley (1):
      Documentation: fix vdso_standalone_test_x86 on 32-bit

Takashi Iwai (1):
      DocBook: Reduce noise from make cleandocs

WANG Chao (1):
      Documentation/ABI/testing/sysfs-ibft: fix a typo

 Documentation/ABI/testing/sysfs-ibft                     |  2 +-
 Documentation/DocBook/media/Makefile                     |  2 +-
 Documentation/HOWTO                                      |  1 -
 Documentation/SubmittingPatches                          | 10 ++++------
 Documentation/development-process/2.Process              |  4 ----
 Documentation/development-process/8.Conclusion           |  4 ----
 Documentation/devicetree/bindings/submitting-patches.txt |  3 +++
 Documentation/kernel-parameters.txt                      | 14 ++++++++++++++
 Documentation/kmemleak.txt                               |  4 ++++
 Documentation/prctl/Makefile                             |  2 +-
 Documentation/vDSO/Makefile                              |  3 +++
 Documentation/vDSO/vdso_standalone_test_x86.c            |  2 +-
 Documentation/vm/hugetlbpage.txt                         |  2 +-
 13 files changed, 33 insertions(+), 20 deletions(-)

Thanks,

jon
