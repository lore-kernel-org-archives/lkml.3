Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3LNMPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:15:41 -0500
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:50108
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568Ab3LNMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:15:35 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579eh37d5kz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz17326ah8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 14 Dec 2013 20:16:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philippe De Muyter <phdm@macq.eu>
CC: <linux-kernel@vger.kernel.org>, <b29396@freescale.com>, <cjb@laptop.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: ARM,sdhci_esdhc_imx: INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock
 order detected
Message-ID: <20131214121613.GA16177@S2101-09.ap.freescale.net>
References: <20131212144925.GA14995@frolo.macqel>
 <20131213133430.GW18380@S2101-09.ap.freescale.net>
 <20131213221425.GA32189@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131213221425.GA32189@frolo.macqel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:14:25PM +0100, Philippe De Muyter wrote:
> Hi Shawn,
> 
> On Fri, Dec 13, 2013 at 09:34:32PM +0800, Shawn Guo wrote:
> > Hi Philippe,
> > 
> > On Thu, Dec 12, 2013 at 03:49:25PM +0100, Philippe De Muyter wrote:
> > > Hello,
> > > 
> > > I have just booted 3.13-rc3 on my i.MX6DL board, done nothing but watch
> > > it start, and I have got this!
> > 
> > There is a patch [1] from Fabio for this issue.
> > 
> > Shawn
> > 
> > [1] http://thread.gmane.org/gmane.linux.kernel.mmc/23786
> > 
> > > ======================================================
> > > [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> ...
> 
> Thanks.  That fixed the problem.  Will that go to 3.13 final ?

That's a question for Chris.

Shawn

