Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbbAJVSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:18:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37657 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbAJVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:18:15 -0500
Date: Sat, 10 Jan 2015 21:18:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, ivo.g.dimitrov.75@gmail.com,
        Greg KH <greg@kroah.com>
Subject: Re: Getting new udev to run with 2.6.28
Message-ID: <20150110211805.GZ22149@ZenIV.linux.org.uk>
References: <20150110173920.GA31847@amd>
 <20150110191335.GA5125@fuloong-minipc.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110191335.GA5125@fuloong-minipc.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 09:13:35PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Sat, Jan 10, 2015 at 06:39:20PM +0100, Pavel Machek wrote:
> > N900 has real problems on 3.19, and 2.6.28 should be very well
> > debugged version. Getting it to compile on recent distribution was
> > fun, but I succeeded. Unfortunately, Debian 7's udev does not work
> > with 2.6.28...
> 
> I guess you will have many other issues too if you want to run
> such combination (legacy kernel + modern userspace). E.g. current glibc
> requires >= 2.6.32.

How current is current and just what does it require in 2.6.32?
