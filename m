Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3CJRXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 13:23:49 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35752 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3CJRXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 13:23:48 -0400
Date: Sun, 10 Mar 2013 10:24:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 30/31] driver/base: implement subsys_virtual_register()
Message-ID: <20130310172430.GA4723@kroah.com>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-31-git-send-email-tj@kernel.org>
 <20130302181727.GB2051@kroah.com>
 <CAPXgP11Zuz166v_M2EhGDY1U5vKtUwE+fTPAWYEu7UxXsr=g=A@mail.gmail.com>
 <20130305204327.GK12795@htj.dyndns.org>
 <20130307233116.GF10304@kroah.com>
 <CAPXgP10CEMgdOW23txWwwh0xSVd97fKH31xdKjE8Wy51kO6XdQ@mail.gmail.com>
 <20130310115702.GB24522@htj.dyndns.org>
 <20130310164530.GA4523@kroah.com>
 <CAPXgP136685qRguL6C91C+NE7GbgrU7CdpQJW89Fi-_Vw6EukA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP136685qRguL6C91C+NE7GbgrU7CdpQJW89Fi-_Vw6EukA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 06:00:18PM +0100, Kay Sievers wrote:
> On Sun, Mar 10, 2013 at 5:45 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sun, Mar 10, 2013 at 04:57:02AM -0700, Tejun Heo wrote:
> >> Hey, guys.
> >>
> >> On Fri, Mar 08, 2013 at 01:04:25AM +0100, Kay Sievers wrote:
> >> > > Sorry for the delay, I'm at a conference all this week, and haven't had
> >> > > much time to think about this.
> >> > >
> >> > > If Kay says this is ok for now, that's good enough for me.
> >> >
> >> > Yes, it looks fine to me. If we provide the unified handling of
> >> > classes and buses some day, this can probably go away, but until that
> >> > it looks fine and is straight forward to do it that way,
> >>
> >> How should this be routed?  I can take it but Kay needs it too so
> >> workqueue tree probably isn't the best fit although I can set up a
> >> separate branch if needed.
> >
> > What patch set does Kay need it for?  I have no objection for you to
> > take it through the workqueue tree:
> 
> The dbus bus has the same issues and needs the devices put under
> virtual/ and not the devices/ root.

Yes, but I can keep Tejun's patch in my local queue for now, dbus is
going to not make 3.10, right?

thanks,

greg k-h
