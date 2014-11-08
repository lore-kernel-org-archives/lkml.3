Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaKHJT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:19:27 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47427 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaKHJTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:19:24 -0500
MIME-Version: 1.0
In-Reply-To: <1415369269-5064-7-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415369269-5064-7-git-send-email-boris.brezillon@free-electrons.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 8 Nov 2014 09:18:51 +0000
Message-ID: <CA+V-a8t79gYYGcgg5wvM-eqW8H2D6WD7xM9t2Px=WHb2rf34ow@mail.gmail.com>
Subject: Re: [PATCH v3 06/10] [media] platform: Make use of media_bus_format enum
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-api <linux-api@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>, LDOC <linux-doc@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch,

On Fri, Nov 7, 2014 at 2:07 PM, Boris Brezillon
<boris.brezillon@free-electrons.com> wrote:
> In order to have subsytem agnostic media bus format definitions we've
> moved media bus definition to include/uapi/linux/media-bus-format.h and
> prefixed values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.
>
> Reference new definitions in all platform drivers.
>
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
>  arch/arm/mach-davinci/board-dm365-evm.c            |   4 +-
>  arch/arm/mach-davinci/dm355.c                      |   7 +-
>  arch/arm/mach-davinci/dm365.c                      |   7 +-

@Sekhar can you ack for the machine changes for davinci ?

[Snip]
>  drivers/media/platform/davinci/vpbe.c              |   2 +-
>  drivers/media/platform/davinci/vpfe_capture.c      |   4 +-
[snip]
>  include/media/davinci/vpbe.h                       |   2 +-
>  include/media/davinci/vpbe_venc.h                  |   5 +-

For all the above.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad
