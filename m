Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaJ1Na5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:30:57 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:37487 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaJ1Nay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <1414497280-3126-18-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com> <1414497280-3126-18-git-send-email-ray.huang@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 Oct 2014 07:30:32 -0600
Message-ID: <CAErSpo5MQMKjrOCv96miaNvcFRsz51dtgHzCwKJD48_n1LQLoQ@mail.gmail.com>
Subject: Re: [PATCH v3 17/19] PCI: Add support for AMD Nolan USB3 DRD
To: Huang Rui <ray.huang@amd.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> This patch adds PCI id for USB3 Dual-Role Device of AMD Nolan (NL) SoC.
> It will be used for PCI quirks and DWC3 device driver.
>
> Signed-off-by: Jason Chang <jason.chang@amd.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Please merge along with the rest of your series.

> ---
>  include/linux/pci_ids.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 1fa99a3..5decad7 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -562,6 +562,7 @@
>  #define PCI_DEVICE_ID_AMD_8131_BRIDGE  0x7450
>  #define PCI_DEVICE_ID_AMD_8131_APIC    0x7451
>  #define PCI_DEVICE_ID_AMD_8132_BRIDGE  0x7458
> +#define PCI_DEVICE_ID_AMD_NL_USB       0x7912
>  #define PCI_DEVICE_ID_AMD_CS5535_IDE    0x208F
>  #define PCI_DEVICE_ID_AMD_CS5536_ISA    0x2090
>  #define PCI_DEVICE_ID_AMD_CS5536_FLASH  0x2091
> --
> 1.9.1
>
