Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaKHAi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:38:58 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34394 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752699AbaKHAiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:38:55 -0500
Date: Sat, 8 Nov 2014 01:38:41 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Message-ID: <20141108013841.1f3f1bc2@bbrezillon>
In-Reply-To: <545D4BFD.6000206@iki.fi>
References: <545CDB8D.4080406@xs4all.nl>
	<1415377630-16564-1-git-send-email-boris.brezillon@free-electrons.com>
	<545D4BFD.6000206@iki.fi>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Nov 2014 00:47:25 +0200
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> Hi Boris,
> 
> Boris Brezillon wrote:
> > @@ -102,6 +113,7 @@ enum v4l2_mbus_pixelcode {
> >  
> >  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
> >  };
> > +#endif /* __KERNEL__ */
> >  
> >  /**
> >   * struct v4l2_mbus_framefmt - frame format on the media bus
> 
> Was it intended to be this way, or did I miss something? I'd put this to
> beginning of the file, as Hans suggested.

Oops, I forgot to move the struct.

> 
> With this matter sorted out, for the set:
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
