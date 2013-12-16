Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3LPIj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:39:59 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:49887
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471Ab3LPIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:39:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehz98dI9371I1432I1447Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hz8dhz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 16 Dec 2013 16:40:52 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: Mark Brown <broonie@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] regulator: core: Use
 postcore_initcall(regulator_init_complete)
Message-ID: <20131216084050.GA30671@S2101-09.ap.freescale.net>
References: <1385416655-7859-1-git-send-email-festevam@gmail.com>
 <20131126004603.GU14725@sirena.org.uk>
 <20131127005520.GS14725@sirena.org.uk>
 <20131215130636.GA12686@S2101-09.ap.freescale.net>
 <CAOMZO5DHYgJY4dpB+znx9g3TChUNn3ujdtCf0OsmkbGtrE9R1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOMZO5DHYgJY4dpB+znx9g3TChUNn3ujdtCf0OsmkbGtrE9R1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 03:03:00PM -0200, Fabio Estevam wrote:
> On Sun, Dec 15, 2013 at 11:06 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> 
> > What is going on about that patch?
> 
> Mark fixed the problem with the following commits:

Thanks for the info, Fabio.

Shawn

> 
> commit 75bc9641cadd2a3f91f9c2e7f2fdfdeb8bd4b1d6
> Author: Mark Brown <broonie@linaro.org>
> Date:   Wed Nov 27 16:22:53 2013 +0000
> 
>     regulator: core: Check for DT every time we check full constraints
> 
>     Eliminate the gap between DT becoming available and this being used to say
>     we have full constraints by checking directly for DT every time we check
>     for full constraints. This improves interoperaton with optional regulator
>     support.
> 
>     Signed-off-by: Mark Brown <broonie@linaro.org>
>     Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> commit 87b2841753e1694fc96fefb467f6aff9940b07af
> Author: Mark Brown <broonie@linaro.org>
> Date:   Wed Nov 27 16:13:10 2013 +0000
> 
>     regulator: core: Replace checks of have_full_constraints with a function
> 
>     Simple code reorganisation so we can change the logic for deciding what
>     full constraints are more easily.
> 
>     Signed-off-by: Mark Brown <broonie@linaro.org>
> 
> Regards,
> 
> Fabio Estevam

