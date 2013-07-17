Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab3GQAI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:08:27 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:7384
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933877Ab3GQAIZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:08:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Tue, 16 Jul 2013 19:08:17 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Neil Horman <nhorman@tuxdriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>
References: <1374014420.8183.342@snotra>
	<1374019445.19894.403.camel@pasglop>
In-Reply-To: <1374019445.19894.403.camel@pasglop> (from
	benh@kernel.crashing.org on Tue Jul 16 19:04:05 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1374019697.8183.351@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 07:04:05 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2013-07-16 at 17:40 -0500, Scott Wood wrote:
> > On 07/15/2013 03:47:06 AM, Benjamin Herrenschmidt wrote:
> > > On Mon, 2013-07-15 at 14:04 +1000, Anton Blanchard wrote:
> > > > Module CRCs are implemented as absolute symbols that get  
> resolved by
> > > > a linker script. We build an intermediate .o that contains an
> > > > unresolved symbol for each CRC. genksysms parses this .o,  
> calculates
> > > > the CRCs and writes a linker script that "resolves" the symbols  
> to
> > > > the calc
> > >
> > > Scott, can somebody from FSL test that on 32-bit and Ack it ?
> > >
> > > Thanks !
> > >
> > > Cheers,
> > > Ben.
> >
> > It boots for me on e500mc and I can insert modules.
> 
> But does perf work ? :-)

What specifically should I do to test it?

-Scott
