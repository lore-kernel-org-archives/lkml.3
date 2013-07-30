Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3G3Kuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:50:55 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:11273
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab3G3Kuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:50:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z2005kz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Tue, 30 Jul 2013 18:54:50 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Axel Lin <axel.lin@ingics.com>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: pfuze100: Fix n_voltages setting for
 SW2~SW4 with high bit set
Message-ID: <20130730105449.GA4084@Robin-OptiPlex-780>
References: <1375152388.4265.1.camel@phoenix>
 <20130730032310.GC1430@Robin-OptiPlex-780>
 <20130730102110.GK9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130730102110.GK9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
	Thanks for your kindly remind.

On Tue, Jul 30, 2013 at 11:21:10AM +0100, Mark Brown wrote:
> On Tue, Jul 30, 2013 at 11:23:11AM +0800, Robin Gong wrote:
> > Ok for me.
> 
> For Linux kernel process you should say
> 
>    Acked-by: Robin Gong <b38343@freescale.com>
> 
> or
> 
>    Reviewed-by: Robin Gong <b38343@freescale.com>
> 
> to say if you are OK - the first means you didn't really review but it
> looks OK, the second means you did a proper review.



