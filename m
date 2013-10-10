Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3JJJjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:39:13 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:41393
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285Ab3JJJjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:39:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz9371I103dK542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOtFY1IowHKOMYeU+9K682+M69vpntzd0g
Date: Thu, 10 Oct 2013 09:39:04 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E8522EFE6@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1379498279-16096-1-git-send-email-b35083@freescale.com>
In-Reply-To: <1379498279-16096-1-git-send-email-b35083@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.98]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9A9dHRk019327

Hi, Vinod,

  Could you please help review this patch? Could it be merged into your next tree?
  Thanks!


Best Regards,
Jingchang


> -----Original Message-----
> From: Lu Jingchang-B35083
> Sent: Wednesday, September 18, 2013 5:58 PM
> To: vinod.koul@intel.com
> Cc: shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; devicetree@vger.kernel.org; Lu Jingchang-
> B35083; Wang Huan-B18965
> Subject: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
> 
> Add Freescale enhanced direct memory(eDMA) controller support.
> The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> to eDMA channels.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
> changes in v6:
>   holding lock in dma_control to prevent race.
> 
> changes in v5:
>   config slave_id when dmaengine_slave_config intead of channel request.
>   adding residue calculation and dma pause/resume device control.
> 
> changes in v4:
>   using exact compatible string in binding document.
> 
> changes in v3:
>   handle all pending interrupt one time.
>   add protect lock on dma transfer complete handling.
>   change desc and tcd alloc flag to GFP_NOWAIT.
>   add sanity check and error messages.
> 
> changes in v2:
>   using generic dma-channels property instead of fsl,dma-channel.
>   rename the binding document to fsl-edma.txt.
> 
> 
>  Documentation/devicetree/bindings/dma/fsl-edma.txt |  84 ++
>  drivers/dma/Kconfig                                |  10 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/fsl-edma.c                             | 944
> +++++++++++++++++++++
>  4 files changed, 1039 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/fsl-edma.txt
>  create mode 100644 drivers/dma/fsl-edma.c

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
