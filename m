Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3GLDrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 23:47:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab3GLDra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 23:47:30 -0400
Date: Thu, 11 Jul 2013 20:48:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [ 6/8] MAINTAINERS: add stable_kernel_rules.txt to stable
 maintainer information
Message-ID: <20130712034825.GA4965@kroah.com>
References: <20130711221931.216612791@linuxfoundation.org>
 <20130711221931.994089526@linuxfoundation.org>
 <1373600160.24446.74.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373600160.24446.74.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 04:36:00AM +0100, Ben Hutchings wrote:
> On Thu, 2013-07-11 at 15:20 -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > commit 7b175c46720f8e6b92801bb634c93d1016f80c62 upstream.
> > 
> > This hopefully will help point developers to the proper way that patches
> > should be submitted for inclusion in the stable kernel releases.
> > 
> > Reported-by: David Howells <dhowells@redhat.com>
> > Acked-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  MAINTAINERS |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5725,6 +5725,7 @@ P:	Vincent Sanders <vince@simtec.co.uk>
> >  M:	Simtec Linux Team <linux@simtec.co.uk>
> >  W:	http://www.simtec.co.uk/products/EB110ATX/
> >  S:	Supported
> > +F:	Documentation/stable_kernel_rules.txt
> 
> You've applied this in the wrong place for some reason.

Ick, patch did something odd there, thanks, I'll go fix it up and see if
3.4 is ok too.

greg k-h
