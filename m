Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaBKU7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:59:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56163 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaBKU64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:58:56 -0500
Date: Tue, 11 Feb 2014 20:58:42 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Baytrail/T (ASUS T100 etc) regression from 3.13 onwards
Message-ID: <20140211205842.5804c2f5@alan.etchedpixels.co.uk>
In-Reply-To: <20140211114524.42ceefa5@jbarnes-desktop>
References: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
	<20140114120103.436d190b@alan.etchedpixels.co.uk>
	<20140211142203.77561e0f@alan.etchedpixels.co.uk>
	<20140211163541.GB12567@kroah.com>
	<20140211101137.23b2274b@jbarnes-desktop>
	<20140211181815.GA19306@kroah.com>
	<20140211182812.7cc8854a@alan.etchedpixels.co.uk>
	<20140211114524.42ceefa5@jbarnes-desktop>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 11:45:24 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 11 Feb 2014 18:28:12 +0000
> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> 
> > O> > According to the reg dumps, this is actually a MIPI panel we're failing
> > > > to bring up properly.  We're working on that issue, but in the
> > > > meantime, maybe something like the below would work for you?
> > > 
> > > A module paramater to fix a bug?  Ugh, that's almost worse than just
> > > reverting the original patch, right?
> > > 
> > > Please don't do this, the distros will hate you even more than they
> > > currently do :)
> > 
> > Can we just turn hot plug detection off if a panel is present for now ?
> 
> Looks like another option would be to add an 'e' to your forced boot
> line.  That should prevent the detection stuff from running.  E.g. in
> your case:
> video=VGA-1:1366x768e
> 
> There's some info on this in Documentation/fb/modedb.txt

Confirmed, tested and bug plus relevant people updated.

Thanks

Alan
