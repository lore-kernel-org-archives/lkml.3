Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3G3CKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:10:11 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:7555 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587Ab3G3CKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:10:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1155h)
Message-ID: <51F72081.8060803@freescale.com>
Date: Tue, 30 Jul 2013 10:10:09 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/3] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com> <1375094944-3343-3-git-send-email-hongbo.zhang@freescale.com> <1375135852.30721.60@snotra>
In-Reply-To: <1375135852.30721.60@snotra>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 06:10 AM, Scott Wood wrote:
> On 07/29/2013 05:49:03 AM, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this 
>> patch adds
>> the device tree nodes for them.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> ---
>>  .../devicetree/bindings/powerpc/fsl/dma.txt        |   66 
>> ++++++++++++++++
>>  arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81 
>> ++++++++++++++++++++
>>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81 
>> ++++++++++++++++++++
>>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>>  5 files changed, 232 insertions(+), 4 deletions(-)
>>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>
> ACK
Thank you Scott for all the review comments.
>
> -Scott



