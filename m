Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaEAJC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:02:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:55776 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbaEAJC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:02:27 -0400
Message-ID: <53620D6F.1020808@mev.co.uk>
Date: Thu, 1 May 2014 10:01:35 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Raghavendra Ganiga <ravi23ganiga@gmail.com>,
        <hsweeten@visionengravers.com>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: fix coding style issues in comedi_fops.c
References: <1398879289-20442-1-git-send-email-ravi23ganiga@gmail.com>
In-Reply-To: <1398879289-20442-1-git-send-email-ravi23ganiga@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/04/30 06:34 PM, Raghavendra Ganiga wrote:
> This is a patch to fix coding style
> warnings found by the checkpatch.pl tool
> 
> Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
> ---
>  drivers/staging/comedi/comedi_fops.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index acc8019..a62d639 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -1435,13 +1435,15 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
>  	s = &dev->subdevices[cmd->subdev];
>  
>  	if (s->type == COMEDI_SUBD_UNUSED) {
> -		dev_dbg(dev->class_dev, "%d not valid subdevice\n", cmd->subdev);
> +		dev_dbg(dev->class_dev, "%d not valid subdevice\n",
> +			cmd->subdev);
>  		return -EIO;
>  	}
>  
>  	if (!s->do_cmd || !s->do_cmdtest || !s->async) {
>  		dev_dbg(dev->class_dev,
> -			"subdevice %d does not support commands\n", cmd->subdev);
> +			"subdevice %d does not support commands\n",
> +			cmd->subdev);
>  		return -EIO;
>  	}

(I think this is "PATCH v2".)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
