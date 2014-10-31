Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663AbaJaWIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:08:41 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37031 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaJaWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:08:40 -0400
Date: Fri, 31 Oct 2014 23:08:34 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: panel: Remove outdated TODO tasks
Message-ID: <20141031220834.GC15010@t400>
References: <1414792903-7986-1-git-send-email-marius.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414792903-7986-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Mariusz Gorski wrote:
> Remove Lindent and checkpatch.pl tasks from TODO file as the first one
> is obsolete and the other one is already done.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> ---
> v3: Fixed commit summary

Great. Thanks.

regards,
konrad
 
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
