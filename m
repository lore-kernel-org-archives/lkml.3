Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaDEWHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 18:07:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaDEWHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 18:07:03 -0400
Date: Sat, 5 Apr 2014 15:09:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Camille Begue <camille.begue44@gmail.com>
Cc: devel@driverdev.osuosl.org, Ian Abbott <abbotti@mev.co.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] staging: comedi: Fix checkpatch warning
Message-ID: <20140405220927.GA29836@kroah.com>
References: <1396644920-13925-1-git-send-email-camille.begue44@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396644920-13925-1-git-send-email-camille.begue44@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 10:55:18PM +0200, Camille Begue wrote:
> Wrap lines > 80 columns.
> This patch is part of eudyptula challenge
> 
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

Why did you split this into 3 lines, it only needs to be 2 like this:
		dev_dbg(dev->class_dev, "%d not valid subdevice\n",
			cmd->subdev);

thanks,

greg k-h
