Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaDOCcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:32:21 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:20417
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbaDOCcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:32:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Tue, 15 Apr 2014 10:26:58 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <timur@tabi.org>, <Li.Xiubo@freescale.com>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH v2 1/2] ASoC: fsl_sai: Add clock controls for SAI
Message-ID: <20140415022656.GC7197@MrMyself>
References: <cover.1396432924.git.Guangyu.Chen@freescale.com>
 <12898efab7a5907e6ed1c438a486692f59ef9d8b.1396432924.git.Guangyu.Chen@freescale.com>
 <20140414204331.GE25182@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140414204331.GE25182@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:43:31PM +0100, Mark Brown wrote:
> On Wed, Apr 02, 2014 at 06:10:19PM +0800, Nicolin Chen wrote:
> 
> > -- clock-names : Must include the "sai" entry.
> > +- clock-names : Must include the "bus" for register access and "mclk1" "mclk2"
> > +  "mclk3" for bit clock and frame clock providing.
> 
> This breaks compatibilty with old DTs - it just removes the "sai" name.
> It's OK to deprecate the "sai" clock name but you need to keep support
> for DTs that only specify that, there's no code for that left in the
> driver.

Sir, you've already applied the v6 of this patch last week :)
And I can still find it in topic/fsl-sai.

ca3e35c ASoC: fsl_sai: Add clock controls for SAI

And regarding the old DTs compatibilty, Shawn has already reminded me
in his comments against one of the version. I took his advice and made
the patch compatible with the old 'sai' clock binding within that v6.

Thank you,
Nicolin

