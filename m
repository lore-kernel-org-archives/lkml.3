Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3FCDcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:32:17 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:59496 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3FCDcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:32:09 -0400
Date: Sun, 2 Jun 2013 20:32:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.10-rc4
Message-ID: <20130603033213.GB6071@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

libata changes for v3.10-rc4.  Nothing too interesting.  PCI ID
additions, some sata_rcar fixes and a fringe bug fix for DMADIR
handling which shouldn't affect any device remotely modern.  The
changes are available in the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.10-fixes

for you to fetch changes up to 52a2a1087b5924de00484f35ef5e2a73f61dbd22:

  sata_rcar: fix interrupt handling (2013-06-02 00:54:45 -0700)

Thanks.

----------------------------------------------------------------
Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

George Spelvin (1):
      ahci: add an observed PCI ID for Marvell 88se9172 SATA controller

Sergei Shtylyov (2):
      sata_rcar: clear STOP bit in bmdma_start() method
      sata_rcar: fix interrupt handling

Tejun Heo (1):
      libata: update "Maintained by:" tags

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

 drivers/ata/acard-ahci.c   |  2 +-
 drivers/ata/ahci.c         |  4 +++-
 drivers/ata/ahci.h         |  2 +-
 drivers/ata/ata_piix.c     | 17 ++++++++++++++++-
 drivers/ata/libahci.c      |  2 +-
 drivers/ata/libata-core.c  |  8 +++++++-
 drivers/ata/libata-eh.c    |  2 +-
 drivers/ata/libata-scsi.c  |  2 +-
 drivers/ata/libata-sff.c   |  2 +-
 drivers/ata/pdc_adma.c     |  2 +-
 drivers/ata/sata_promise.c |  2 +-
 drivers/ata/sata_rcar.c    | 24 ++++++++++++------------
 drivers/ata/sata_sil.c     |  2 +-
 drivers/ata/sata_sx4.c     |  2 +-
 drivers/ata/sata_via.c     |  2 +-
 15 files changed, 49 insertions(+), 26 deletions(-)

--
tejun
