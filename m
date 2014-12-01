Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaLANGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:06:32 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52145 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753355AbaLANGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:06:30 -0500
Date: Mon, 1 Dec 2014 14:06:27 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH RESEND v4 1/3] drm: add bus_formats and num_bus_formats
 fields to drm_display_info
Message-ID: <20141201140627.4c715bba@bbrezillon>
In-Reply-To: <10659671.3WzjQ3SUBa@avalon>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
	<1417423335-11408-1-git-send-email-boris.brezillon@free-electrons.com>
	<10659671.3WzjQ3SUBa@avalon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Mon, 01 Dec 2014 15:00:15 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Boris,
> 
> Thank you for the patch.
> 
> On Monday 01 December 2014 09:42:15 Boris Brezillon wrote:
> > Add bus_formats and num_bus_formats fields and
> > drm_display_info_set_bus_formats helper function to specify the bus
> > formats supported by a given display.
> > 
> > This information can be used by display controller drivers to configure
> > the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> > RGB or LVDS busses).
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > ---
> > Hi,
> > 
> > Sorry for the noise: I ran checkpatch after sending the series and it found
> > a typo and two "line over 80 characters" warnings.
> > 
> > This version fixes those warnings.
> 
> Please remember to increment the version number next time, it gets confusing 
> otherwise when people start asking questions such as "which v4 ?".

Okay. I wasn't sure, and eventually decided to just prefix the version
with RESEND because these were only cosmetic changes, and I fixed them
right after sending the v4.

I'll know for next time ;-).

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
