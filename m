Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaHUIcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:32:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:34697 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbaHUIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:32:08 -0400
Date: Thu, 21 Aug 2014 09:31:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: microcai <microcaicai@gmail.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_ich: add support for Intel Z97 chipset
Message-ID: <20140821083158.GT4266@lee--X1>
References: <1407520519-1755-1-git-send-email-microcaicai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407520519-1755-1-git-send-email-microcaicai@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Aug 2014, microcai wrote:

> From: Wanzhao Cai <microcaicai@gmail.com>
> 
> This patch adds the LPC Controller Device IDs found on ASUS Z97-A mother broad.
> 
> lspci output for this mother broad:
> 
> 00:1f.0 ISA bridge [0601]: Intel Corporation 9 Series Chipset Family Z97 LPC Controller [8086:8cc4]
> 	Subsystem: ASUSTeK Computer Inc. Device [1043:8534]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
> 	DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> 	<PERR- INTx-
> 	Latency: 0
> 	Capabilities: [e0] Vendor
> 	Specific Information: Len=0c <?>
> 	Kernel driver in use: lpc_ich
> 	Kernel modules: lpc_ich
> 
> Signed-off-by: microcai <microcaicai@gmail.com>

Full names only please.

Patch looks okay though.

> ---
>  drivers/mfd/lpc_ich.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> index 7d8482f..e4b37c0 100644
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -738,6 +738,7 @@ static const struct pci_device_id lpc_ich_ids[] = {
>  	{ PCI_VDEVICE(INTEL, 0x1f3b), LPC_AVN},
>  	{ PCI_VDEVICE(INTEL, 0x0f1c), LPC_BAYTRAIL},
>  	{ PCI_VDEVICE(INTEL, 0x2390), LPC_COLETO},
> +	{ PCI_VDEVICE(INTEL, 0x8cc4), LPC_WPT_LP},
>  	{ PCI_VDEVICE(INTEL, 0x9cc1), LPC_WPT_LP},
>  	{ PCI_VDEVICE(INTEL, 0x9cc2), LPC_WPT_LP},
>  	{ PCI_VDEVICE(INTEL, 0x9cc3), LPC_WPT_LP},

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
