Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbaJaVM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:12:29 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:56751 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaJaVM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:12:28 -0400
Date: Fri, 31 Oct 2014 22:12:23 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove outdated TODO tasks
Message-ID: <20141031211223.GA15010@t400>
References: <1414789606-7170-1-git-send-email-marius.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414789606-7170-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Mariusz Gorski wrote:
> Remove Lindent and checkpatch.pl tasks from TODO file as the first one
> is obsolete and the other one is already done.

Great however your topic is ill formated. It should contain the "staging:
panel:" prefix.

thanks,
konrad

> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> ---
>  drivers/staging/panel/TODO | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/panel/TODO b/drivers/staging/panel/TODO
> index a4be749..c8040c1 100644
> --- a/drivers/staging/panel/TODO
> +++ b/drivers/staging/panel/TODO
> @@ -1,6 +1,4 @@
>  TODO:
> -	- checkpatch.pl cleanups
> -	- Lindent
>  	- review major/minor usages
>  	- review userspace api
>  	- see if all of this could be easier done in userspace instead.
> -- 
> 2.1.3
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
