Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaIPWVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:21:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50929 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaIPWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:21:33 -0400
Date: Tue, 16 Sep 2014 16:21:29 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, gleb@kernel.org,
        pbonzini@redhat.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: Re: [PATCH v4 0/4 resend] Introduce device assignment flag operation
 helper function
Message-ID: <20140916222129.GD5050@google.com>
References: <1410229288-31829-1-git-send-email-ethan.zhao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410229288-31829-1-git-send-email-ethan.zhao@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:21:24AM +0800, Ethan Zhao wrote:
> This patch set introduces three PCI device flag operation helper functions
> when set pci device PF/VF to assigned or deassigned status also check it.
> and patch 2,3,4 apply these helper functions to KVM,XEN and PCI.
> 
> v2: simplify unnecessory ternary operation in function pci_is_dev_assigned().
> v3: amend helper function naming.
> v4: fix incorrect type in return expression warning found by Fengguang Wu.
> 
> Appreciate suggestion from
> alex.williamson@redhat.com,
> david.vrabel@citrix.com,
> alexander.h.duyck@intel.com
> 
> Resend for v3.18 building.

Applied to pci/virtualization for v3.18, thanks.

> 
> Thanks,
> Ethan
> ---
> Ethan Zhao (4):
>   PCI: introduce helper functions for device flag operation
>   KVM: use pci device flag operation helper functions
>   xen-pciback: use pci device flag operation helper function
>   PCI: use device flag operation helper function in iov.c
> 
>  drivers/pci/iov.c                  |    2 +-
>  drivers/xen/xen-pciback/pci_stub.c |    4 ++--
>  include/linux/pci.h                |   13 +++++++++++++
>  virt/kvm/assigned-dev.c            |    2 +-
>  virt/kvm/iommu.c                   |    4 ++--
>  5 files changed, 19 insertions(+), 6 deletions(-)
> 
