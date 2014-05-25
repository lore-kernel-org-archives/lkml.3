Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaEYSOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:14:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEYSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:14:32 -0400
Date: Sun, 25 May 2014 11:14:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Manuel =?iso-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: devel@driverdev.osuosl.org, arnd@arndb.de, peter.p.waskiewicz.jr@intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        khoroshilov@ispras.ru
Subject: Re: [PATCH] staging: gdm72xx: use time_before()
Message-ID: <20140525181431.GA20614@kroah.com>
References: <1401023339-29712-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401023339-29712-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 03:08:59PM +0200, Manuel Schölling wrote:
> To be future-proof and for better readability the time comparisons are
> modified to use time_before() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> ---
>  drivers/staging/gdm72xx/gdm_usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This patch doesn't apply, can you please refresh it against my latest
tree and resend?

thanks,

greg k-h
