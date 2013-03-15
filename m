Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3COQFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:05:08 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50650 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3COQFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:05:06 -0400
Date: Fri, 15 Mar 2013 09:04:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: abbotti@mev.co.uk, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: ni_atmio.c: Add a missing
 semicolon
Message-ID: <20130315160445.GA24062@kroah.com>
References: <1363335269-14903-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363335269-14903-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 01:14:29AM -0700, Kumar Amit Mehta wrote:
> fix a missing end-of-statement by adding a semicolon.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_atmio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hartley sent a fix for this yesterday, sorry about not applying it
sooner.

greg k-h
