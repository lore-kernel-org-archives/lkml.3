Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaKDOgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:36:14 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50698 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaKDOgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:36:09 -0500
Date: Tue, 4 Nov 2014 14:35:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, gyungoh@gmail.com, sameo@linux.intel.com,
        jg1.han@samsung.com, cooloney@gmail.com, lgirdwood@gmail.com,
        jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v6 1/8] mfd: Add support for Skyworks SKY81452
 driver
Message-ID: <20141104143559.GQ17577@x1>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-2-git-send-email-jack.yoo@skyworksinc.com>
 <20141103171451.GG12011@x1>
 <1415050088.20372.72.camel@x220>
 <20141103223022.GE13359@x1>
 <1415091946.20372.136.camel@x220>
 <20141104091609.GI17577@x1>
 <20141104113833.GI3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141104113833.GI3815@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014, Mark Brown wrote:

> On Tue, Nov 04, 2014 at 09:16:09AM +0000, Lee Jones wrote:
> > On Tue, 04 Nov 2014, Paul Bolle wrote:
> 
> > > Nothing will break. But I think Mark prefers the dependency rename, now
> > > done in 7/8, to be done as part of this patch.
> 
> > I don't agree.  The rename should be taken independantly by Mark.
> > The regulator driver won't build until they match anyway, so there's
> > no hard dependency.  Unless someone can give me a really good reason
> > to revert it, I'm applying this driver now.
> 
> The important thing is that the dependency rename isn't silently thrown
> into an unrelated patch.

That I agree with.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
