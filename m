Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaBYDtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:49:14 -0500
Received: from [207.46.163.28] ([207.46.163.28]:20228 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbaBYDtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:49:11 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI146fI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 11:46:36 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "Austin, Brian" <Brian.Austin@cirrus.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
Message-ID: <20140225034635.GB7343@MrMyself>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
 <20140225000027.GI25940@sirena.org.uk>
 <20140225023840.GB7229@MrMyself>
 <20140225030947.GO25940@sirena.org.uk>
 <20140225031313.GA7343@MrMyself>
 <20140225033929.GP25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140225033929.GP25940@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 12:39:29PM +0900, Mark Brown wrote:
> On Tue, Feb 25, 2014 at 11:13:14AM +0800, Nicolin Chen wrote:
> > On Tue, Feb 25, 2014 at 12:09:47PM +0900, Mark Brown wrote:
> 
> > > We should be able to arrange to have the ESAI be a clock provider
> > > shouldn't we?  If the clocks need to interface to other things (and they
> > > do) then we should be able to use the standard interface we have to
> > > clocks.
> 
> > Excuse me, I think I just don't get the approach how to use clock API to
> > standardize the MCLK derived from ESAI IP: it's surely not a fixed-clock
> > so we couldn't register in DT and it's not SoC internal clock which means
> > we couldn't register it in the SoC clock driver either.
> 
> > Could you please shed me some light on it?
> 
> So register it from the ESAI driver then.

Then I think I need to find a way to pass the clock to CODEC driver...

Anyway, I'll try it first. Thank you.


