Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3GLFdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 01:33:43 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:28063
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125Ab3GLFdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 01:33:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51DF952B.8050802@freescale.com>
Date: Fri, 12 Jul 2013 13:33:31 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <vakul@freescale.com>
Subject: Re: [PATCH V2 1/2] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
References: <1373005626-20726-1-git-send-email-hongbo.zhang@freescale.com> <1373005626-20726-2-git-send-email-hongbo.zhang@freescale.com> <1373388526.8183.191@snotra>
In-Reply-To: <1373388526.8183.191@snotra>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 12:48 AM, Scott Wood wrote:
> On 07/05/2013 01:27:05 AM, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this 
>> patch add
>> the device tree nodes for them.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> ---
>>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi   |   90 
>> +++++++++++++++++++++++++++
>>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi   |   90 
>> +++++++++++++++++++++++++++
>>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi |    4 +-
>>  3 files changed, 182 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>
> Please update Documentation/devicetree/bindings/powerpc/fsl/dma.txt 
> for the new compatible and dgsr1.
OK, thanks.
What's more, some text string in the driver and Kconfig files should be 
updated too, e.g. "Elo / Elo Plus DMA" may be changed to "Elo series 
DMA", will send out v3 patches soon.
>
> -Scott



