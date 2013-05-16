Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab3EPWiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:38:15 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47918 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754764Ab3EPWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:38:14 -0400
Date: Fri, 17 May 2013 01:37:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/6] media: i2c: ths7303: remove init_enable option from
 pdata
Message-ID: <20130516223739.GB2077@valkosipuli.retiisi.org.uk>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368619042-28252-2-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368619042-28252-2-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thanks for the patch!

On Wed, May 15, 2013 at 05:27:17PM +0530, Lad Prabhakar wrote:
> diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
> index 65853ee..8cddcd0 100644
> --- a/drivers/media/i2c/ths7303.c
> +++ b/drivers/media/i2c/ths7303.c
> @@ -356,9 +356,7 @@ static int ths7303_setup(struct v4l2_subdev *sd)
>  	int ret;
>  	u8 mask;
>  
> -	state->stream_on = pdata->init_enable;
> -
> -	mask = state->stream_on ? 0xff : 0xf8;
> +	mask = 0xf8;

You can assign mask in declaration. It'd be nice to have a human-readable
name for the mask, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
