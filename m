Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3ETTQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:16:44 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49274 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753764Ab3ETTQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:16:43 -0400
Date: Mon, 20 May 2013 22:16:33 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Ben Hutchings <bhutchings@solarflare.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers: net: usb: rtl8150: making the code a bit
 better looking
In-Reply-To: <1369061535.4616.2.camel@bwh-desktop.uk.solarflarecom.com>
Message-ID: <alpine.DEB.2.02.1305202208460.3400@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305182314500.16874@fry.nucleusys.com> <1369061535.4616.2.camel@bwh-desktop.uk.solarflarecom.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013, Ben Hutchings wrote:

> [...]
> > @@ -771,12 +770,12 @@ static void rtl8150_disconnect(struct usb_interface *intf)
> >  }
> >  
> >  static struct usb_driver rtl8150_driver = {
> > -	.name		= driver_name,
> > -	.probe		= rtl8150_probe,
> > -	.disconnect	= rtl8150_disconnect,
> > -	.id_table	= rtl8150_table,
> > -	.suspend	= rtl8150_suspend,
> > -	.resume		= rtl8150_resume,
> > +	.name = driver_name,
> > +	.probe = rtl8150_probe,
> > +	.disconnect = rtl8150_disconnect,
> > +	.id_table = rtl8150_table,
> > +	.suspend = rtl8150_suspend,
> > +	.resume = rtl8150_resume,
> >  	.disable_hub_initiated_lpm = 1,
> >  };
> 
> These looked better before.  Lining up initialisers in a structure 
> definition is good style.

It is.  This is what i usually do.  However, scripts/Lindent is messed up 
in (not only) this regard.  IMHO it should not be used as it is.

I thought using what is recommended (at least in the documentation) makes 
me a good citizen even though i don't like the end result much.

Again, the above is true in case i've not misunderstood something, 
somewhere.


		Petko
