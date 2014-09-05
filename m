Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaIEXwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:52:09 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53214 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIEXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:52:05 -0400
Date: Fri, 5 Sep 2014 16:52:01 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [GIT PULL] MTD fixes for 3.17-rc4
Message-ID: <20140905235201.GG18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 2a500afe1e0e84c7a126df693dbd01353756dcfa:

  mtd: gpmi: make blockmark swapping optional (2014-07-27 22:06:31 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20140905

for you to fetch changes up to b25046b1e5e3f1423434da77ccc859f2f779d1ce:

  mtd: nand: fix DocBook warnings on nand_sdr_timings doc (2014-08-19 11:55:38 -0700)

----------------------------------------------------------------
Two trivial MTD updates for 3.17-rc4:

 * A tiny comment tweak, to kill a bunch of DocBook warnings added during the
   merge window

 * A small fixup to the OTP routines' error handling

----------------------------------------------------------------
Boris BREZILLON (1):
      mtd: nand: fix DocBook warnings on nand_sdr_timings doc

Brian Norris (1):
      mtd: cfi_cmdset_0002: check return code for get_chip()

 drivers/mtd/chips/cfi_cmdset_0002.c | 4 ++++
 include/linux/mtd/nand.h            | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)
