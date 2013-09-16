Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3IPWqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:46:43 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:52983
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775Ab3IPWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:46:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1379371590.2536.187.camel@snotra.buserror.net>
Subject: Re: [PATCH v9 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
From: Scott Wood <scottwood@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Hongbo Zhang <hongbo.zhang@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "djbw@fb.com" <djbw@fb.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 16 Sep 2013 17:46:30 -0500
In-Reply-To: <20130912171541.GH22013@e106331-lin.cambridge.arm.com>
References: <1377861980-7027-1-git-send-email-hongbo.zhang@freescale.com>
	 <1377861980-7027-3-git-send-email-hongbo.zhang@freescale.com>
	 <20130902155636.GA18206@e106331-lin.cambridge.arm.com>
	 <5225A57E.4030003@freescale.com>
	 <20130912171541.GH22013@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 18:15 +0100, Mark Rutland wrote:
> On Tue, Sep 03, 2013 at 10:01:50AM +0100, Hongbo Zhang wrote:
> > On 09/02/2013 11:58 PM, Mark Rutland wrote:
> > > May some channels be unusable for some reason, or will all eight
> > > channels be wired on any given Elo3 DMA?
> > Sorry, not get your point clearly, maybe you are clear now because of my
> > previous explanations.
> 
> I assume that on any El03 DMA, there won't be a case where you can't
> describe the channel at 0x80, for instance. It will always be present
> (but it might not be wired up to anything any therefore be useful)?
> 
> This was related to my concerns about the status register description --
> if the channels at 0x0,0x80,0x100,0x180 weren't wired, what would get
> described in the dt? I guess that would never actually happen because
> all 8 channels must always be present in the Elo3 IP block.

If a channel is not usable for whatever reason (other than that "used
for a different fixed purpose and thus described with a different
compatible" thing that was mentioned earlier in these threads), wouldn't
it just have status = "disabled" or similar, or be absent?

-Scott



