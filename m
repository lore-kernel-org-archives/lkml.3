Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3J0Ntk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:49:40 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60284 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3J0Nth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:49:37 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH V5 REPOST] mfd: add support for ams AS3722 PMIC
To: Lee Jones <lee.jones@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        broonie@kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        Florian Lobmaier <florian.lobmaier@ams.com>
In-Reply-To: <20131026161902.GA7698@lee--X1>
References: <1382427526-2390-1-git-send-email-ldewangan@nvidia.com> <20131025200754.D222AC4058E@trevor.secretlab.ca> <20131026161902.GA7698@lee--X1>
Date: Sun, 27 Oct 2013 13:49:28 +0000
Message-Id: <20131027134928.13BE4C4039D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013 09:19:02 -0700, Lee Jones <lee.jones@linaro.org> wrote:
> Hi Grant,
> 
> > > Acked-by: Stephen Warren <swarren@nvidia.com>
> > > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > > Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> <snip>
> 
> > > +    Optional properties:
> > > +    -------------------
> > > +	The input supply of regulators are the optional properties on the
> > > +	regulator node. The input supply of these regulators are provided
> > > +	through following properties:
> > > +		vsup-sd2-supply: Input supply for SD2.
> > > +		vsup-sd3-supply: Input supply for SD3.
> > > +		vsup-sd4-supply: Input supply for SD4.
> > > +		vsup-sd5-supply: Input supply for SD5.
> > > +		vin-ldo0-supply: Input supply for LDO0.
> > > +		vin-ldo1-6-supply: Input supply for LDO1 and LDO6.
> > > +		vin-ldo2-5-7-supply: Input supply for LDO2, LDO5 and LDO7.
> > > +		vin-ldo3-4-supply: Input supply for LDO3 and LDO4.
> > > +		vin-ldo9-10-supply: Input supply for LDO9 and LDO10.
> > > +		vin-ldo11-supply: Input supply for LDO11.
> > 
> > What is the data in these properties? The documentation isn't clear.
> > 
> > In principle, the binding looks okay to me.
> 
> The properties to which you refer are standard regulator supply
> bindings specified here [1]. Specifically:
> 
>   "<name>-supply: phandle to the parent supply/regulator node"
> 
> The DT portion has already been Acked by Stephen and applied by me.
> 
> [1] Documentation/devicetree/bindings/regulator/regulator.txt

Okay, thanks. I was being too lazy to go digging.  :-)

g.

