Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3GAQrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:47:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:19529 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab3GAQrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:47:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="363641314"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Fixes for pstore for 3.11 merge window
Date: Mon, 01 Jul 2013 09:47:14 -0700
Message-Id: <51d1b2921700bfcca@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore

for you to fetch changes up to 0d838347f1325cebfe8b9341a4b4c1f407022231:

  efivars: If pstore_register fails, free unneeded pstore buffer (2013-06-28 15:23:24 -0700)

----------------------------------------------------------------
Fixes for pstore for 3.11 merge window

----------------------------------------------------------------
Aruna Balakrishnaiah (1):
      pstore: Fail to unlink if a driver has not defined pstore_erase

Lenny Szubowicz (3):
      pstore: Return unique error if backend registration excluded by kernel param
      acpi: Eliminate console msg if pstore.backend excludes ERST
      efivars: If pstore_register fails, free unneeded pstore buffer

Rob Herring (2):
      pstore/ram: avoid atomic accesses for ioremapped regions
      pstore/ram: remove the power of buffer size limitation

Thomas Meyer (1):
      efi, pstore: Cocci spatch "memdup.spatch"

 drivers/acpi/apei/erst.c          | 20 ++++++++++-----
 drivers/firmware/efi/efi-pstore.c |  9 ++++---
 fs/pstore/inode.c                 |  2 ++
 fs/pstore/platform.c              | 11 ++++----
 fs/pstore/ram.c                   |  2 --
 fs/pstore/ram_core.c              | 54 +++++++++++++++++++++++++++++++++++++--
 6 files changed, 80 insertions(+), 18 deletions(-)
