Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaJXHyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:54:41 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48035 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaJXHyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:54:36 -0400
Date: Fri, 24 Oct 2014 16:54:23 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
Message-ID: <20141024075423.GA3239@jack-ThinkPad-T520>
References: <20141014011112.GB2751@jack-ThinkPad-T520>
 <20141014075606.GN27755@sirena.org.uk>
 <20141017091950.GA3233@jack-ThinkPad-T520>
 <20141017101734.GB1820@sirena.org.uk>
 <20141017104309.GA3136@jack-ThinkPad-T520>
 <20141017142605.GU1820@sirena.org.uk>
 <20141020061024.GA9406@jack-ThinkPad-T520>
 <20141022102723.GL2344@sirena.org.uk>
 <20141023031443.GA3244@jack-ThinkPad-T520>
 <20141023130103.GC3729@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141023130103.GC3729@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 02:01:03PM +0100, Mark Brown wrote:
> On Thu, Oct 23, 2014 at 12:14:43PM +0900, Gyungoh Yoo wrote:
> 
> > So, what do you think about DT like below?
> 
> > sky81452@2c {
> > 	compatible = "skyworks,sky81452";
> > 	reg = <0x2c>;
> > 
> > 	backlight {
> > 		compatible = "skyworks,sky81452-backlight";
> > 		name = "pwm-backlight";
> > 		enable = <0x3F>;
> > 		ignore-pwm;
> > 	};
> > 
> > 	regulator {
> > 		compatible = "skyworks,sky81452-regulator";
> 
> Yes, this is good but I still feel that the above compatible is
> redundant and shouildn't be there.

I see. I will remove compatible string at the next resubmit.

> 
> > 		lout@0 {
> > 			regulator-name = "LOUT";
> > 			regulator-min-microvolt = <4500000>;
> > 			regulator-max-microvolt = <8000000>;
> > 		};
> > 	};
> > };


