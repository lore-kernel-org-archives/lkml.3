Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaDHL01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:26:27 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:51950
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756351AbaDHL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:26:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Tue, 8 Apr 2014 19:07:40 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: fsl_sai: Fix Bit Clock Polarity configurations
Message-ID: <20140408110738.GA10745@MrMyself>
References: <1396595387-4371-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140404100532.GN14763@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140404100532.GN14763@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 11:05:32AM +0100, Mark Brown wrote:
> On Fri, Apr 04, 2014 at 03:09:47PM +0800, Nicolin Chen wrote:
> > The BCP bit in TCR4/RCR4 register rules as followings:
> >   0 Bit clock is active high with drive outputs on rising edge
> >     and sample inputs on falling edge.
> >   1 Bit clock is active low with drive outputs on falling edge
> >     and sample inputs on rising edge.
> 
> Applied, thanks.

Sir, I can't find this patch on any of the remote branches: for-next,
topic/fsl-sai and fix/fsl-sai. Where could I find it?

Thank you,
Nicolin

