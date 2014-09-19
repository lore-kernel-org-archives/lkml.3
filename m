Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaISFbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:31:32 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56930 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaISFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:31:30 -0400
Date: Thu, 18 Sep 2014 23:31:26 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: linux-pci@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, bp@alien8.de, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pci_ids: Add PCI device IDs for F15h M60h
Message-ID: <20140919053126.GC21128@google.com>
References: <1411070195-10177-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411070195-10177-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:56:35PM -0500, Aravind Gopalakrishnan wrote:
> Add F3, F4 device IDs to be used in amd_nb.c and amd64_edac.c
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Please merge this along with the rest of your series.

> ---
>  include/linux/pci_ids.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index aa0d390..6a2a72a 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -522,6 +522,8 @@
>  #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
>  #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
>  #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
> +#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F3 0x1573
> +#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F4 0x1574
>  #define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
>  #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
>  #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
> -- 
> 2.0.2
> 
