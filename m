Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3H1Hty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:49:54 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45618 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3H1Htx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:49:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lee Jones <lee.jones@linaro.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
Date: Wed, 28 Aug 2013 09:51:15 +0200
Message-ID: <81053150.gZpPo7ioCr@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130828074126.GD10210@lee--X1>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com> <4590364.P8qlcBVRgM@avalon> <20130828074126.GD10210@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

(Dropping Ian Molton <ian.molton@collabora.co.uk> from the CC list as the e-
mail address isn't valid anymore)

On Wednesday 28 August 2013 08:41:26 Lee Jones wrote:
> > > Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
> > > platform data", .set_pwr() callback is removed from platform data.
> > > Thus, .set_pwr() is not used anymore. Also, this patch fixes
> > > the following build error and warning.
> > > 
> > > drivers/mfd/asic3.c:724:2: error: unknown field 'set_pwr' specified in
> > > initializer drivers/mfd/asic3.c:724:2: warning: initialization makes
> > > integer from pointer without a cast [enabled by default]
> > > drivers/mfd/asic3.c:724:2: warning: (near initialization for
> > > 'asic3_mmc_data.capabilities' [enabled by default]
> > 
> > My bad, it looks like I've overlooked a few users of the .set_pwr() field
> > :-/ Sorry about that.
> 
> <snip>
> 
> > I don't think blindly removing the function is the right fix, as it seems
> > to be needed. Looking at the whole series, I believe we should just
> > revert 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from platform
> > data" instead.
> 
> No need to revert it, as it's not in Mainline yet. Just request for it
> to be removed from Chris' tree.

I spupose it depends on whether Chris has provided a stable branch with the 
patch included. I'm fine with both, the commit just needs to be undone one way 
or another.

-- 
Regards,

Laurent Pinchart

