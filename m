Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab3BLQQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:16:20 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62005 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab3BLQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:16:17 -0500
Date: Tue, 12 Feb 2013 08:16:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] -rc7/-rc4+: unable to USB boot - enumeration
 partially broken (was: Linux v3.8-rc7)
Message-ID: <20130212161617.GA3887@kroah.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130210001442.GA5744@rhlx01.hs-esslingen.de>
 <20130210140554.GA5299@rhlx01.hs-esslingen.de>
 <20130212160727.GA15857@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212160727.GA15857@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 05:07:27PM +0100, Andreas Mohr wrote:
> On Sun, Feb 10, 2013 at 03:05:54PM +0100, Andreas Mohr wrote:
> > Regression sorta confirmed now. -rc3 with a fully suitable .config does
> > not boot either. Will start bisection. Will take ages.
> 
> Down to 91 commits (all in USB land!), around 7 steps left.
> Pretty certain of a valid regression now. Things did properly do the
> good/good/bad/bad/good... dance.
> 
> Oh so lovely if you're constrained to >= 5 hour build times,

You do know about 'make localmodconfig', right?  That should cut your
build time down a large amount.

greg k-h
