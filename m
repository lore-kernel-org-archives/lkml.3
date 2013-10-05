Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3JECpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 22:45:24 -0400
Received: from mail-gg0-f181.google.com ([209.85.161.181]:61359 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3JECpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 22:45:22 -0400
X-Greylist: delayed 103126 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Oct 2013 22:45:21 EDT
Date: Fri, 4 Oct 2013 20:45:17 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hedi Berriche <hedi@sgi.com>, "ethan.zhao" <ethan.zhao@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [GIT PULL] PCI updates for v3.12
Message-ID: <20131005024517.GC26108@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a fix for v3.12.  We merged what was intended to be an MMCONFIG
cleanup, but in fact, for systems without _CBA (which is almost
everything), it broke extended config space for domain 0 and it
broke all config space for other domains.  This reverts the change.

Bjorn


The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.12-fixes-1

for you to fetch changes up to 67d470e0e1711ca4a4c3a0e5524e0d580654053e:

  Revert "x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero" (2013-10-04 16:15:29 -0600)

----------------------------------------------------------------
PCI update for v3.12:

  MMCONFIG
      Revert "x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero"

----------------------------------------------------------------
Bjorn Helgaas (1):
      Revert "x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero"

 arch/x86/pci/mmconfig-shared.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
