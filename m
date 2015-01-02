Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbbABNEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 08:04:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40340 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbABNEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 08:04:36 -0500
Date: Fri, 2 Jan 2015 14:04:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: Re: [PATCH] drivers/edac: Fix a typo in comments
Message-ID: <20150102130433.GB31364@pd.tnic>
References: <1419749085-7128-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419749085-7128-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 12:44:45PM +0600, Alexander Kuleshov wrote:
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---

Applied, thanks.

Next time, use

./scripts/get_maintainer.pl -f drivers/edac/mpc85xx_edac.c

to get a list of the relevant maintainers; in this case Johannes. I've
CCed him now.

>  drivers/edac/mpc85xx_edac.c | 2 +-
>  drivers/edac/mpc85xx_edac.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> index ffb1a9a..1fa76a5 100644
> --- a/drivers/edac/mpc85xx_edac.c
> +++ b/drivers/edac/mpc85xx_edac.c
> @@ -1,5 +1,5 @@
>  /*
> - * Freescale MPC85xx Memory Controller kenel module
> + * Freescale MPC85xx Memory Controller kernel module
>   *
>   * Parts Copyrighted (c) 2013 by Freescale Semiconductor, Inc.
>   *
> diff --git a/drivers/edac/mpc85xx_edac.h b/drivers/edac/mpc85xx_edac.h
> index 8c62564..4498baf 100644
> --- a/drivers/edac/mpc85xx_edac.h
> +++ b/drivers/edac/mpc85xx_edac.h
> @@ -1,5 +1,5 @@
>  /*
> - * Freescale MPC85xx Memory Controller kenel module
> + * Freescale MPC85xx Memory Controller kernel module
>   * Author: Dave Jiang <djiang@mvista.com>
>   *
>   * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
> -- 
> 2.2.1.202.g98acd41.dirty
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
