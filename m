Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaKQMyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:54:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38271 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbaKQMyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:54:39 -0500
Date: Mon, 17 Nov 2014 12:54:33 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, broonie@kernel.org,
        linus.walleij@linaro.org, gnurou@gmail.com,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: arizona: Add support for CS47L24
Message-ID: <20141117125433.GA29518@opensource.wolfsonmicro.com>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com> <20141111171532.GA26106@opensource.wolfsonmicro.com> <20141113101228.GE24004@x1> <20141113164017.GA12443@opensource.wolfsonmicro.com> <20141117121648.GP24004@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141117121648.GP24004@x1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:16:48PM +0000, Lee Jones wrote:
> On Thu, 13 Nov 2014, Charles Keepax wrote:
> 
> > On Thu, Nov 13, 2014 at 10:12:28AM +0000, Lee Jones wrote:
> > > On Tue, 11 Nov 2014, Richard Fitzgerald wrote:
> > > 
> > > > Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> > > > ---
> > > >  drivers/mfd/Kconfig              |    6 +
> > > >  drivers/mfd/Makefile             |    3 +
> > > >  drivers/mfd/arizona-core.c       |   91 ++-
> > > >  drivers/mfd/arizona-irq.c        |   42 +-
> > > >  drivers/mfd/arizona-spi.c        |    9 +
> > > >  drivers/mfd/arizona.h            |    5 +
> > > >  drivers/mfd/cs47l24-tables.c     | 1632 ++++++++++++++++++++++++++++++++++++++
> > > 
> > > No chance.
> > > 
> > > Please resend with these in a header file (like all of the others).
> > > 
> > > I'd also like Charles' Reviewed-by before accepting.
> > 
> > This looks good to me. I don't quite follow what you are
> > requesting with the header file? This still uses the header file
> > for the registers but just defining which are available on this
> > chip.
> 
> Looks like I was a little hasty with my comments.  However 8000 lines
> over 4 platforms just to describe which registers are readable is all
> a little bit grim.  Is there any way you can use ranges instead of
> listing every single register on the chip?  How many gaps are there? 
> 

It's debatable. Ranges would be possible but there are a lot of gaps.
Personally, speaking as someone who has to maintain these drivers, I
like that fact that I can look at this file and see exactly which registers
are readable and volatile because they are all explicitly listed. It's also
useful that the files are searchable for specific registers.

I'll point Charles at this to get his opinion.

> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
