Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbbAJVTE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:19:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37666 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbbAJVTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:19:02 -0500
Date: Sat, 10 Jan 2015 21:18:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: Getting new udev to run with 2.6.28
Message-ID: <20150110211857.GA22149@ZenIV.linux.org.uk>
References: <20150110173920.GA31847@amd>
 <20150110180532.GA8566@kroah.com>
 <20150110180942.GA10142@amd>
 <20150110181710.GA8884@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110181710.GA8884@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 10:17:10AM -0800, Greg KH wrote:
> > > Yes, 3.18, please use that instead.
> > 
> > Can't, sorry. My goal is to get 3.18/3.19 working, but I really need
> > working kernel to debug userland (and then use that userland to debug kernel).
> > 
> > > Seriously, lots of things have changed, if you want to run a "new"
> > > version of udev with an old kernel, try eudev, they have been attempting
> > > to keep "legacy" support around in it, don't know how well it has been
> > > working though, you really are on your own.
> > 
> > I was hoping someone has devtmpfs patches I could just apply over
> > 2.6.28 and get a working system?
> 
> If you want such a crazy thing, you have all of the source to do it
> yourself, good luck.

... and this, boys and girls, is why quite a few of us have loathed udev
way before it got merged into even nastier shitpile.  Still do, for that
matter.
