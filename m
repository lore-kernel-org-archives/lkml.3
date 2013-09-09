Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3IICr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:47:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3IICr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:47:26 -0400
Date: Sun, 8 Sep 2013 19:50:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130909025030.GA5963@kroah.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com>
 <CALkWK0kx+71O074dfP4ikj4FayU6GWXOByTFPgVjv=CVO-btUQ@mail.gmail.com>
 <20130909023311.GB5329@kroah.com>
 <CALkWK0mLUfJL0s-OxrmAD_RXpv0Qs-j23XedwPGAHKTq4JJjcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0mLUfJL0s-OxrmAD_RXpv0Qs-j23XedwPGAHKTq4JJjcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 08:08:28AM +0530, Ramkumar Ramachandra wrote:
> Greg Kroah-Hartman wrote:
> > What do you mean by this?  What "initial cost"?  You should be able to
> > cross-compile almost all arches on your desktop machine today with the
> > compilers we have on kernel.org.  If I can get them set up and working,
> > they can't be that hard for anyone else :)
> 
> Won't you need to physically explore hardware?

In order to do what?

> How will the hardware industry be driven otherwise?

I have no idea what you are referring to here, please explain.
