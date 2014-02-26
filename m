Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaBZHil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:38:41 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:37730 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaBZHij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:38:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
Message-ID: <530D99EB.3090900@freescale.com>
Date: Wed, 26 Feb 2014 15:38:19 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <LeoLi@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] DMA: Freescale: driver cleanups and enhancements
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,
How about these patches?
Thanks.


On 01/16/2014 01:47 PM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>
> Hi Vinod Koul and Dan Williams,
> Please have a look at these patches.
>
> Note that patch 2~6 had beed sent out for upstream before, but were together
> with other storage patches at that time, that was not easy for being reviewed
> and merged, so I send them separately this time.
>
> Thanks.
>
> Hongbo Zhang (7):
>    DMA: Freescale: unify register access methods
>    DMA: Freescale: remove attribute DMA_INTERRUPT of dmaengine
>    DMA: Freescale: add fsl_dma_free_descriptor() to reduce code
>      duplication
>    DMA: Freescale: move functions to avoid forward declarations
>    DMA: Freescale: change descriptor release process for supporting
>      async_tx
>    DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
>    DMA: Freescale: add suspend resume functions for DMA driver
>
>   drivers/dma/fsldma.c |  592 ++++++++++++++++++++++++++++++++------------------
>   drivers/dma/fsldma.h |   33 ++-
>   2 files changed, 412 insertions(+), 213 deletions(-)
>



