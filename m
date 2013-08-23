Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3HWP4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:56:21 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:60086 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3HWPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:55:16 -0400
Date: Fri, 23 Aug 2013 11:55:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.11-rc6
Message-ID: <20130823155511.GG3277@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains three commits all of which are updates for
specific devices which aren't too widespread.  Pretty limited scope
and nothing too interesting or dangerous.

The three commits are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.11-fixes

for you to fetch changes up to 99bbdfa6bdcb4bdf5be914a48e9b46941bf30819:

  sata_fsl: save irqs while coalescing (2013-08-20 08:38:23 -0400)

Thanks.

----------------------------------------------------------------
Anthony Foiani (1):
      sata_fsl: save irqs while coalescing

Mark Langsdorf (1):
      sata, highbank: fix ordering of SGPIO signals

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

 drivers/ata/libata-pmp.c    | 12 ++++++------
 drivers/ata/sata_fsl.c      |  5 +++--
 drivers/ata/sata_highbank.c |  4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

-- 
tejun
