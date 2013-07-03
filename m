Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3GCQlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:41:40 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:59569
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab3GCQlj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:41:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
Date: Wed, 3 Jul 2013 11:41:31 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 2/2] DMA: Freescale: update driver to support 8-channel
 DMA engine
To: Hongbo Zhang <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <vakul@freescale.com>,
        <leoLi@freescale.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <51D39EE0.1040901@freescale.com> (from
	hongbo.zhang@freescale.com on Tue Jul  2 22:47:44 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1372869691.8183.130@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 10:47:44 PM, Hongbo Zhang wrote:
> On 07/03/2013 07:13 AM, Scott Wood wrote:
>> Wait a second -- how are we even getting into this code on these new  
>> DMA controllers?  All 85xx-family DMA controllers use  
>> fsldma_chan_irq directly.
>> 
> Right, we are using fsldma_chan_irq, this code never run.
> I just see there is such code for elo/eloplus DMA controllers, so I  
> update it for the new 8-channel DMA.

That code is used for elo (e.g. mpc83xx DMA), but not eloplus.

-Scott
