Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaHVXWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:22:48 -0400
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:53851 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751744AbaHVXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:22:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6742:7576:7652:10004:10394:10400:10848:11232:11658:11914:12043:12517:12519:12663:12740:13069:13161:13184:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,Do
X-HE-Tag: word08_6f1eba0603560
X-Filterd-Recvd-Size: 2396
Message-ID: <1408749762.17241.50.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: look for common misspellings
From: Joe Perches <joe@perches.com>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Masanari Iida <standby24x7@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc <linux-doc@vger.kernel.org>
Date: Fri, 22 Aug 2014 16:22:42 -0700
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C1CAFD@G9W0745.americas.hpqcorp.net>
References: <20140821162050.GA1323@www.outflux.net>
	 <1408641520.23250.71.camel@joe-AO725>
	 <CAGXu5jJmp4-sposMxjTobEj0xzueQY54OzvdDQg-GC-HhJuBwQ@mail.gmail.com>
	 <1408666251.22832.33.camel@joe-AO725> <1408747041.17241.39.camel@joe-AO725>
	 <94D0CD8314A33A4D9D801C0FE68B402958C1CAFD@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 23:00 +0000, Elliott, Robert (Server Storage)
wrote:
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Joe Perches
> ...
> > +chang||change
> 
> Although there are at least 2 misuses in the current kernel,
> that's also a fairly common name.

True.  Thanks.

That one should likely be removed.
There are dozens of Chang name uses in the kernel.

I'm not attached at all to any of these btw.

Any others you think should not be used or
should be added?

One I thought kind of iffy was

	contant||contact

Maybe that should be content instead.

Another thing the script might do is to check
if the $typo match is all upper case and then
substitute an all upper case $typo_fix.

It's also kind of noisy when run using -f,
so maybe this test should be --strict check with
files and a warning with patches.


