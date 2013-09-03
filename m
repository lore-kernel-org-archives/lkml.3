Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3ICXK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:10:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51909 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154Ab3ICXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:10:54 -0400
Date: Tue, 3 Sep 2013 17:10:50 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Joe Perches <joe@perches.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci.h: Fix typo, remove unnecessary !!
Message-ID: <20130903231050.GA24733@google.com>
References: <1378240265.7347.24.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378240265.7347.24.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 01:31:05PM -0700, Joe Perches wrote:
> Use normal kernel-doc "Returns:" instead of retruns
> Assignment to bool is always 1 or 0 so the !! isn't necessary.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to pci/misc, thanks.  This branch will be rebased and will
not appear in -next until after v3.12-rc1.

> ---
>  include/linux/pci.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index da172f9..ee0f3b6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1749,11 +1749,11 @@ static inline int pci_pcie_cap(struct pci_dev *dev)
>   * pci_is_pcie - check if the PCI device is PCI Express capable
>   * @dev: PCI device
>   *
> - * Retrun true if the PCI device is PCI Express capable, false otherwise.
> + * Returns: true if the PCI device is PCI Express capable, false otherwise.
>   */
>  static inline bool pci_is_pcie(struct pci_dev *dev)
>  {
> -	return !!pci_pcie_cap(dev);
> +	return pci_pcie_cap(dev);
>  }
>  
>  /**
> 
> 
