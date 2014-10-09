Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaJIRhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:37:43 -0400
Received: from lists.s-osg.org ([54.187.51.154]:40111 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaJIRhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:37:36 -0400
Date: Thu, 9 Oct 2014 14:37:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.18-rc1] edac updates
Message-ID: <20141009143730.55abbeb4@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac tags/edac/v3.18-rc1

For some EDAC patches. Nothing really exiting here: just one bug fix at
sb_edac, and some changes to allow other drivers to use some shared PCI
addresses.

Regards,
Mauro

The following changes since commit c91662cb18f00f225c74816353f222b6997131ca:

  Merge tag 'edac_for_3.18' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp (2014-10-07 20:54:50 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac tags/edac/v3.18-rc1

for you to fetch changes up to d0585cd815faef50ce3d12cbe173438eb4d81eb8:

  sb_edac: Claim a different PCI device (2014-10-08 17:04:16 -0300)

----------------------------------------------------------------
edac updates for v3.18-rc1

----------------------------------------------------------------
Andy Lutomirski (2):
      Move Intel SNB device ids from sb_edac to pci_ids.h
      sb_edac: Claim a different PCI device

Seth Jennings (1):
      sb_edac: avoid INTERNAL ERROR message in EDAC with unspecified channel

 drivers/edac/sb_edac.c  | 40 +++++++---------------------------------
 include/linux/pci_ids.h | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 33 deletions(-)

