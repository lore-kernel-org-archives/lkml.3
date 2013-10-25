Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3JYB2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 21:28:43 -0400
Received: from [216.32.181.183] ([216.32.181.183]:55494 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab3JYB2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 21:28:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 25 Oct 2013 09:27:28 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rostislav Lisovy <lisovy@gmail.com>
CC: Matt Sealey <neko@bakuhatsu.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, <pisa@cmp.felk.cvut.cz>
Subject: Re: [PATCH 3/4] ARM: dts: i.MX53: dts for Voipac x53-dmm-668 module
Message-ID: <20131025012725.GG14529@S2101-09.ap.freescale.net>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
 <1382461643-16790-4-git-send-email-lisovy@gmail.com>
 <20131023072738.GI2839@S2101-09.ap.freescale.net>
 <1382641926.16515.2.camel@lolumad>
 <CAHCPf3vB+HYkFoBYcbVM6Ecp+8BSApG2JZi1PRwc7ag6ygszOw@mail.gmail.com>
 <1382644733.19373.2.camel@lolumad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382644733.19373.2.camel@lolumad>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 09:58:53PM +0200, Rostislav Lisovy wrote:
> I saw that most of the vendor prefixes are somehow shortened (e.g.
> Freescale -- fsl, etc.).

The 'fsl' is the stock symbol of Freescale.  If that's not the case for
voipac, I think 'voipac' is more appropriate.

Shawn

> On Thu, 2013-10-24 at 14:49 -0500, Matt Sealey wrote: 
> > On Thu, Oct 24, 2013 at 2:12 PM, Rostislav Lisovy <lisovy@gmail.com> wrote:
> > > Dear Shawn;
> > > Thank you for your comments.
> > > Should I also add Voipac to
> > > Documentation/devicetree/bindings/vendor-prefixes.txt?
> > 
> > I would agree with that, but why is your chosen prefix "vp" instead of
> > "voipac" anyway?
> > 
> 
> 

