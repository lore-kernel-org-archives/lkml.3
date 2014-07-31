Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaGaNxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:53:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaGaNx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:53:26 -0400
Date: Thu, 31 Jul 2014 15:53:33 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI/MSI/PPC: Remove arch_msi_check_device()
Message-ID: <20140731135333.GA10517@dhcp-26-207.brq.redhat.com>
References: <cover.1405160163.git.agordeev@redhat.com>
 <18276ae8c0b212b8d40dfd186e1c84b8ae949525.1405160163.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18276ae8c0b212b8d40dfd186e1c84b8ae949525.1405160163.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 01:21:07PM +0200, Alexander Gordeev wrote:
> PowerPC is the only architecture that makes use of hook
> arch_msi_check_device() and does perform some checks to
> figure out if MSI/MSI-X could be enabled for a device.
> However, there are no reasons why those checks could not
> be done within arch_setup_msi_irqs() hook.
> 
> Moving MSI checks into arch_setup_msi_irqs() makes code
> more readable and allows getting rid of unnecessary hook
> arch_msi_check_device().

Michael, Ben,

Any feedback?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
