Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaDDMjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:39:23 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:61888 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaDDMjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:39:21 -0400
Message-ID: <533EA7F1.2050209@bfs.de>
Date: Fri, 04 Apr 2014 14:39:13 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Kumar Amit Mehta <gmate.amit@gmail.com>
CC: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: pcl812.c: fixed a coding style
 issue
References: <1396605929-10514-1-git-send-email-gmate.amit@gmail.com>
In-Reply-To: <1396605929-10514-1-git-send-email-gmate.amit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 04.04.2014 12:05, schrieb Kumar Amit Mehta:
> Fixed a coding style issue. Reported by checkpatch.pl
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl812.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
> index 160eac8..5cc01fe 100644
> --- a/drivers/staging/comedi/drivers/pcl812.c
> +++ b/drivers/staging/comedi/drivers/pcl812.c
> @@ -811,8 +811,9 @@ static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>  				devpriv->ai_dma = 0;
>  				break;
>  			}
> -	} else
> +	} else {
>  		devpriv->ai_dma = 0;
> +	}
>  
>  	devpriv->ai_act_scan = 0;
>  	devpriv->ai_poll_ptr = 0;

hi Kumar,
is that else needed at all ? perhaps it is possible to devpriv->ai_dma=0 before the if ?
That would reduce code and give a better readability.

re,
 wh

