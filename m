Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3KRPG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:06:58 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53335 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab3KRPGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:06:50 -0500
Date: Mon, 18 Nov 2013 15:06:19 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Florian Meier <florian.meier@koalo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3] ASoC: Add support for BCM2835
Message-ID: <20131118150619.GL30853@e106331-lin.cambridge.arm.com>
References: <5289F9DF.8060406@koalo.de>
 <20131118141637.GI30853@e106331-lin.cambridge.arm.com>
 <528A232B.9070402@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A232B.9070402@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 02:24:43PM +0000, Lars-Peter Clausen wrote:
> On 11/18/2013 03:16 PM, Mark Rutland wrote:
> > 
> >> +static void bcm2835_i2s_stop_clock(struct bcm2835_i2s_dev *dev)
> >> +{
> >> +       uint32_t clkreg;
> > 
> > s/uint32_t/u32/ (and elsewhere...)
> 
> Please don't do that.
> 

I was under the impression that there was a preference for uXX types
over uintXX_t types, but the replies and Documentation/CodingStyle have
taught me otherwise.

Apologies for the confusion here.

Thanks,
Mark.
