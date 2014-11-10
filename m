Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaKJWUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:20:22 -0500
Received: from lists.s-osg.org ([54.187.51.154]:44247 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaKJWUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:20:20 -0500
Date: Mon, 10 Nov 2014 20:20:13 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL for v3.18-rc1] media updates
Message-ID: <20141110202013.2a83ff9f@recife.lan>
In-Reply-To: <1415653538.21229.37.camel@x220>
References: <20141009141849.137e738d@recife.lan>
	<1413793905.16435.6.camel@x220>
	<1415652356.21229.31.camel@x220>
	<20141110185433.3c53e438@recife.lan>
	<1415653538.21229.37.camel@x220>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 10 Nov 2014 22:05:38 +0100
Paul Bolle <pebolle@tiscali.nl> escreveu:

> On Mon, 2014-11-10 at 18:54 -0200, Mauro Carvalho Chehab wrote:
> > Em Mon, 10 Nov 2014 21:45:56 +0100
> > Paul Bolle <pebolle@tiscali.nl> escreveu: 
> > > This typo is still present in both next-20141110 and v3.18-rc4. And I've
> > > first reported it nearly two months ago. I see two fixes:
> > >     1) s/HAS_MMU/MMU/
> > >     2) s/ || (COMPILE_TEST && HAS_MMU)//
> > > 
> > > Which would you prefer?
> > 
> > Hmm... Probably patchwork didn't get your patch.
> 
> There's no patch, not yet. I try to report stuff like this before
> sending patches. The idea here being that the people familiar with the
> code tend to fix things better and quicker.
> 
> > IMHO, the best would be:
> > 
> > 	depends on HAS_MMU
> 
> You really like the HAS_MMU symbol, don't you?


I got distracted by your (2) alternative:

> > >     2) s/ || (COMPILE_TEST && HAS_MMU)//

anyway you got it ;)

> 
> > 	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
> 
> But I understand what you're suggesting here. Should I draft a, probably
> untested, patch?

Sure.

Thanks!
Mauro
