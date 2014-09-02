Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaIBQi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:38:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15703 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaIBQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:38:27 -0400
X-IronPort-AV: E=Sophos;i="5.04,450,1406592000"; 
   d="scan'208";a="168375978"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCHv1 0/3] x86,xen: remove _PAGE_IOMAP PTE flag
Date: Tue, 2 Sep 2014 17:37:42 +0100
Message-ID: <1409675865-11608-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series removes the Xen-specific _PAGE_IOMAP PTE flag, freeing it
up for other uses.

I plan to queue this for 3.18 via the Xen tree.

This was previously posted as part of a larger series (x86/xen: fixes
for mapping high MMIO regions (and remove _PAGE_IOMAP)), the bulk of
which is already merged.

Changes in v1 (from v6 of the previous series):

- Improve comments/description of the spurious fault fix.

David

