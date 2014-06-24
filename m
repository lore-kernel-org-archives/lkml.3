Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaFXNZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:25:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaFXNZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:25:40 -0400
Date: Tue, 24 Jun 2014 09:25:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Message-ID: <20140624132527.GB1215@kroah.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 08:51:43AM -0700, Chen, Alvin wrote:
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 00661d3..1ea8803 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -823,6 +823,48 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
>  	return -ETIMEDOUT;
>  }
>  
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +bool usb_is_intel_qrk(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +
> +}
> +EXPORT_SYMBOL_GPL(usb_is_intel_qrk);

There is no lack of vowels available to you, please use them.

greg k-h
