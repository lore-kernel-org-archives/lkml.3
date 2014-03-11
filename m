Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaCKPlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:41:47 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:21399
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbaCKPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:41:45 -0400
X-Forefront-Antispam-Report: CIP:141.131.128.20;KIP:(null);UIP:(null);IPV:NLI;H:mail2.cirrus.com;RD:mail2.cirrus.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh7bh2a8h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h1155h)
Date: Tue, 11 Mar 2014 10:41:32 -0500
From: Brian Austin <brian.austin@cirrus.com>
X-X-Sender: heelrod@heelrod
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: <broonie@kernel.org>, <brian.austin@cirrus.com>,
        <Paul.Handrigan@cirrus.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <lars@metafoo.de>
Subject: Re: [PATCH v2] ASoC: cs42888: Add codec driver support
In-Reply-To: <1394536791-8381-1-git-send-email-Guangyu.Chen@freescale.com>
Message-ID: <alpine.DEB.2.02.1403111026280.3558@heelrod>
References: <1394536791-8381-1-git-send-email-Guangyu.Chen@freescale.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
X-OriginatorOrg: cirrus.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Mar 2014, Nicolin Chen wrote:

> This patch adds support for the Cirrus Logic CS42888 Audio CODEC that
> has four 24-bit A/D and eight 24-bit D/A converters.
>
> [ CS42888 supports both I2C and SPI control ports. As initial patch,
>  this patch only adds the support for I2C. ]
>
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---
So WRT the CS42888, this is one device in a series of 2 devices that are 
register compatible with the only difference being that the CS42488 has 2 
extra ADC's. Same die and same DeviceID.

Would it make more sense to submit the driver with the extra ADC's to make 
it feature complete for both devices? Wouldn't be odd to have 2 drivers 
that do the same for 98% of the code.

Thoughts?
Brian

