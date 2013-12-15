Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3LONFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 08:05:51 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:49335
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab3LONFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 08:05:49 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 15 Dec 2013 21:06:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Brown <broonie@kernel.org>
CC: Fabio Estevam <festevam@gmail.com>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] regulator: core: Use
 postcore_initcall(regulator_init_complete)
Message-ID: <20131215130636.GA12686@S2101-09.ap.freescale.net>
References: <1385416655-7859-1-git-send-email-festevam@gmail.com>
 <20131126004603.GU14725@sirena.org.uk>
 <20131127005520.GS14725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131127005520.GS14725@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:55:20AM +0000, Mark Brown wrote:
> On Tue, Nov 26, 2013 at 12:46:03AM +0000, Mark Brown wrote:
> 
> > lot changing the callers is probably the cleanest.  I'll probably do
> > that tomorrow if a patch doesn't turn up before then.
> 
> Sorry, that'll now be Wednesday - an unusually busy day started by
> someone deciding to fell trees outside my window early this morning put
> a bit of a spanner in the works.

What is going on about that patch?

Shawn

