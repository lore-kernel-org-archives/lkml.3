Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaK0Nh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:37:56 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60642 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750781AbaK0Nhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:37:54 -0500
Date: Thu, 27 Nov 2014 14:37:50 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v3 0/3] drm: describe display bus format
Message-ID: <20141127143750.3984ddd0@bbrezillon>
In-Reply-To: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 18 Nov 2014 14:46:17 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This series makes use of the MEDIA_BUS_FMT definition to describe how
> the data are transmitted to the display.
> 
> This will allow drivers to configure their output display bus according
> to the display capabilities.
> For example some display controllers support DPI (or raw RGB) connectors
> and need to specify which format will be transmitted on the DPI bus
> (RGB444, RGB565, RGB888, ...).
> 
> This series also adds a field to the panel_desc struct so that one
> can specify which format is natevely supported by a panel.

Thierry, Laurent, Dave, can you take a look at this patch series: this
is the last missing dependency to get the atmel-hlcdc DRM driver
mainlined, and I was expecting to get this driver in 3.19...

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
