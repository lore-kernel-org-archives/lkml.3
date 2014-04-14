Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaDNXtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:49:11 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:40089 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaDNXtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:49:09 -0400
Date: Mon, 14 Apr 2014 17:49:06 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ryan Desfosses <ryan@desfo.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCHv2] pci: added or removed a space to resolve checkpatch
 message
Message-ID: <20140414234906.GB16058@google.com>
References: <1397195240-4894-1-git-send-email-ryan@desfo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397195240-4894-1-git-send-email-ryan@desfo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:47:20AM -0400, Ryan Desfosses wrote:
> changes made to resolve following messages:
>   WARNING: please, no spaces at the start of a line
>   ERROR: space prohibited after that '!' (ctx:BxW)
>   ERROR: space required before the open parenthesis '('
> 
> Signed-off-by: Ryan Desfosses <ryan@desfo.org>

Applied to pci/misc, thanks!

> ---
>  drivers/pci/pci.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index fdbc294..20bcb1a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -114,7 +114,7 @@ unsigned char pci_bus_max_busnr(struct pci_bus* bus)
>  	max = bus->busn_res.end;
>  	list_for_each(tmp, &bus->children) {
>  		n = pci_bus_max_busnr(pci_bus_b(tmp));
> -		if(n > max)
> +		if (n > max)
>  			max = n;
>  	}
>  	return max;
> @@ -489,7 +489,7 @@ static inline bool platform_pci_power_manageable(struct pci_dev *dev)
>  }
>  
>  static inline int platform_pci_set_power_state(struct pci_dev *dev,
> -                                                pci_power_t t)
> +					       pci_power_t t)
>  {
>  	return pci_platform_pm ? pci_platform_pm->set_state(dev, t) : -ENOSYS;
>  }
> @@ -1431,7 +1431,7 @@ void pcim_pin_device(struct pci_dev *pdev)
>   * devices are added. This is the default implementation. Architecture
>   * implementations can override this.
>   */
> -int __weak pcibios_add_device (struct pci_dev *dev)
> +int __weak pcibios_add_device(struct pci_dev *dev)
>  {
>  	return 0;
>  }
> @@ -1454,7 +1454,7 @@ void __weak pcibios_release_device(struct pci_dev *dev) {}
>   * is the default implementation. Architecture implementations can
>   * override this.
>   */
> -void __weak pcibios_disable_device (struct pci_dev *dev) {}
> +void __weak pcibios_disable_device(struct pci_dev *dev) {}
>  
>  static void do_pci_disable_device(struct pci_dev *dev)
>  {
> @@ -2565,7 +2565,7 @@ static int __pci_request_selected_regions(struct pci_dev *pdev, int bars,
>  	return 0;
>  
>  err_out:
> -	while(--i >= 0)
> +	while (--i >= 0)
>  		if (bars & (1 << i))
>  			pci_release_region(pdev, i);
>  
> @@ -2798,7 +2798,7 @@ pci_set_mwi(struct pci_dev *dev)
>  		return rc;
>  
>  	pci_read_config_word(dev, PCI_COMMAND, &cmd);
> -	if (! (cmd & PCI_COMMAND_INVALIDATE)) {
> +	if (!(cmd & PCI_COMMAND_INVALIDATE)) {
>  		dev_dbg(&dev->dev, "enabling Mem-Wr-Inval\n");
>  		cmd |= PCI_COMMAND_INVALIDATE;
>  		pci_write_config_word(dev, PCI_COMMAND, cmd);
> -- 
> 1.9.1
> 
