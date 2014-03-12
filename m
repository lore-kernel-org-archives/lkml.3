Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbaCLCC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:02:27 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:54264 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888AbaCLCCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:02:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 09:54:19 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>, Brian Austin <brian.austin@cirrus.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, <Paul.Handrigan@cirrus.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: Re: [PATCH v2] ASoC: cs42888: Add codec driver support
Message-ID: <20140312015418.GB1177@MrMyself>
References: <1394536791-8381-1-git-send-email-Guangyu.Chen@freescale.com>
 <alpine.DEB.2.02.1403111026280.3558@heelrod>
 <531F320E.70605@metafoo.de>
 <20140311184606.GW28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140311184606.GW28112@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 06:46:06PM +0000, Mark Brown wrote:
> On Tue, Mar 11, 2014 at 04:55:58PM +0100, Lars-Peter Clausen wrote:
> > On 03/11/2014 04:41 PM, Brian Austin wrote:
> 
> > >So WRT the CS42888, this is one device in a series of 2 devices that are
> > >register compatible with the only difference being that the CS42488 has 2
> > >extra ADC's. Same die and same DeviceID.
> 
> > >Would it make more sense to submit the driver with the extra ADC's to make
> > >it feature complete for both devices? Wouldn't be odd to have 2 drivers that
> > >do the same for 98% of the code.
> 
> > This should be in one driver. But support for the second device can
> > always be added in a follow up patch.
> 
> Yes, we can add support later.  It might be helpful to name the driver
> with some generic name I guess.

I didn't notice there's a sister model for CS42888. But good to know.

And I think I should try cs42x88.c as the driver name, which makes sense
even if we have another sister here. Or Brian may give me a more official
one?

It would be better if I also put those CS42488's support into the driver
but I'll start a long vacation from tomorrow. So if I am not able to do
that for CS42488's parts in the short time, I'll send the CS42888 part
first by the end of the day and we can add CS42488 later.

Thanks all,
Nicolin Chen


