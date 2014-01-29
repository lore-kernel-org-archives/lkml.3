Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaA2D73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 22:59:29 -0500
Received: from [207.46.163.27] ([207.46.163.27]:33569 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754658AbaA2D7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 22:59:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 29 Jan 2014 11:58:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the imx-mxs tree with the arm tree
Message-ID: <20140129035817.GB13518@S2101-09.ap.freescale.net>
References: <20140129113514.86275e22015dea313d78d5e1@canb.auug.org.au>
 <20140129011310.GT15937@n2100.arm.linux.org.uk>
 <20140129011803.GA13518@S2101-09.ap.freescale.net>
 <20140129132513.3846b7eb56650e4208d2d24a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140129132513.3846b7eb56650e4208d2d24a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 01:25:13PM +1100, Stephen Rothwell wrote:
> Hi Shawn,
> 
> On Wed, 29 Jan 2014 09:18:06 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
> >
> > I will rebase my branch on v3.14-rc1 once it's out.
> 
> Um, does that mean that all that stuff is *not* destined for v3.14? ...

Yes, Stephen.  That's the case.  If it causes problem for you, you can
keep excluding my for-next branch from linux-next until I rebase it on
v3.14-rc1.

Shawn

