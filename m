Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaK1W2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:28:44 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:56600 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1W2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:28:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v3 0/3] drm: describe display bus format
Date: Sat, 29 Nov 2014 00:29:10 +0200
Message-ID: <7292023.aOo0xYF6kL@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141127143750.3984ddd0@bbrezillon>
References: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com> <20141127143750.3984ddd0@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Thursday 27 November 2014 14:37:50 Boris Brezillon wrote:
> On Tue, 18 Nov 2014 14:46:17 +0100 Boris Brezillon wrote:
> > Hello,
> > 
> > This series makes use of the MEDIA_BUS_FMT definition to describe how
> > the data are transmitted to the display.
> > 
> > This will allow drivers to configure their output display bus according
> > to the display capabilities.
> > For example some display controllers support DPI (or raw RGB) connectors
> > and need to specify which format will be transmitted on the DPI bus
> > (RGB444, RGB565, RGB888, ...).
> > 
> > This series also adds a field to the panel_desc struct so that one
> > can specify which format is natevely supported by a panel.
> 
> Thierry, Laurent, Dave, can you take a look at this patch series: this
> is the last missing dependency to get the atmel-hlcdc DRM driver
> mainlined, and I was expecting to get this driver in 3.19...

I've reviewed the series, it looks globally fine to me. I just had two small 
comments on patch 1/3.

-- 
Regards,

Laurent Pinchart

