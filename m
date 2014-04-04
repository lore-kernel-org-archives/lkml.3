Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaDDTXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbaDDTXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:23:13 -0400
Date: Fri, 4 Apr 2014 21:25:01 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] GenWQE: Use pci_enable_msi_exact() instead of
 pci_enable_msi_block()
Message-ID: <20140404192501.GA24081@dhcp-26-207.brq.redhat.com>
References: <1396439576-10263-1-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396439576-10263-1-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 01:52:56PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/misc/genwqe/card_utils.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

I forgot to CC linux-pci mailing list.
I will resend this patch with Frank's ACK after v3.15-rc1.

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
