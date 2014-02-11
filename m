Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaBKIQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:16:39 -0500
Received: from [216.32.181.182] ([216.32.181.182]:35245 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbaBKIQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:16:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Tue, 11 Feb 2014 16:06:13 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: fsl-spdif: big-endian support
Message-ID: <20140211080612.GC18803@MrMyself>
References: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
 <20140211071034.GA18803@MrMyself>
 <1a10273e564a4bb7a5aafe3f01ccffa2@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1a10273e564a4bb7a5aafe3f01ccffa2@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:39:44PM +0800, Xiubo Li-B47053 wrote:
> 
> 
> > > +   - big-endian : If this property is absent, the native endian mode will
> > > +   be in use as default, or the big endian mode will be in use for all the
> > > +   device registers.
> > > +
> > 
> > @Shawn
> > Does DT have an existing approach to determine if the current SoC this IP
> > uses is BE or LE? I am thinking the scenario that if all drivers support
> > BE/LE while the SoC is big-endian, all the nodes in the DT would have to
> > include a duplicated property (big-endian).
> > 
> 
> @Nicolin, @Shawn
> One special scenario likes the LS1 platform, the CPU and a few devices are in
> LE mode and other devices will be in BE mode.

Hmm... a bit strange to me. But I think it then should be fine here if it's
plausible as you describe.

Please revise the patch and send it to see if there's any comment from others.

And for both revised patches:
Acked-by: Nicolin Chen <Guangyu.Chen@freescale.com>

Thank you


