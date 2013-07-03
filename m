Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121Ab3GCTCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:02:23 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:58213
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965048Ab3GCTCT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:02:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Wed, 3 Jul 2013 14:02:08 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 1/2] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
To: Hongbo Zhang <hongbo.zhang@freescale.com>
CC: Hongbo Zhang <hongbo.zhang@freescale.com>, <vinod.koul@intel.com>,
        <djbw@fb.com>, <vakul@freescale.com>, <leoLi@freescale.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linuxppc-dev@lists.ozlabs.org>
References: <1372650378-2936-1-git-send-email-hongbo.zhang@freescale.com>
	<51D3A030.4020608@freescale.com> <51D3D76B.5040306@freescale.com>
In-Reply-To: <51D3D76B.5040306@freescale.com> (from
	hongbo.zhang@freescale.com on Wed Jul  3 02:48:59 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1372878128.8183.143@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 02:48:59 AM, Hongbo Zhang wrote:
> On 07/03/2013 11:53 AM, Hongbo Zhang wrote:
>> hmm...add the devicetree-discuss@lists.ozlabs.org into list.
>> 
>> Note that we are discussing a better naming for this new compatible  
>> property in the corresponding [PATCH 2/2], so I will resend a v2 of  
>> this patch.
>> 
>> 
>> On 07/01/2013 11:46 AM, hongbo.zhang@freescale.com wrote:
>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>> 
>>> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this  
>>> patch add
>>> the device tree nodes for them.
>>> 
>>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>>> ---
>>>   arch/powerpc/boot/dts/fsl/qoriq-dma2-0.dtsi |   90  
>>> +++++++++++++++++++++++++++
>>>   arch/powerpc/boot/dts/fsl/qoriq-dma2-1.dtsi |   90  
>>> +++++++++++++++++++++++++++
>>>   arch/powerpc/boot/dts/fsl/t4240si-post.dtsi |    4 +-
>>>   3 files changed, 182 insertions(+), 2 deletions(-)
>>>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-dma2-0.dtsi
>>>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-dma2-1.dtsi
> Scott, any comment of these two file names?

There's "dma2" again...

How about elo3-dma-<n>.dtsi?

-Scott
