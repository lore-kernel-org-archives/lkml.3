Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3GORMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:12:24 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:32036
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab3GORMW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:12:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Mon, 15 Jul 2013 12:12:17 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH V2 1/2] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
To: Kumar Gala <galak@kernel.crashing.org>
CC: "<hongbo.zhang@freescale.com>" <hongbo.zhang@freescale.com>,
        <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <vakul@freescale.com>
References: <1373005626-20726-1-git-send-email-hongbo.zhang@freescale.com>
	<1373005626-20726-2-git-send-email-hongbo.zhang@freescale.com>
	<6482CAC0-9C6A-4A1E-B158-28D2E1BB2CCE@kernel.crashing.org>
In-Reply-To: <6482CAC0-9C6A-4A1E-B158-28D2E1BB2CCE@kernel.crashing.org>
	(from galak@kernel.crashing.org on Mon Jul 15 08:35:07 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1373908337.8183.301@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 08:35:07 AM, Kumar Gala wrote:
> 
> On Jul 5, 2013, at 1:27 AM, <hongbo.zhang@freescale.com>  
> <hongbo.zhang@freescale.com> wrote:
> 
> > +dma0: dma@100300 {
> > +	#address-cells = <1>;
> > +	#size-cells = <1>;
> > +	compatible = "fsl,elo3-dma";
> 
> why does this require a new compatible?

The binding has changed -- there is now a second reg entry.

-Scott
