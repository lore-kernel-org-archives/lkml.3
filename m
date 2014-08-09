Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaHIRg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:36:27 -0400
Received: from mout.gmx.net ([212.227.15.15]:60083 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaHIRgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:36:25 -0400
Date: Sat, 9 Aug 2014 19:36:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Suman Kumar <suman@inforcecomputing.com>
cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: soc_camera: soc_camera_platform.c: Fixed a
 Missing blank line coding style issue
In-Reply-To: <1407604952-15492-1-git-send-email-suman@inforcecomputing.com>
Message-ID: <Pine.LNX.4.64.1408091934100.20541@axis700.grange>
References: <1407604952-15492-1-git-send-email-suman@inforcecomputing.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:be/G5pngnZ8a3vHGa4o37k2lxlwlxdSIaAJm+kdqS/9lSNpRTT5
 9zRL9VjC7qpzGZ9Gw3kl+Okgi8CEhPbh5nttAEl8BwmoIEJXTizRataPTukNvB1mBYzF7H0
 l4Kaf4WO5h5hP9ZRfjVfUrcjgBVviSQ2emRIcggEopP+JC0EP7+y/6w8ka4wqyfAW21NYiJ
 oAiesC4USeHUSt6W8D8yg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Sat, 9 Aug 2014, Suman Kumar wrote:

>     Fixes a coding style issue reported by checkpatch.pl

Thanks for your patch. To my taste checkpatch.pl has unfortunately become 
too noisy with meaningless / unimportant warnings like this one. Is this 
in CodingStyle? If not, my intention is to drop this. However, Mauro may 
override by either taking this himself or asking me to apply this.

Thanks
Guennadi

> 
> Signed-off-by: Suman Kumar <suman@inforcecomputing.com>
> ---
>  drivers/media/platform/soc_camera/soc_camera_platform.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
> index ceaddfb..fe15a80 100644
> --- a/drivers/media/platform/soc_camera/soc_camera_platform.c
> +++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
> @@ -27,12 +27,14 @@ struct soc_camera_platform_priv {
>  static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
>  {
>  	struct v4l2_subdev *subdev = platform_get_drvdata(pdev);
> +
>  	return container_of(subdev, struct soc_camera_platform_priv, subdev);
>  }
>  
>  static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> +
>  	return p->set_capture(p, enable);
>  }
>  
> -- 
> 1.8.2
> 
