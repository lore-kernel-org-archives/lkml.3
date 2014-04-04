Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaDDVYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:24:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18334 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaDDVYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:24:20 -0400
Date: Sat, 5 Apr 2014 00:24:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Camille Begue <camille.begue44@gmail.com>
Cc: devel@driverdev.osuosl.org, Ian Abbott <abbotti@mev.co.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] staging: comedi: Fix checkpatch warning
Message-ID: <20140404212410.GW6991@mwanda>
References: <1396638941-16099-1-git-send-email-camille.begue44@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396638941-16099-1-git-send-email-camille.begue44@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:15:39PM +0200, Camille Begue wrote:
> This patch is part of eudyptula challenge
> 

The changelog should mention something about lines over 80 characte
long.

> Signed-off-by: Camille Begue <camille.begue44@gmail.com>
> ---
>  drivers/staging/comedi/comedi_fops.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index ea6dc36..0f05e87 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -1435,13 +1435,16 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
>  	s = &dev->subdevices[cmd->subdev];
>  
>  	if (s->type == COMEDI_SUBD_UNUSED) {
> -		dev_dbg(dev->class_dev, "%d not valid subdevice\n", cmd->subdev);
> +		dev_dbg(dev->class_dev,
> +			"%d not valid subdevice\n",
> +			cmd->subdev);

Do this instead:

		dev_dbg(dev->class_dev, "%d not valid subdevice\n",
			cmd->subdev);

>  		return -EIO;
>  	}
>  

regards,
dan carpenter

