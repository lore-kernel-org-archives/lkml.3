Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3CYKwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:52:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56783 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3CYKwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:52:22 -0400
Date: Mon, 25 Mar 2013 11:52:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 3/3] backlight: as3711: add OF support
In-Reply-To: <20130325101442.GJ18316@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1303251151430.11549@axis700.grange>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
 <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
 <00da01ce2917$54856ce0$fd9046a0$%han@samsung.com>
 <20130325101442.GJ18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:k6UCtzae2GS8cuuil2IFw8byLdgfSNRckBatUlUt7Lt
 fdK3/2fG0odvHkGHY/q80rNjB6CbPDTL7hvPKDq2XYteMkpM0D
 PnGalVrZYk/IbmnMyXEEpN2tyjAdKJYBs7AfAKE7JmGvGIL7bj
 07XNsG/YsZ5dWQfGv1Y/oZzUun3Run0YVeX4s8izYr8QA23mLL
 6x7uRAAnPtLAS6tSlApG42Tdti+G0FpqM6BG/V54XH/g88DBt3
 ZVocV6ef+saezoM9Nbn5pPHI9VBzlaMPZooBG113gZqlrDfmTK
 Mu7mXLLypZPMP1ONM8MI3Yfe/VdJ1TPJa3AWp9VFMm08g0Z9lZ
 fWOyKvuoGoiOBZcf1rZapKEMQCwf/yjccE/mBdAXv1yrDvSp1J
 rcQJyjxdkhafw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Mark Brown wrote:

> On Mon, Mar 25, 2013 at 02:12:21PM +0900, Jingoo Han wrote:
> > On Saturday, March 23, 2013 1:16 AM, Guennadi Liakhovetski wrote:
> 
> > But, there is a typo in comment.
> > > +		 * At least one su2-auto-curr* must be specified iff
> > s/iff/if
> 
> Are you sure that's a typo?  "Iff" is a bit of mathematical jargon
> which means "if and only if" that's fairly often used in a computing
> context.

Thanks, Mark, that's exactly what I was trying to say there :)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
