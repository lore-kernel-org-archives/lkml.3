Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaKPITY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 03:19:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42408 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753101AbaKPITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 03:19:22 -0500
Date: Sun, 16 Nov 2014 09:19:18 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [media] Add RGB444_1X12 and RGB565_1X16 media bus
 formats
Message-ID: <20141116091918.56b859e8@bbrezillon>
In-Reply-To: <546767FD.2080706@iki.fi>
References: <1415961360-14898-1-git-send-email-boris.brezillon@free-electrons.com>
	<20141114135831.GC8907@valkosipuli.retiisi.org.uk>
	<20141114160446.70c1b8b9@bbrezillon>
	<546767FD.2080706@iki.fi>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2014 16:49:33 +0200
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> Hi Boris,
> 
> Boris Brezillon wrote:
> > Hi Sakari,
> > 
> > On Fri, 14 Nov 2014 15:58:31 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > 
> >> Hi Boris,
> >>
> >> On Fri, Nov 14, 2014 at 11:36:00AM +0100, Boris Brezillon wrote:
> ...
> >>> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> >>> index 23b4090..cc7b79e 100644
> >>> --- a/include/uapi/linux/media-bus-format.h
> >>> +++ b/include/uapi/linux/media-bus-format.h
> >>> @@ -33,7 +33,7 @@
> >>>  
> >>>  #define MEDIA_BUS_FMT_FIXED			0x0001
> >>>  
> >>> -/* RGB - next is	0x100e */
> >>> +/* RGB - next is	0x1010 */
> >>>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
> >>>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
> >>>  #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE	0x1003
> >>> @@ -47,6 +47,8 @@
> >>>  #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
> >>>  #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
> >>>  #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
> >>> +#define MEDIA_BUS_FMT_RGB444_1X12		0x100e
> >>> +#define MEDIA_BUS_FMT_RGB565_1X16		0x100f
> >>
> >> I'd arrange these according to BPP and bits per sample, both in the header
> >> and documentation.
> > 
> > I cannot keep both macro values and BPP/bits per sample in incrementing
> > order. Are you sure you prefer to order macros in BPP/bits per sample
> > order ?
> 
> If you take a look elsewhere in the header, you'll notice that the
> ordering has preferred the BPP value (and other values with semantic
> significance) over the numeric value of the definition. I'd just prefer
> to keep it that way. This is also why the "next is" comments are there.
> 

My bad, I only had a look at RGB formats.
I'll fix that.

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
