Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3FAPaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 11:30:30 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:49766 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3FAPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 11:30:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH 13/15] [media] omap3isp: include linux/mm_types.h
Date: Sat, 01 Jun 2013 17:30:17 +0200
Message-ID: <3507557.BiLMFItQuE@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1370038972-2318779-14-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-14-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thank you for the patch.

On Saturday 01 June 2013 00:22:50 Arnd Bergmann wrote:
> The ispqueue.h file uses vm_flags_t, which is defined in
> linux/mm_types.h, so we must include that header in order
> to build in all configurations.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(with a minor nitpick below)

> ---
>  drivers/media/platform/omap3isp/ispqueue.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/omap3isp/ispqueue.h
> b/drivers/media/platform/omap3isp/ispqueue.h index 908dfd7..e6e720c 100644
> --- a/drivers/media/platform/omap3isp/ispqueue.h
> +++ b/drivers/media/platform/omap3isp/ispqueue.h
> @@ -31,6 +31,7 @@
>  #include <linux/mutex.h>
>  #include <linux/videodev2.h>
>  #include <linux/wait.h>
> +#include <linux/mm_types.h>

Could you please make sure the headers are sorted alphabetically ?

Would you like me to take the patch in my tree ? If so I'll sort the headers 
myself.

>  struct isp_video_queue;
>  struct page;

-- 
Regards,

Laurent Pinchart

