Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbbAJSRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:17:13 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37939 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbbAJSRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:17:12 -0500
X-Sasl-enc: O1znvBzPEYCCvlYcmObOj8WgkJExxuH9cDkt3rSEmTGT 1420913831
Date: Sat, 10 Jan 2015 10:17:10 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: Getting new udev to run with 2.6.28
Message-ID: <20150110181710.GA8884@kroah.com>
References: <20150110173920.GA31847@amd>
 <20150110180532.GA8566@kroah.com>
 <20150110180942.GA10142@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110180942.GA10142@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 07:09:42PM +0100, Pavel Machek wrote:
> On Sat 2015-01-10 10:05:32, Greg KH wrote:
> > On Sat, Jan 10, 2015 at 06:39:20PM +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > N900 has real problems on 3.19, and 2.6.28 should be very well
> > > debugged version. Getting it to compile on recent distribution was
> > > fun, but I succeeded. Unfortunately, Debian 7's udev does not work
> > > with 2.6.28...
> > > 
> > > Does anyone have kernel patches to enable modern udev?
> > 
> > Yes, 3.18, please use that instead.
> 
> Can't, sorry. My goal is to get 3.18/3.19 working, but I really need
> working kernel to debug userland (and then use that userland to debug kernel).
> 
> > Seriously, lots of things have changed, if you want to run a "new"
> > version of udev with an old kernel, try eudev, they have been attempting
> > to keep "legacy" support around in it, don't know how well it has been
> > working though, you really are on your own.
> 
> I was hoping someone has devtmpfs patches I could just apply over
> 2.6.28 and get a working system?

If you want such a crazy thing, you have all of the source to do it
yourself, good luck.
