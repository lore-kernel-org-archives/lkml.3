Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab3EZAtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:49:53 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59177 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593Ab3EZAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:49:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] media: davinci: vpif: remove unwanted header mach/hardware.h and sort the includes alphabetically
Date: Sun, 26 May 2013 02:49:37 +0200
Message-ID: <97825926.dhHpFOhUhr@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369499796-18762-2-git-send-email-prabhakar.csengg@gmail.com>
References: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com> <1369499796-18762-2-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Saturday 25 May 2013 22:06:32 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch removes unwanted header include of mach/hardware.h
> and along side sorts the header inclusion alphabetically.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/davinci/vpif.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif.c
> b/drivers/media/platform/davinci/vpif.c index ea82a8b..761c825 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -17,18 +17,16 @@
>   * GNU General Public License for more details.
>   */
> 
> +#include <linux/err.h>
>  #include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> -#include <linux/spinlock.h>
> -#include <linux/kernel.h>
> -#include <linux/io.h>
> -#include <linux/err.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/spinlock.h>
>  #include <linux/v4l2-dv-timings.h>
> 
> -#include <mach/hardware.h>
> -
>  #include "vpif.h"
> 
>  MODULE_DESCRIPTION("TI DaVinci Video Port Interface driver");
-- 
Regards,

Laurent Pinchart

