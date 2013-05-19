Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3ESImQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 04:42:16 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49158 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753826Ab3ESImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 04:42:15 -0400
Date: Sun, 19 May 2013 11:42:06 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: bug fixing and cleanup
In-Reply-To: <20130518210948.GA26590@electric-eye.fr.zoreil.com>
Message-ID: <alpine.DEB.2.02.1305191136360.4537@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305181902080.7518@fry.nucleusys.com> <20130518210948.GA26590@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 May 2013, Francois Romieu wrote:

> Petko Manolov <petkan@nucleusys.com> :
> > From: Petko Manolov <petkan@nucleusys.com>
> > 
> > Moving constant and structure definitions out of rtl8150.c;
> 
> What's the point ?

The general logic of having .h files applies.
 
> [...]
> > ---
> >  drivers/net/usb/rtl8150.c |  121 +----------------------------------
> >  1 file changed, 2 insertions(+), 119 deletions(-)
> > 
> > diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> > index a491d3a..7d1897b 100644
> > --- a/drivers/net/usb/rtl8150.c
> > +++ b/drivers/net/usb/rtl8150.c
> > @@ -17,132 +17,15 @@
> >  #include <linux/usb.h>
> >  #include <asm/uaccess.h>
> >  
> > +#include "rtl8150.h"
> 
> It won't compile. You shouldn't do that.

It does compile.  Both inside and outside of the tree.

If the proper place for rtl8150.h is somewhere in include/linux/... then 
it is different matter.
