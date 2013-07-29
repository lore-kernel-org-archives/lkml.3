Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3G2OLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:11:44 -0400
Received: from tex.lwn.net ([70.33.254.29]:52408 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3G2OLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:11:43 -0400
Date: Mon, 29 Jul 2013 08:11:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Kosina <jkosina@suse.cz>, Samuel Ortiz <sameo@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development
 process
Message-ID: <20130729081141.00818596@lwn.net>
In-Reply-To: <7008541.g5m1pJPVp1@vostro.rjw.lan>
References: <20130729102452.GA2682@zurbaran>
	<alpine.LNX.2.00.1307291230270.18809@pobox.suse.cz>
	<7008541.g5m1pJPVp1@vostro.rjw.lan>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 15:10:33 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> That actually is simple enough.
> 
> Check out the Linus' master branch and do
> 
> $ git log --ancestry-path --merges <commit>..

So I picked a recent, single-signoff patch mostly at random:

	8ade62857ef77bdf639185410fbcd811aa700cb2

That "git log" command gives me 156 intervening commits involving at least
a dozen networking trees, along with virtio, parisc, blackfin, x86, ...
Even if one stops looking at the first merge performed by Linus, that's 47
to look at.  Did that patch really pass through all those peoples' hands?

Plus, of course, this assumes there's no fast-forward merges in the mix.

>From your other message:

> And what about trusting maintainers?  If Linus trusts them enough to pull from
> them, why can't everybody else trust them enough to assume that they don't do
> bad things on purpose?

I hope you're not reading such thoughts into what *I* wrote.  But most
anybody who works on code occasionally does bad things by mistake, that's
why we have a review process.

jon
