Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaAFG34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:29:56 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:52000
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbaAFG3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:29:55 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I14ffIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 6 Jan 2014 14:30:03 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Dong Aisheng <dongas86@gmail.com>, Chris Ball <cjb@laptop.org>,
        <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-ID: <20140106063000.GC26128@S2101-09.ap.freescale.net>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
 <20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
 <CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
 <20131217031600.GG6691@S2101-09.ap.freescale.net>
 <CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
 <20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Jan 06, 2014 at 05:22:43PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 17 Dec 2013 16:06:19 +0800 Dong Aisheng <dongas86@gmail.com> wrote:
> >
> > I tested that Chris tree does not have problem.
> > It's caused by IMX tree updates.
> > 
> > Chris,
> > Is the way Shawn suggested OK for you?
> 
> Can we have some resolution of this please?  This failed to build again
> today so I have used the version of the mmc tree from next-20131212
> again.  I tried the obvious fix (s/pinctrl_usdhc4_1/pinctrl_usdhc4/) but
> that didn't work.

I'm afraid that using a working mmc tree next branch might be the only
option until Chris comes online to drop the patch from his tree.

Shawn

