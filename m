Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaEZPFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:05:19 -0400
Received: from 1wt.eu ([62.212.114.60]:36020 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaEZPFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:05:17 -0400
Date: Mon, 26 May 2014 17:05:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: panel: (coding style) Matching braces
Message-ID: <20140526150513.GJ13929@1wt.eu>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr> <20140526142827.GG13929@1wt.eu> <1401115505.7240.11.camel@wisdom>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401115505.7240.11.camel@wisdom>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 04:45:05PM +0200, Dominique van den Broeck wrote:
> 
> Hello Willy,
> 
> > I don't want to be nit-picking, but since we're talking about style...
> > for me these "} else {" statements are harder to parse than having them
> > on two lines this way :
> > <...>
> >
> > It's just a matter of taste I know, but for me they read easier, probably
> > because the braces do not affect alignment and the lines appear exactly
> > similar with or without the braces.
> 
> I don't mind at all about this. 
> 
> Even if I'm into C code for quite a long time now, I'm still new in kernel
> development (just completed the Eudyptula Challenge) and I thought it could
> be both a harmless and useful way to start contributing and get used with it
> to focus a bit on ./checkpatch.pl suggestions (which is the actual entity to
> blame about it).
> 
> This is the reason why I submitted the patch but it's not a personal
> preference. If you prefer these braces laid out the older way, I'll let
> them as is next time. If there's another usages I should know about, just
> let me know.

You shouldn't bother too much about these style issues in fact. You'll
ask 4 people, you'll get 4 different opinions and will end up with
frustration depending on who will reply with just a "NAK", and sometimes
your change will cause a regression because it's easy to to a mistake
when just changing style.

The best thing to do in general if you want to slowly get into the kernel
is to focus on features you're actually using and which do not work the
optimal way. It's then easy to start by adding debugging code all over
the drive, find where the functions are called from and progressively
get an idea of what does what. Buying cheap small devices is a fun way
to do this BTW :-)

Willy

