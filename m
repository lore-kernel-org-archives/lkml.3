Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaFWUIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:08:12 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:58070 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <1403280836-26943-2-git-send-email-alvin.chen@intel.com>
References: <1403280836-26943-1-git-send-email-alvin.chen@intel.com> <1403280836-26943-2-git-send-email-alvin.chen@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 23 Jun 2014 14:07:47 -0600
Message-ID: <CAErSpo7NW=3yLNY0XXLKVTqSqL=qbNEx_vp-583=32pY1Y=6TQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pci: Quark SDIO host controller supporting
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:13 AM, Chen, Alvin <alvin.chen@intel.com> wrote:
> From: Derek Browne <Derek.Browne@intel.com>
>
> On Intel Quark, there is a SDIO host controller. This patch is added to
> enable the SDIO host controller.
>
> Signed-off-by: Derek Browne <Derek.Browne@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
>  drivers/mmc/host/sdhci-pci.c |   12 ++++++++++++
>  include/linux/pci_ids.h      |    2 ++

Please read the comment at the top of pci_ids.h:

 *      Do not add new entries to this file unless the definitions
 *      are shared between multiple drivers.

If the ID you're adding is shared, please mention the sharing in your changelog.

> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2557,6 +2557,7 @@
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC0  0x0823
>  #define PCI_DEVICE_ID_INTEL_MFD_EMMC1  0x0824
>  #define PCI_DEVICE_ID_INTEL_MRST_SD2   0x084F
> +#define PCI_DEVICE_ID_INTEL_QUARK_ILB  0x095E

This ID doesn't appear to be used at all.

>  #define PCI_DEVICE_ID_INTEL_I960       0x0960
>  #define PCI_DEVICE_ID_INTEL_I960RM     0x0962
>  #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB      0x0c60
> @@ -2579,6 +2580,7 @@
>  #define PCI_DEVICE_ID_INTEL_82840_HB   0x1a21
>  #define PCI_DEVICE_ID_INTEL_82845_HB   0x1a30
>  #define PCI_DEVICE_ID_INTEL_IOAT       0x1a38
> +#define PCI_DEVICE_ID_INTEL_QRK_SD     0x08A7
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN        0x1c41
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX        0x1c5f
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0     0x1d40
> --
> 1.7.9.5
>
