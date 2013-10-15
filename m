Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab3JOLVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:21:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:39463 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3JOLVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:21:45 -0400
X-IronPort-AV: E=Sophos;i="4.93,498,1378857600"; 
   d="scan'208";a="60960801"
Date: Tue, 15 Oct 2013 12:20:48 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: [PULL] (xen) stable/for-linus-3.12-rc4-tag for v3.12-rc6
Message-ID: <alpine.DEB.2.02.1310151213170.26077@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
the following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip stable/for-linus-3.12-rc4-tag

Frediano Ziglio (1):
      xen: Fix possible user space selector corruption

Rob Herring (1):
      tpm: xen-tpmfront: fix missing declaration of xen_domain

 arch/x86/xen/smp.c              |    9 +++++++++
 drivers/char/tpm/xen-tpmfront.c |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)
