Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab3IICaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:30:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3IICaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:30:07 -0400
Date: Sun, 8 Sep 2013 19:33:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130909023311.GB5329@kroah.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com>
 <CALkWK0kx+71O074dfP4ikj4FayU6GWXOByTFPgVjv=CVO-btUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0kx+71O074dfP4ikj4FayU6GWXOByTFPgVjv=CVO-btUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 07:48:51AM +0530, Ramkumar Ramachandra wrote:
> Greg Kroah-Hartman wrote:
> > On Sun, Sep 08, 2013 at 06:03:00PM -0700, Guenter Roeck wrote:
> >> Unfortunately, LUSTRE can only be built as module, so there is no
> >> easy fix.
> >
> > Can't we just export the functions for those arches?  Surely lutre
> > isn't the first/only driver that needs this?
> 
> It's simply necessary to keep up to date: we can't keep building new
> arches since the initial cost can be quite high.

What do you mean by this?  What "initial cost"?  You should be able to
cross-compile almost all arches on your desktop machine today with the
compilers we have on kernel.org.  If I can get them set up and working,
they can't be that hard for anyone else :)

thanks,

greg k-h
