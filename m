Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3JAUHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:07:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3JAUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:07:44 -0400
Date: Tue, 1 Oct 2013 13:07:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: cjb@laptop.org, bhelgaas@google.com, adrian.hunter@intel.com,
        wfp5p@virginia.edu, g.liakhovetski@gmx.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] pci_id: add Intel Merrifield mmc pci id
Message-ID: <20131001200755.GA28165@kroah.com>
References: <1380657633-19543-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380657633-19543-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 01:00:32PM -0700, David Cohen wrote:
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  include/linux/pci_ids.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 97fbecd..2a89103 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2551,6 +2551,7 @@
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC0	0x0823
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC1	0x0824
>  #define PCI_DEVICE_ID_INTEL_MRST_SD2	0x084F
> +#define PCI_DEVICE_ID_INTEL_MRFL_MMC	0x1190

Please read the top of this file for why you shouldn't be adding new
device ids to it.

thanks,

greg k-h
