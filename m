Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaLCQGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:06:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaLCQF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:05:57 -0500
Date: Wed, 3 Dec 2014 08:04:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sam van Kampen <sam@tehsvk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: line6: fix parentheses around macro in usbdefs.h
Message-ID: <20141203160434.GB12149@kroah.com>
References: <20141203082249.GA18890@nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203082249.GA18890@nsa.gov>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 09:22:49AM +0100, Sam van Kampen wrote:
> >From a9deb1763d3f23a3b005e63fdc896c6d903097d1 Mon Sep 17 00:00:00 2001
> From: Sam van Kampen <sam@tehsvk.net>
> Date: Wed, 3 Dec 2014 09:05:51 +0100
> Subject: [PATCH] Staging: line6: fix parentheses around macro in usbdefs.h

Why is this mess here?

> This patch fixes the error "Macros with complex values should be enclosed in
> parentheses", as reported by checkpatch.pl.
> 
> Signed-off-by: Sam van Kampen <sam@tehsvk.net>
> ---
>  drivers/staging/line6/usbdefs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Any reason you didn't use scripts/get_maintainer.pl to determine who to
send the patch to?  Please do that and resend.

thanks,

greg k-h
