Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3H1Hlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:41:35 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49811 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3H1Hle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:41:34 -0400
Date: Wed, 28 Aug 2013 08:41:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: [PATCH 1/5] mfd: asic3: Remove .set_pwr() callback
Message-ID: <20130828074126.GD10210@lee--X1>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
 <4590364.P8qlcBVRgM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4590364.P8qlcBVRgM@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
> > platform data", .set_pwr() callback is removed from platform data.
> > Thus, .set_pwr() is not used anymore. Also, this patch fixes
> > the following build error and warning.
> > 
> > drivers/mfd/asic3.c:724:2: error: unknown field 'set_pwr' specified in
> > initializer drivers/mfd/asic3.c:724:2: warning: initialization makes
> > integer from pointer without a cast [enabled by default]
> > drivers/mfd/asic3.c:724:2: warning: (near initialization for
> > 'asic3_mmc_data.capabilities' [enabled by default]
> 
> My bad, it looks like I've overlooked a few users of the .set_pwr() field :-/ 
> Sorry about that.

<snip>

> I don't think blindly removing the function is the right fix, as it seems to 
> be needed. Looking at the whole series, I believe we should just revert 
> 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from platform data" 
> instead.

No need to revert it, as it's not in Mainline yet. Just request for it
to be removed from Chris' tree.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
