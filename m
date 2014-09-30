Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaI3Joa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:44:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53728 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbaI3Jo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:44:28 -0400
Date: Tue, 30 Sep 2014 11:44:23 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more
 standard place
Message-ID: <20140930114423.3a171aa9@bbrezillon>
In-Reply-To: <20140930083952.GA4059@ulmo>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
	<3849580.CgKEmcV7as@avalon>
	<20140930093757.003741ac@bbrezillon>
	<20140930083952.GA4059@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014 10:39:53 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Tue, Sep 30, 2014 at 09:37:57AM +0200, Boris Brezillon wrote:
> > On Mon, 29 Sep 2014 23:41:09 +0300
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> [...]
> > > Incidentally, patch 2/5 in this series is missing a documentation update ;-)
> > 
> > Yep, regarding this patch, I wonder if it's really necessary to add
> > new formats to the v4l2_mbus_pixelcode enum.
> > If we want to move to this new common definition (across the video
> > related subsytems), we should deprecate the old enum
> > v4l2_mbus_pixelcode, and this start by not adding new formats, don't
> > you think ?
> 
> I agree in general, but I think it could prove problematic in practice.
> If somebody wants to use one of the new codes but is using the V4L2 enum
> they have a problem.
> 
> That said, given that there is now a unified enum people will hopefully
> start converting drivers to it instead.

I'm more worried about user-space lib/programs as this header is part
of the uapi...

But let's be optimistic here and keep porting new formats to
v4l2_mbus_pixelcode enum ;-).

Anyway, I still don't know where to put the documentation. Dropping a
new video format doc without any context (I mean subdev-formats.xml is
included in media documentation, but there's no generic video doc yet)
is a bit weird...

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
