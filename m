Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbaGRDYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:24:48 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:39490 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759663AbaGRDYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:24:46 -0400
MIME-Version: 1.0
In-Reply-To: <1405653693.21735.9.camel@buesod1.americas.hpqcorp.net>
References: <CAPDOMVgJx4NTSDXyS4k9jfWzSw_vJ=TFDBPdCUgxa-Xato1bYA@mail.gmail.com>
	<alpine.DEB.2.10.1407180013260.24854@nanos>
	<CAPDOMViHhE22ndcjez+vfZWGprsx_Cw0Rn-FpaoNsi63cRnr9g@mail.gmail.com>
	<1405653693.21735.9.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 17 Jul 2014 23:24:45 -0400
Message-ID: <CAPDOMVh-gtvTP6OY_fM31NcM_ez==f1fBNgV_YaoSXuQcUtiRQ@mail.gmail.com>
Subject: Re: Alpha Checkpatch Errors
From: Nick Krause <xerofoify@gmail.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Richard Henderson <rth@twiddle.net>,
        ink@jurassic.park.msu.ru, Matt Turner <mattst88@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:21 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Thu, 2014-07-17 at 23:01 -0400, Nick Krause wrote:
>> On Thu, Jul 17, 2014 at 6:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Thu, 17 Jul 2014, Nick Krause wrote:
>> >
>> >> Hey Richard and other Maintainers,
>> >> I am wondering about cleaning up the cleanpatch errors for alpha,  as
>> >> I  am hitting a lot of in the arch/alpha directory.
>> >> It would be nice if I got a list of files that still need coding style
>> >> cleanup as this may be of nice to cleanup :).
>> >
>> > Nick, can you please stop that nonsense? checkpatch.pl is a tool to
>> > check PATCHES and not to apply random nonsense on existing code. See
>> > also:
>> >
>> >   https://lwn.net/Articles/605597/
>> >
>> > Joe, can you please finally remove the -f option from checkpatch.pl ?
>> >
>> > Thanks,
>> >
>> >         tglx
>> I understand how about checkpatch. We should remove the -f option as I
>> agree it gets used too much.
>> Sorry Nick
>
> Nick, are you human?
>
Yes I am human. Now thinking about it we need it to test for staging.
Stupid idea.
Nick
