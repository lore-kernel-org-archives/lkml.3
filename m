Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaCNImN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:42:13 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1600 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaCNImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:42:10 -0400
Message-ID: <5322C0CC.1080605@xs4all.nl>
Date: Fri, 14 Mar 2014 09:41:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] media: davinci: vpbe: fix build warning
References: <1394774735-22320-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1394774735-22320-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 06:25 AM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch fixes following build warning
> drivers/media/platform/davinci/vpbe_display.c: In function 'vpbe_start_streaming':
> drivers/media/platform/davinci/vpbe_display.c:344: warning: unused variable 'vpbe_dev'
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/platform/davinci/vpbe_display.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 7a0e40e..b4f12d0 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -341,7 +341,6 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
>  	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
>  	struct vpbe_layer *layer = fh->layer;
> -	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
>  	int ret;
>  
>  	/* Get the next frame from the buffer queue */
> 

