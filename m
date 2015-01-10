Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbbAJW7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:59:35 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:41959 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbbAJW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:59:34 -0500
Date: Sun, 11 Jan 2015 00:59:27 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, ivo.g.dimitrov.75@gmail.com,
        Greg KH <greg@kroah.com>
Subject: Re: Getting new udev to run with 2.6.28
Message-ID: <20150110225927.GB5125@fuloong-minipc.musicnaut.iki.fi>
References: <20150110173920.GA31847@amd>
 <20150110191335.GA5125@fuloong-minipc.musicnaut.iki.fi>
 <20150110211805.GZ22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110211805.GZ22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 10, 2015 at 09:18:05PM +0000, Al Viro wrote:
> On Sat, Jan 10, 2015 at 09:13:35PM +0200, Aaro Koskinen wrote:
> > On Sat, Jan 10, 2015 at 06:39:20PM +0100, Pavel Machek wrote:
> > > N900 has real problems on 3.19, and 2.6.28 should be very well
> > > debugged version. Getting it to compile on recent distribution was
> > > fun, but I succeeded. Unfortunately, Debian 7's udev does not work
> > > with 2.6.28...
> > 
> > I guess you will have many other issues too if you want to run
> > such combination (legacy kernel + modern userspace). E.g. current glibc
> > requires >= 2.6.32.
> 
> How current is current and just what does it require in 2.6.32?

In glibc 2.20 the minimum kernel version was increased to 2.6.32.
Maybe this patch gives some examples what features they now expect
to be present:

	https://sourceware.org/ml/libc-alpha/2014-04/msg00691.html

But looks like Debian 7 is not bleeding-edge and is using older version...

A.
