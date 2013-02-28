Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab3B1Q5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:57:23 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49158 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3B1Q5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:57:22 -0500
Date: Thu, 28 Feb 2013 08:57:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Viktar Palstsiuk <Viktar.Palstsiuk@promwad.com>,
        Gorokh Dmitriy <Dmitriy.Gorokh@promwad.com>
Subject: Re: [PATCH] staging: si3226x: TDM: add issues to TODO file
Message-ID: <20130228165720.GB6510@kroah.com>
References: <F7F628C32E67B04DAECC5CA53521253E6AD1BA22@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E6AD1BA22@sv-exmb01-lo1.promwad.corp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:30:52PM +0000, Kurachkin Michail wrote:
> Signed-off-by: Michail Kurachkin <michail.kurachkin@promwad.com>
> ---
>  drivers/staging/si3226x/TODO |   20 +++++++++++++++++---
>  drivers/staging/tdm/TODO     |   19 +++++++++++++++++++
>  2 files changed, 36 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/staging/tdm/TODO
> 
> diff --git a/drivers/staging/si3226x/TODO b/drivers/staging/si3226x/TODO
> index b2cb27e..e4c334a 100644
> --- a/drivers/staging/si3226x/TODO
> +++ b/drivers/staging/si3226x/TODO
> @@ -1,8 +1,22 @@
> +Mainteiners:
> +Michail Kurachkin <Michail.Kurachkin@promwad.com> <stelhs@yandex.ru>
> +Ivan Kuten <ivan.kuten@promwad.com>
> +Promwad company <info@promwad.com>
> +
> +Reviwers:
> +Oliver Neukum <oneukum@suse.de>
> +Ryan Mallon <rmallon@gmail.com>
> +Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Why are you listing reviewers?  We've never done that in a TODO file
before, please don't start.

And this should be two patches, one for each driver.

In fact, ideally it would be part of your original series.  As I really
don't want to hand-edit the Subject: of those patches, can you just fix
this up properly and resend all of them, based on the comments I've
provided so far?

thanks,

greg k-h
