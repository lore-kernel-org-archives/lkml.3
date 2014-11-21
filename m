Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaKURAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:00:17 -0500
Received: from smtp.citrix.com ([66.165.176.89]:47071 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbaKURAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:00:15 -0500
X-IronPort-AV: E=Sophos;i="5.07,432,1413244800"; 
   d="scan'208";a="193778543"
Date: Fri, 21 Nov 2014 17:00:05 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] small swiotlb-xen fixes
Message-ID: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have a couple of small straightforward fixes for swiotlb-xen for 3.19.

Cheers,

Stefano


Stefano Stabellini (2):
      swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
      swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

 drivers/xen/swiotlb-xen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
