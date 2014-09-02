Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaIBLyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:54:46 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56946 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaIBLyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:54:45 -0400
Date: Tue, 2 Sep 2014 12:54:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Josef Ahmad <josef.ahmad@intel.com>
Subject: Re: [PATCH v2 2/4] pci_ids: add support for Intel Quark ILB
Message-ID: <20140902115439.GH17117@lee--X1>
References: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1409654722-6570-3-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409654722-6570-3-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014, Andy Shevchenko wrote:

> From: Josef Ahmad <josef.ahmad@intel.com>
> 
> This patch adds the PCI id for Intel Quark ILB.
> It will be used for GPIO and Multifunction device driver.
> 
> Signed-off-by: Josef Ahmad <josef.ahmad@intel.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/pci_ids.h | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 6ed0bb7..4e82195 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2557,6 +2557,7 @@
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC0	0x0823
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC1	0x0824
>  #define PCI_DEVICE_ID_INTEL_MRST_SD2	0x084F
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB	0x095E
>  #define PCI_DEVICE_ID_INTEL_I960	0x0960
>  #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
>  #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
