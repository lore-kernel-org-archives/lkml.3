Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3ILMuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:50:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44745 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3ILMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:50:08 -0400
X-IronPort-AV: E=Sophos;i="4.90,891,1371081600"; 
   d="scan'208";a="50835380"
Date: Thu, 12 Sep 2013 13:49:41 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PULL] (xen) stable/for-linus-3.12-rc0-tag-three for v3.12-rc1
Message-ID: <alpine.DEB.2.02.1309121328030.32236@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
we have two more Xen fixes for the balloon driver:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.12-rc0-tag-three



The following changes since commit c3b7cb1fd8c1513be99fb3cfb7f39c5116d80dac:

  xen/spinlock: Don't use __initdate for xen_pv_spin (2013-09-09 13:08:49 -0400)

David Vrabel (1):
      xen/balloon: ensure preemption is disabled when using a scratch page

Wei Liu (1):
      xen/balloon: remove BUG_ON in increase_reservation

 drivers/xen/balloon.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)
