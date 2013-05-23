Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3EWJfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:35:55 -0400
Received: from ams-iport-3.cisco.com ([144.254.224.146]:23169 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3EWJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:35:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,727,1363132800"; 
   d="scan'208";a="13657759"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 3/5] media: i2c: tvp7002: rearrange header inclusion alphabetically
Date: Thu, 23 May 2013 11:35:37 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-2.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1368528334-13595-1-git-send-email-prabhakar.csengg@gmail.com> <1368528334-13595-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368528334-13595-4-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231135.37204.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14 May 2013 12:45:32 Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch rearranges the header inclusion alphabetically
> and also removes unnecessary includes.

As Laurent mentioned in a review for another patch (vpif) you probably
shouldn't remove these headers. videodev2.h is certainly used, as is slab.h
and v4l2-common.h. In the past removing slab.h causes problems on other
architectures where that header isn't automatically included by other
headers.

I would just drop this patch. I've merged the first two patches of
this patch series, the last two I can't merge as long as the async
code isn't in yet.

Regards,

	Hans

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> ---
>  drivers/media/i2c/tvp7002.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index f339e6f..f4114bf 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -24,17 +24,17 @@
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
> +
>  #include <linux/delay.h>
>  #include <linux/i2c.h>
> -#include <linux/slab.h>
> -#include <linux/videodev2.h>
>  #include <linux/module.h>
>  #include <linux/v4l2-dv-timings.h>
> +
>  #include <media/tvp7002.h>
> -#include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
> -#include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
>  #include "tvp7002_reg.h"
>  
>  MODULE_DESCRIPTION("TI TVP7002 Video and Graphics Digitizer driver");
> 
