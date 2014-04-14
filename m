Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaDNXr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:47:57 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:54815 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaDNXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:47:54 -0400
Date: Mon, 14 Apr 2014 17:47:52 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ryan Desfosses <ryan@desfo.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCHv2] pci: changed "foo* bar" to "foo *bar"
Message-ID: <20140414234752.GA16058@google.com>
References: <1397192513-4498-1-git-send-email-ryan@desfo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397192513-4498-1-git-send-email-ryan@desfo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:01:53AM -0400, Ryan Desfosses wrote:
> change made to resolve following checkpatch message:
>     drivers/pci/pci.c:109: ERROR: "foo* bar" should be "foo *bar"
> branch: Linux 3.14-rc8
> 
> Signed-off-by: Ryan Desfosses <ryan@desfo.org>

Applied to pci/misc, thanks!

> ---
>  drivers/pci/pci.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index fdbc294..4070a60 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -106,7 +106,7 @@ static bool pcie_ari_disabled;
>   * Given a PCI bus, returns the highest PCI bus number present in the set
>   * including the given PCI bus and its list of child PCI buses.
>   */
> -unsigned char pci_bus_max_busnr(struct pci_bus* bus)
> +unsigned char pci_bus_max_busnr(struct pci_bus *bus)
>  {
>  	struct list_head *tmp;
>  	unsigned char max, n;
> @@ -1359,7 +1359,7 @@ static void pcim_release(struct device *gendev, void *res)
>  		pci_disable_device(dev);
>  }
>  
> -static struct pci_devres * get_pci_dr(struct pci_dev *pdev)
> +static struct pci_devres *get_pci_dr(struct pci_dev *pdev)
>  {
>  	struct pci_devres *dr, *new_dr;
>  
> @@ -1373,7 +1373,7 @@ static struct pci_devres * get_pci_dr(struct pci_dev *pdev)
>  	return devres_get(&pdev->dev, new_dr, NULL, NULL);
>  }
>  
> -static struct pci_devres * find_pci_dr(struct pci_dev *pdev)
> +static struct pci_devres *find_pci_dr(struct pci_dev *pdev)
>  {
>  	if (pci_is_managed(pdev))
>  		return devres_find(&pdev->dev, pcim_release, NULL, NULL);
> -- 
> 1.9.1
> 
