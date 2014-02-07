Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaBGRWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:22:32 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37552 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBGRWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:22:31 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 7 Feb 2014 09:22:21 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] sound: Include appropriate header file in
 pcsp/pcsp_input.c
Message-ID: <20140207172221.GB7298@jtriplet-mobl1>
References: <512472c7d96cf1c239ba3d0bc517891a7c2f9da1.1391791103.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512472c7d96cf1c239ba3d0bc517891a7c2f9da1.1391791103.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:11:53PM +0530, Rashika Kheria wrote:
> Include appropriate header file in drivers/pcsp/pcsp_input.c because it
> defines function whose prototype definitions are present in
> drivers/pcsp/pcsp_input.h.
> 
> This eliminates the following warning in drivers/pcsp/pcsp_input.c:
> sound/drivers/pcsp/pcsp_input.c:42:6: warning: no previous prototype for ‘pcspkr_stop_sound’ [-Wmissing-prototypes]
> sound/drivers/pcsp/pcsp_input.c:80:5: warning: no previous prototype for ‘pcspkr_input_init’ [-Wmissing-prototypes]
> sound/drivers/pcsp/pcsp_input.c:110:5: warning: no previous prototype for ‘pcspkr_input_remove’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  sound/drivers/pcsp/pcsp_input.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/sound/drivers/pcsp/pcsp_input.c b/sound/drivers/pcsp/pcsp_input.c
> index b874b0a..0ecf8a4 100644
> --- a/sound/drivers/pcsp/pcsp_input.c
> +++ b/sound/drivers/pcsp/pcsp_input.c
> @@ -16,6 +16,7 @@
>  #include <linux/input.h>
>  #include <asm/io.h>
>  #include "pcsp.h"
> +#include "pcsp_input.h"
>  
>  static void pcspkr_do_sound(unsigned int count)
>  {
> -- 
> 1.7.9.5
> 
