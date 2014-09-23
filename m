Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaIWVCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:02:00 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48209 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbaIWVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:01:58 -0400
Date: Tue, 23 Sep 2014 15:01:54 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 0/3] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140923210154.GB27117@google.com>
References: <cover.1410078503.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410078503.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 08:57:52PM +0200, Alexander Gordeev wrote:
> Hello,
> 
> This is a cleanup effort to get rid of arch_msi_check_device() function.
> 
> I am sending v2 series, since kbuild for v1 reports compile errors on
> ppc4xx and Armada 370. Still, I have not checked the fixes on these
> platforms.
> 
> Changes since v1:
>   - patch 1: 'pdev' undeclared compile error fixed on ppc4xx. I updated
>              changelog and removed ACK from this patch in case there are
>              any objections;
> 
>   - patch 2: 'struct msi_chip' has no 'check_device' error fixed on
>              Armada 370 - armada_370_xp_check_msi_device() hook removed;
> 
>   - patch 3: msi_check_device() renamed to pci_msi_supported(). This is
>              the very same patch I sent earlier;
> 
> Thanks!
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-pci@vger.kernel.org
> 
> Alexander Gordeev (3):
>   patch 1 - PCI/MSI/PPC: Remove arch_msi_check_device()
>   patch 2 - PCI/MSI/Armada-370-xp: Remove arch_msi_check_device()
>   patch 3 - PCI/MSI: Remove arch_msi_check_device()

Applied (with some changes to 3/3) to pci/msi for v3.18, thanks!  Let me
know if you see any issues.

Bjorn
