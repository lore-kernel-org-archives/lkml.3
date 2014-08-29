Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaH2O2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:28:43 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:46542 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaH2O1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:27:40 -0400
MIME-Version: 1.0
In-Reply-To: <1408705096-31286-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408705096-31286-4-git-send-email-andriy.shevchenko@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 29 Aug 2014 08:27:19 -0600
Message-ID: <CAErSpo42SMnWrTJceuR1cdhUU7rwiBgSHD75k4rwKkaC6sc5JQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] pci_ids: add support for Intel Quark ILB
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Josef Ahmad <josef.ahmad@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 4:58 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> From: Josef Ahmad <josef.ahmad@intel.com>
>
> This patch adds the PCI id for Intel Quark ILB.
> It will be used for GPIO and Multifunction device driver.
>
> Signed-off-by: Josef Ahmad <josef.ahmad@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Assuming that this will actually be used in more than one place:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  include/linux/pci_ids.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 6ed0bb7..4e82195 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2557,6 +2557,7 @@
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC0  0x0823
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC1  0x0824
>  #define PCI_DEVICE_ID_INTEL_MRST_SD2   0x084F
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB    0x095E
>  #define PCI_DEVICE_ID_INTEL_I960       0x0960
>  #define PCI_DEVICE_ID_INTEL_I960RM     0x0962
>  #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB      0x0c60
> --
> 2.1.0
>
