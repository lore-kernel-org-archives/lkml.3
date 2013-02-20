Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3BTFA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:00:58 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:50644 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3BTFA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:00:56 -0500
Date: Tue, 19 Feb 2013 21:01:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BONUS PATCH 2/2] base: core: WARN() about bogus permissions on
 device attributes
Message-ID: <20130220050122.GD2869@kroah.com>
References: <1361214544-14403-1-git-send-email-balbi@ti.com>
 <1361214544-14403-2-git-send-email-balbi@ti.com>
 <20130218191719.GB19724@kroah.com>
 <20130218192010.GE10755@arwen.pp.htv.fi>
 <20130219095910.GH23197@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219095910.GH23197@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 11:59:10AM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Feb 18, 2013 at 09:20:10PM +0200, Felipe Balbi wrote:
> > On Mon, Feb 18, 2013 at 11:17:19AM -0800, Greg KH wrote:
> > > On Mon, Feb 18, 2013 at 09:09:04PM +0200, Felipe Balbi wrote:
> > > > Whenever a struct device_attribute is registered
> > > > with mismatched permissions - read permission without
> > > > a show routine or write permission without store
> > > > routine - we will issue a big warning so we catch
> > > > those early enough.
> > > > 
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > ---
> > > > 
> > > > This is completely untested. I have only compile tested
> > > > to make sure I'm not breaking anything.
> > > > 
> > > > Greg, do you think this would be nice to have ? I could
> > > > fire up kvm tomorrow and run on a few of my OMAP-based
> > > > boards to make sure it works as expected.
> > > 
> > > Looks good, but you better fix up all of the big offenders that this
> > > points out, before I apply it, otherwise we will get a ton of bug
> > > reports :)
> > 
> > sure, will do that tomorrow though ;-)
> 
> Just tested $SUBJECT and it didn't trigger any extra warnings. Only the
> one whose fix you already applied (I reverted it to make sure $SUBJECT
> was working as expected).

Ok, care to resend so that I can queue it up after 3.9-rc1 is out, for
inclusion in 3.10, and we can have lots of time to see what falls out?

thanks,

greg k-h
