Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbaGRDVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:21:42 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:34705 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915AbaGRDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:21:41 -0400
Message-ID: <1405653693.21735.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Alpha Checkpatch Errors
From: Davidlohr Bueso <davidlohr@hp.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Richard Henderson <rth@twiddle.net>,
        ink@jurassic.park.msu.ru, Matt Turner <mattst88@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>
Date: Thu, 17 Jul 2014 20:21:33 -0700
In-Reply-To: <CAPDOMViHhE22ndcjez+vfZWGprsx_Cw0Rn-FpaoNsi63cRnr9g@mail.gmail.com>
References: <CAPDOMVgJx4NTSDXyS4k9jfWzSw_vJ=TFDBPdCUgxa-Xato1bYA@mail.gmail.com>
	 <alpine.DEB.2.10.1407180013260.24854@nanos>
	 <CAPDOMViHhE22ndcjez+vfZWGprsx_Cw0Rn-FpaoNsi63cRnr9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 23:01 -0400, Nick Krause wrote:
> On Thu, Jul 17, 2014 at 6:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 17 Jul 2014, Nick Krause wrote:
> >
> >> Hey Richard and other Maintainers,
> >> I am wondering about cleaning up the cleanpatch errors for alpha,  as
> >> I  am hitting a lot of in the arch/alpha directory.
> >> It would be nice if I got a list of files that still need coding style
> >> cleanup as this may be of nice to cleanup :).
> >
> > Nick, can you please stop that nonsense? checkpatch.pl is a tool to
> > check PATCHES and not to apply random nonsense on existing code. See
> > also:
> >
> >   https://lwn.net/Articles/605597/
> >
> > Joe, can you please finally remove the -f option from checkpatch.pl ?
> >
> > Thanks,
> >
> >         tglx
> I understand how about checkpatch. We should remove the -f option as I
> agree it gets used too much.
> Sorry Nick

Nick, are you human?

