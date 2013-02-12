Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3BLDjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 22:39:45 -0500
Received: from nskntqsrv02p.mx.bigpond.com ([61.9.168.234]:47383 "EHLO
	nskntqsrv02p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737Ab3BLDjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 22:39:44 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 22:39:43 EST
X-Authority-Analysis: v=2.0 cv=G7ae4qY5 c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=jmaA7clBIoEA:10 a=aFTPlZ8mLXYA:10
 a=abLpnCq0AAAA:8 a=H5rnqBSDAAAA:8 a=JsnJcVAEfioA:10 a=VwQbUJbxAAAA:8
 a=iDp1um5GEbZ1S4H4WOgA:9 a=tpHzvNDyw14p4wpd1xf5Bw==:117
Date: Tue, 12 Feb 2013 13:26:35 +1000
From: Greg Ungerer <gerg@uclinux.org>
Message-Id: <201302120326.r1C3QZhX010155@goober.accelcon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-m68k@vger.kernel.org>,
        <uclinux-dev@uclinux.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu important arch fix for 3.8
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch.

It contains a single critical fix for the non-MMU m68k platforms. The change
of the kernel exec code path has revealed a problem in the start thread code
that causes crashing on boot. This is the fix for it.

Regards
Greg



The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:
  Linus Torvalds (1):
        Linux 3.8-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (1):
      m68knommu: fix trap on execing /bin/init

 arch/m68k/include/asm/processor.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
