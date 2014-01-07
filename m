Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaAGXjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:39:47 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:61886 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaAGXjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:39:37 -0500
Date: Tue, 7 Jan 2014 16:39:34 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Erik Ekman <erik@kryo.se>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Update documentation 00-INDEX file
Message-ID: <20140107233934.GA6247@google.com>
References: <1388610925-12850-1-git-send-email-erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388610925-12850-1-git-send-email-erik@kryo.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 10:15:25PM +0100, Erik Ekman wrote:
> The PCI-DMA-mapping.txt moved to general docs and became DMA-API-HOWTO.txt in 5e07c2c73
> Add new file about PCI Express I/O Virtualization
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>

Applied to pci/misc for v3.14, thanks!

Bjorn

> ---
>  Documentation/PCI/00-INDEX | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/PCI/00-INDEX b/Documentation/PCI/00-INDEX
> index 812b17f..147231f 100644
> --- a/Documentation/PCI/00-INDEX
> +++ b/Documentation/PCI/00-INDEX
> @@ -2,12 +2,12 @@
>  	- this file
>  MSI-HOWTO.txt
>  	- the Message Signaled Interrupts (MSI) Driver Guide HOWTO and FAQ.
> -PCI-DMA-mapping.txt
> -	- info for PCI drivers using DMA portably across all platforms
>  PCIEBUS-HOWTO.txt
>  	- a guide describing the PCI Express Port Bus driver
>  pci-error-recovery.txt
>  	- info on PCI error recovery
> +pci-iov-howto.txt
> +	- the PCI Express I/O Virtualization HOWTO
>  pci.txt
>  	- info on the PCI subsystem for device driver authors
>  pcieaer-howto.txt
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
