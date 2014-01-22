Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaAVBeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:34:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaAVBeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:34:18 -0500
Date: Tue, 21 Jan 2014 17:34:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: VDSO support for 32bit time functions
Message-ID: <20140122013451.GC18164@kroah.com>
References: <20140121075123.GA32170@kroah.com>
 <1390337646.1613.12.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390337646.1613.12.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:54:06PM +0100, Stefani Seibold wrote:
> Hi Grek,
> 
> On Monday, the 20.01.2014, 23:51 -0800 wrote Greg KH:
> > Hi Stefani,
> > 
> > About a year ago you posted a big patch to implement VDSO support for
> > 32bit functions, and the response was a request to clean it up a bit by
> > breaking up the generic bits into a series to make it easier to review /
> > apply.
> > 
> > The patch I'm referring to can be found here:
> > 	http://thread.gmane.org/gmane.linux.kernel/1411713
> > 
> > Did that ever happen?
> > 
> 
> I have revamped the patch, but the request for the IA32_EMULATION is
> still pending. I have now a solution for this which i had already
> implemented, but i need to do some tests.
> 
> > If not, any specific reason why?  Do you have a newer version somewhere
> > for "modern" kernel versions?
> > 
> 
> Currently my latest version is for 3.10, but i think i can bring it to
> 3.13. I will do this next weekend and post the patch.

Very cool, thanks, if you remember, can you cc: me when you post it?

I'll be glad to test it out on some systems here that I have.

thanks,

greg k-h
