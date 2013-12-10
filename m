Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3LJSmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:42:25 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:40322 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3LJSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:42:22 -0500
Date: Tue, 10 Dec 2013 18:42:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/15] mfd: menelaus: Pass menelaus_chip pointer to
 add/remove irq functions
Message-ID: <20131210184216.GD2390@lee--X1>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-8-git-send-email-balbi@ti.com>
 <20131210090021.GQ12675@lee--X1>
 <20131210163249.GF22750@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131210163249.GF22750@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Felipe Balbi wrote:

> On Tue, Dec 10, 2013 at 09:00:21AM +0000, Lee Jones wrote:
> > On Mon, 09 Dec 2013, Felipe Balbi wrote:
> > 
> > > Those functions are static and can receive a menelaus_chip pointer very
> > > easily.
> > > 
> > > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >  drivers/mfd/menelaus.c | 57 ++++++++++++++++++++++++++------------------------
> > >  1 file changed, 30 insertions(+), 27 deletions(-)
> > 
> > Same here. I think this should be done in one fell swoop.
> 
> then it would become a much, much larger patch which would become a pain
> to review.

If the patch was doing lots of different things then I'd be inclined
to agree, but although large, the changes here are pretty trivial.

I tend to break up patches based on; subsystem, file, device (for
platform/dts adaptions) and functionality. Rather than just because
the 'lines changed' count is large.

Please squash them and I'll review it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
