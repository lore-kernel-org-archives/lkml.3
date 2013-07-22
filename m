Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3GVPNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:13:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3GVPNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:13:33 -0400
Date: Mon, 22 Jul 2013 08:13:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Won Kang <wkang77@gmail.com>, devel@driverdev.osuosl.org,
        jonathankim@gctsemi.com, linux-kernel@vger.kernel.org,
        deanahn@gctsemi.com, wonkang@gctsemi.com
Subject: Re: [PATCH 2/2] staging: gdm7240: added contacts for code maintanance
Message-ID: <20130722151348.GA18716@kroah.com>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
 <1374476192-7801-2-git-send-email-wonkang@gctsemi.com>
 <1374478157.2061.32.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374478157.2061.32.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 12:29:17AM -0700, Joe Perches wrote:
> On Mon, 2013-07-22 at 15:56 +0900, Won Kang wrote:
> []
> > diff --git a/drivers/staging/gdm724x/TODO b/drivers/staging/gdm724x/TODO
> []
> > @@ -1,2 +1,6 @@
> >  TODO:
> > -- Clean up coding style to meet kernel standard.
> > \ No newline at end of file
> > +- Clean up coding style to meet kernel standard.
> > +
> > +Patches to:
> > +	Jonathan Kim <jonathankim@gctsemi.com>
> > +	Dean ahn <deanahn@gctsemi.com>
> 
> It would be better to add a MAINTAINERS section entry.

Yes, but I don't require it, this is good enough for now.

thanks,

greg k-h
