Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3HAHzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:55:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HAHzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:55:41 -0400
Date: Thu, 1 Aug 2013 15:56:56 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add separate section for USB NETWORKING
 DRIVERS
Message-ID: <20130801075656.GA8074@kroah.com>
References: <1375316960686@kroah.org>
 <1375343328.2034.34.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375343328.2034.34.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 12:48:48AM -0700, Joe Perches wrote:
> There are several drivers in drivers/net/usb/ that
> do not have specific MAINTAINERS that should have
> emails forwarded to the linux-usb mailing list.
> 
> Add a section for those drivers.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> > In the future, you do not need to send drivers/net/usb/ patches to me,
> > netdev and the linux-usb mailing lists should be sufficient.
> 
> I should have done this in the first patch.
> Oh well...
> 
>  MAINTAINERS | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d83f70f..4af7539 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8656,6 +8656,11 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
>  S:	Maintained
>  F:	sound/usb/midi.*
>  
> +USB NETWORKING DRIVERS
> +L:	linux-usb@vger.kernel.org
> +S:	Odd Fixes
> +F:	drivers/net/usb/

But netdev is the one that applies these patches, not linux-usb, so this
isn't correct either.

sorry,

greg k-h
