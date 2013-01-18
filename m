Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab3ARIQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:16:15 -0500
Received: from nskntqsrv03p.mx.bigpond.com ([61.9.168.237]:39415 "EHLO
	nskntqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032Ab3ARIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:16:14 -0500
X-Greylist: delayed 5333 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2013 03:16:13 EST
X-Authority-Analysis: v=2.0 cv=FNuZNpUs c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=4QTP58DfdrcA:10 a=fAaKLWLAU3UA:10
 a=H5rnqBSDAAAA:8 a=YvqQfTbJdaQA:10 a=VwQbUJbxAAAA:8 a=0Ll975wjfA4zU0QK88gA:9
 a=tpHzvNDyw14p4wpd1xf5Bw==:117
Date: Fri, 18 Jan 2013 16:47:16 +1000
From: Greg Ungerer <gerg@goober.accelcon.com>
Message-Id: <201301180647.r0I6lGbf020653@goober.accelcon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-m68k@vger.kernel.org>,
        <uclinux-dev@uclinux.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fixes for 3.8
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch, at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

It contains a couple of fixes, both affecting compilation of non-mmu m68k
targets.

Regards
Greg




The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
  Linus Torvalds (1):
        Linux 3.8-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (2):
      m68knommu: add KMAP definitions for non-MMU definitions
      m68k: fix conditional use of init_pointer_table

 arch/m68k/include/asm/pgtable_no.h |    2 ++
 arch/m68k/mm/init.c                |    8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)
