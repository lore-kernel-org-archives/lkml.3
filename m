Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3HVIm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:42:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42400 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3HVIm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:42:26 -0400
Date: Thu, 22 Aug 2013 09:42:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] drm/i2c: tda998x: prepare for video input
	configuration
Message-ID: <20130822084205.GE6617@n2100.arm.linux.org.uk>
References: <20130821202646.47af66a5@armhf> <20130821223605.GA6617@n2100.arm.linux.org.uk> <20130822085313.2e8b1ae6@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822085313.2e8b1ae6@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 08:53:13AM +0200, Jean-Francois Moine wrote:
> On Wed, 21 Aug 2013 23:36:05 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > > AFAIK, the TI boards have no "pin-swapped", nor has the Cubox (there is
> > > no need to set the bit CFG_GRA_SWAPRB of the register LCD_SPU_DMA_CTRL0
> > > of the Dove lcd for RGB or YUV formats).
> > > 
> > > Which board needs a special VIP configuration?  
> > 
> > If you run the NXP driver, and then run this driver, things get messed
> > up - which has already been covered months ago when this patch was first
> > brought up.
> > 
> > It's there to ensure that the TDA998x is correctly configured no matter
> > what it's previous state is, and prevent the thing being fragile as hell.
> 
> The NXP driver will never go to the mainline, so, I don't see the
> problem. If you want to use it to test some other drivers, you should
> better patch it instead of adding useless code in the TDA998x driver.

Sorry, you're wrong.
