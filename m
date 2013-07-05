Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3GEMX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:23:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49873 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3GEMXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:23:55 -0400
Date: Fri, 5 Jul 2013 13:23:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/3] arch/um/Makefile: remove dead code
Message-ID: <20130705122352.GR4165@ZenIV.linux.org.uk>
References: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
 <1372971797-23518-2-git-send-email-artagnon@gmail.com>
 <20130704235313.GP4165@ZenIV.linux.org.uk>
 <CALkWK0mcK13RiVjNCrgwEaaL3nBZ1W0R5+cHAhbqiOmRE4UjAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0mcK13RiVjNCrgwEaaL3nBZ1W0R5+cHAhbqiOmRE4UjAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 04:12:30PM +0530, Ramkumar Ramachandra wrote:
> Al Viro wrote:
> > [...]
> > IOW, any make variable (== macro in POSIX quote above) can be explicitly
> > set in make(1) command line in form name=value and in that case nothing in
> > makefile(s) can change its value.  It's true for GNU make, it's true for
> > BSD make and it's been true for historical Unix make since its introduction
> > in v7.
> 
> Thanks Al, the education is much appreciated.  I always thought =
> would override it, and ?= was for default value.

?= is a different story - it refuses to override _any_ earlier declarations,
including ones in makefile itself.  GNU make has added it fairly late, BTW -
in 3.77 (1998); BSD make has grown it at some point during the rewrite
Adam de Boor had been doing in late 80s.  NFI whether he'd invented it or
picked it elsewhere - there had been a lot of cross-pollination between the
variants of make(1) all along...
