Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbaLKOOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:14:14 -0500
Received: from tex.lwn.net ([70.33.254.29]:36495 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaLKOOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:14:12 -0500
Date: Thu, 11 Dec 2014 09:14:10 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] Docs changes for 3.19
Message-ID: <20141211091410.5e553c90@lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my set of accumulated documentation changes for 3.19.  It includes
a couple of additions to the coding style document, some fixes for minor
build problems within the documentation tree, the relocation of the
kselftest docs, and various tweaks and additions.

A couple of changes reach outside of Documentation/; they only make
trivial comment changes and I did my best to get the required acks.

Complete with a shiny signed tag this time around.

Thanks,

jon

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.lwn.net/linux-2.6.git tags/docs-for-linus

for you to fetch changes up to 9b64c09bb960b4ccae2a42e204cd70f83b115e3d:

  kobject: grammar fix (2014-12-08 09:07:11 -0500)

----------------------------------------------------------------
Docs changes for the 3.19 merge window

----------------------------------------------------------------
Ashutosh Dixit (1):
      Documentation: Build mic/mpssd only for x86_64

Dan Carpenter (1):
      CodingStyle: add some more error handling guidelines

Daniel Dressler (1):
      Input: xpad - update docs to reflect current state

Fabian Frederick (1):
      ipv4: add kernel parameter tcpmhash_entries

John de la Garza (1):
      kobject: grammar fix

Jonathan Corbet (1):
      Merge branch 'docs-3.19' into docs-next

Josh Triplett (1):
      CodingStyle: Add a chapter on conditional compilation

Maisa Roponen (1):
      Documentation: fix formatting to make 's' happy

Masanari Iida (4):
      treewide: Fix typo in Documentation/DocBook/device-drivers
      Documentation: Fix a typo in mailbox.txt
      Documentation: vm: Add 1GB large page support information
      Documentation: power: Fix typo in Documentation/power

Richard Leitner (1):
      Documentation/email-clients.txt: add info about Claws Mail

SeongJae Park (1):
      cgroups: Documentation: fix wrong cgroupfs paths

Tim Bird (1):
      kselftest: Move the docs to the Documentation dir

 Documentation/CodingStyle                          |  70 +++++++++++-
 Documentation/cgroups/cgroups.txt                  |   4 +-
 Documentation/email-clients.txt                    |  11 ++
 Documentation/filesystems/proc.txt                 |   2 +-
 Documentation/input/xpad.txt                       | 123 ++++++++++++++-------
 Documentation/kernel-parameters.txt                |   7 ++
 Documentation/kobject.txt                          |   2 +-
 .../README.txt => Documentation/kselftest.txt      |  30 +++--
 Documentation/mailbox.txt                          |   2 +-
 Documentation/mic/mpssd/Makefile                   |   2 +-
 Documentation/power/runtime_pm.txt                 |   6 +-
 Documentation/power/suspend-and-interrupts.txt     |   2 +-
 Documentation/power/userland-swsusp.txt            |   2 +-
 Documentation/vm/hugetlbpage.txt                   |   4 +-
 drivers/dma-buf/fence.c                            |   2 +-
 include/linux/fence.h                              |   4 +-
 include/linux/i2c.h                                |   2 +-
 17 files changed, 202 insertions(+), 73 deletions(-)
 rename tools/testing/selftests/README.txt => Documentation/kselftest.txt (73%)
