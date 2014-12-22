Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaLVBtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:49:07 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:53601 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLVBtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:49:05 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Sun, 21 Dec 2014 20:49:02 -0500
To: Joe Perches <joe@perches.com>
Cc: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        dwalker@fifo99.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: add per console loglevel
Message-ID: <20141222014902.GM24112@csclub.uwaterloo.ca>
References: <20141220224908.GB4466@fifo99.com>
 <20141221194753.49c12693@neptune.home>
 <1419188604.4200.8.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419188604.4200.8.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:03:24AM -0800, Joe Perches wrote:
> On Sun, 2014-12-21 at 19:47 +0100, Bruno Prémont wrote:
> > On Sat, 20 December 2014 dwalker@fifo99.com wrote:
> > > This adds to to the console= command line options allowing the
> > > addition of a per console log level setting.
> > > 
> > > examples,
> > > 
> > > 	console=ttyS0,ll4
> > > 	console=tty0,ll6
> > > 
> > > This can be used on systems which have multiple serial consoles, but
> > > it's desired for logging to be light on one and heavy on another.
> > 
> > Looks useful to me.
> 
> I think this is reasonable to, but for consistency
> with other loglevel uses, I suggest using
> loglevel=<level> instead of ll<d>

Oh those are l not 1.  I read that as ,114 and ,116 and was wondering
what that meant.

-- 
Len Sorensen
