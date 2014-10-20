Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaJTGKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:10:41 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46706 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaJTGKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:10:37 -0400
Date: Mon, 20 Oct 2014 15:10:24 +0900
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
Message-ID: <20141020061024.GA9406@jack-ThinkPad-T520>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141013103512.GJ27755@sirena.org.uk>
 <20141014011112.GB2751@jack-ThinkPad-T520>
 <20141014075606.GN27755@sirena.org.uk>
 <20141017091950.GA3233@jack-ThinkPad-T520>
 <20141017101734.GB1820@sirena.org.uk>
 <20141017104309.GA3136@jack-ThinkPad-T520>
 <20141017142605.GU1820@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141017142605.GU1820@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 04:26:05PM +0200, Mark Brown wrote:
> On Fri, Oct 17, 2014 at 07:43:09PM +0900, Gyungoh Yoo wrote:
> 
> > Are you talking about simplification using of_regulator_match()?
> > This driver has only one regulator.
> > Is the API also useful for this driver?
> 
> The thing I'm seeing is that the binding for your device with the
> subnode looks very much like the device trees of devices with multiple
> regulators.  The fact that you only have one regulator is a bit
> difference but not that much.  It seems like drivers should fit into one
> of two patterns: either the regulator is described in the root node for
> the device for single purpose devices or there should be a collection of
> regulators like is supported with this helper API.  Having a collection
> with only one node doesn't seem to be a problem in any way.
> 
> > Like reg-fixed-voltage, how about using of_get_fixed_voltage_config()?
> 
> The driver doesn't seem to need any property parsing of its own so it
> shoudn't need anything beyond basic calls into the core.

Thank you for your kind comments.
My understanding is getting better.

For my clear understanding:
I think the original designed which I wanted to design is similar
with arizona-ldo1.c
It seems that this is 1st pattern your explained above.
Can I ask what is different between arizona-ldo1.c and
this sky81452-regulator.c?
I think both are designed under root node.

Thank you.

