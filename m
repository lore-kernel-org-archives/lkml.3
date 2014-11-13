Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbaKMQYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:24:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932245AbaKMQYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:24:31 -0500
Date: Thu, 13 Nov 2014 16:24:24 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, linus.walleij@linaro.org, gnurou@gmail.com,
        alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        ckeepax@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] mfd: arizona: Add support for CS47L24
Message-ID: <20141113162424.GA17501@opensource.wolfsonmicro.com>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com> <20141111171532.GA26106@opensource.wolfsonmicro.com> <20141113101228.GE24004@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113101228.GE24004@x1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:12:28AM +0000, Lee Jones wrote:
> On Tue, 11 Nov 2014, Richard Fitzgerald wrote:
> 
> > Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/Kconfig              |    6 +
> >  drivers/mfd/Makefile             |    3 +
> >  drivers/mfd/arizona-core.c       |   91 ++-
> >  drivers/mfd/arizona-irq.c        |   42 +-
> >  drivers/mfd/arizona-spi.c        |    9 +
> >  drivers/mfd/arizona.h            |    5 +
> >  drivers/mfd/cs47l24-tables.c     | 1632 ++++++++++++++++++++++++++++++++++++++
> 
> No chance.
> 
> Please resend with these in a header file (like all of the others).
> 

Care to expand on what exactly you want moved to a header file?
If you're referring to cs47l24-tables.c, that's all data tables and
functions, I don't see anything that makes sense to move to a header.
Compare with the related codecs wm5110-tables.c, wm5102-tables.c,
wm8997-tables.c

