Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851Ab3GWVui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:50:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3GWVuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:50:37 -0400
Date: Tue, 23 Jul 2013 14:50:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aldo Iljazi <neonsync1@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: cxt1e1: ossiRelease.c: fixed a coding style
 issue.
Message-ID: <20130723215036.GA5367@kroah.com>
References: <1373301228-18694-1-git-send-email-neonsync1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373301228-18694-1-git-send-email-neonsync1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 07:33:48PM +0300, Aldo Iljazi wrote:
> Fixed a coding style issue, specifically checkpatch.pl complain:
> ossiRelease.c:27: WARNING: line over 80 characters
> 
> Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
> ---
>  drivers/staging/cxt1e1/ossiRelease.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/cxt1e1/ossiRelease.c b/drivers/staging/cxt1e1/ossiRelease.c
> index f17a902..35575bf 100644
> --- a/drivers/staging/cxt1e1/ossiRelease.c
> +++ b/drivers/staging/cxt1e1/ossiRelease.c
> @@ -24,6 +24,7 @@
>   *-----------------------------------------------------------------------------
>   */
>  
> -char pmcc4_OSSI_release[] = "$Release: PMCC4_3_1B,  Copyright (c) 2008 One Stop Systems$";
> +char pmcc4_OSSI_release[] = "$Release: PMCC4_3_1B,  "
> +"Copyright (c) 2008 One Stop Systems$";

No, please fix this correctly, by just removing it entirely, it's not
needed.

thanks,

greg k-h
