Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbbAIXDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:03:20 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:42535 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbbAIXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:03:19 -0500
Message-ID: <54B05E05.3090409@ladisch.de>
Date: Sat, 10 Jan 2015 00:02:29 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, stefanr@s5r6.in-berlin.de
CC: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCH] media; firewire: Remove no longer needed fix me comment
	in firedtv-ci.c for the function,fdtv_ca_ioctl
References: <1420838221-3957-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1420838221-3957-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20150109225841.539182.60750@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause wrote:
> Removes the no longer fix me comment for if we need to set the tuner status with
> the line, avc_tuner_status(fdtv, &stat). This line is needed in order to set the
> tuner status after we have through the switch statement checking what fdtv function
> we need to call to use to try and setup the hardware successfully.

You have attempted to describe what fdtv_ca_ioctl() does, but your description
lacks any understanding of what avc_tuner_status() does, or how it might affect
the device, or whether it is necessary.

Please stop spamming us with useless patches.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/media/firewire/firedtv-ci.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
> index e63f582..9c038ba 100644
> --- a/drivers/media/firewire/firedtv-ci.c
> +++ b/drivers/media/firewire/firedtv-ci.c
> @@ -201,7 +201,6 @@ static int fdtv_ca_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		err = -EOPNOTSUPP;
>  	}
>
> -	/* FIXME Is this necessary? */
>  	avc_tuner_status(fdtv, &stat);
>
>  	return err;
