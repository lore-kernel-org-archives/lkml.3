Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab3CSVSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:18:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981Ab3CSVSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:18:42 -0400
Date: Tue, 19 Mar 2013 17:18:40 -0400 (EDT)
Message-Id: <20130319.171840.1173928147955486660.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 14:18:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just some minor fixups, a sunsu console setup panic cure, and
recognition of a Fujitsu sun4v cpu.

Please pull, thanks a lot!

The following changes since commit b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50:

  Merge tag 'lzo-update-signature-20130226' of git://github.com/markus-oberhumer/linux (2013-02-28 20:45:52 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to f58b20bd6bad48d6fc5633f003c3651115273fb2:

  sparc: remove unused "config BITS" (2013-03-19 16:23:51 -0400)

----------------------------------------------------------------
Allen Pais (1):
      sparc64: correctly recognize SPARC64-X chips

Daniel Hellstrom (1):
      sparc,leon: fix GRPCI2 device0 PCI config space access

Paul Bolle (2):
      sparc: delete "if !ULTRA_HAS_POPULATION_COUNT"
      sparc: remove unused "config BITS"

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at "console=ttySY" cmdline option

 arch/sparc/Kconfig                  |  8 +-------
 arch/sparc/include/asm/spitfire.h   |  1 +
 arch/sparc/kernel/cpu.c             |  6 ++++++
 arch/sparc/kernel/head_64.S         | 25 +++++++++++++++++++++++--
 arch/sparc/kernel/leon_pci_grpci2.c | 41 ++++++++++++++++++++++++++---------------
 drivers/tty/serial/sunsu.c          | 21 +++++++++------------
 6 files changed, 66 insertions(+), 36 deletions(-)
