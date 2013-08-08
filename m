Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab3HHIhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:37:24 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:42834
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757377Ab3HHIhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:37:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh35h1155h)
Message-ID: <520358BD.6000808@freescale.com>
Date: Thu, 8 Aug 2013 16:37:17 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Export the ecc step size to user applications
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>
In-Reply-To: <1368607606-4344-1-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem & Brian:
> In order to implement the NAND boot for some Freescale's chips, such as
> imx23/imx28/imx50/imx6, we use a tool (called kobs-ng) to burn the uboot
> and some metadata to nand chip. And the ROM code will use the metadata to
> configrate the BCH, and to find the uboot.
>
> The ECC information(ecc step size, ecc strength) which is used to configrate
> the BCH is part of the metadata. The kobs-ng can gets the ecc strength from
> the sys node /sys/*/mtdX/ecc_strength now. But it can't gets the ecc step size.
>
> This patch set is used to export the ecc step size to user applications.
> With this patch set, the kobs-ng can gets the ecc step size now.
>
> v1 --> v2:
> 	[1] rename the ecc_size to ecc_step.
> 	[2] rebase on the latest l2-mtd.
>
> Huang Shijie (4):
>   mtd: add a new field to mtd_info{}
>   mtd: add a new sys node to show the ecc step size
>   mtd: set the ecc step size for master/slave mtd_info
>   mtd: gpmi: update the ecc step size for mtd_info{}
>
>  drivers/mtd/mtdcore.c                  |   11 +++++++++++
>  drivers/mtd/mtdpart.c                  |    1 +
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.c |    1 +
>  drivers/mtd/nand/nand_base.c           |    1 +
>  include/linux/mtd/mtd.h                |    3 +++
>  5 files changed, 17 insertions(+), 0 deletions(-)
>
Could you merge this patch set ?

thanks
Huang Shijie


