Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3G3CId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:08:33 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:31296
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756633Ab3G3CIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:08:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1155h)
Message-ID: <51F72022.8070906@freescale.com>
Date: Tue, 30 Jul 2013 10:08:34 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <djbw@fb.com>, <leoli@freescale.com>, <scottwood@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 0/3] DMA: Freescale: Add support for 8-channel DMA
 engine
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com> <20130729105901.GI29095@intel.com>
In-Reply-To: <20130729105901.GI29095@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 06:59 PM, Vinod Koul wrote:
> On Mon, Jul 29, 2013 at 06:49:01PM +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> Hi Vinod, Dan, Scott and Leo, please have a look at these V7 patches.
> The dma relates changes look okay to me.
>
> I need someone to review and ACK the DT bindings.
Scott Wood has ACKed the [1/3] and [2/3].
Thank you Vinod.
>
> ~Vinod
>> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch set
>> adds support this DMA engine.
>>
>> V6->V7 changes:
>> - only remove unnecessary "CHIP-dma" explanations in [1/3]
>>
>> V5->V6 changes:
>> - minor updates of descriptions in binding document and Kconfig
>> - remove [4/4], that should be another patch in future
>>
>> V4->V5 changes:
>> - update description in the dt binding document, to make it more resonable
>> - add new patch [4/4] to eliminate a compiling warning which already exists
>>    for a long time
>>
>> V3->V4 changes:
>> - introduce new patch [1/3] to revise the legacy dma binding document
>> - and then add new paragraph to describe new dt node binding in [2/3]
>> - rebase to latest kernel v3.11-rc1
>>
>> V2->V3 changes:
>> - edit Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>> - edit text string in Kconfig and the driver files, using "elo series" to
>>    mention all the current "elo*"
>>
>> V1->V2 changes:
>> - removed the codes handling the register dgsr1, since it isn't used currently
>> - renamed the DMA DT compatible to "fsl,elo3-dma"
>> - renamed the new dts files to "elo3-dma-<n>.dtsi"
>>
>> Hongbo Zhang (3):
>>    DMA: Freescale: revise device tree binding document
>>    DMA: Freescale: Add new 8-channel DMA engine device tree nodes
>>    DMA: Freescale: update driver to support 8-channel DMA engine
>>
>>   .../devicetree/bindings/powerpc/fsl/dma.txt        |  114 +++++++++++++++-----
>>   arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>>   arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81 ++++++++++++++
>>   arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81 ++++++++++++++
>>   arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>>   drivers/dma/Kconfig                                |    9 +-
>>   drivers/dma/fsldma.c                               |    9 +-
>>   drivers/dma/fsldma.h                               |    2 +-
>>   8 files changed, 264 insertions(+), 40 deletions(-)
>>   create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>>   create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>>
>> -- 
>> 1.7.9.5
>>
>>
>>



