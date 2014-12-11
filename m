Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967414AbaLKW6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:58:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39013 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967309AbaLKW60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:58:26 -0500
Message-ID: <548A2165.9030107@oracle.com>
Date: Thu, 11 Dec 2014 17:57:41 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141201230339.GA20487@ret.masoncoding.com>	<1417529606.3924.26.camel@maggy.simpson.net>	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>	<1417540493.21136.3@mail.thefacebook.com>	<20141203184111.GA32005@redhat.com>	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>	<20141205171501.GA1320@redhat.com>	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>	<1417806247.4845.1@mail.thefacebook.com>	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>	<20141211145408.GB16800@redhat.com>	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>	<548A122C.8000906@oracle.com> <CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com>
In-Reply-To: <CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 05:36 PM, Linus Torvalds wrote:
> On Thu, Dec 11, 2014 at 1:52 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > Is it possible that Dave and myself were seeing the same problem after
>> > all?
> Could be. You do have commonalities, even if the actual symptoms then
> differ. And while it looked different when you could trigger it with
> 3.16 but DaveJ couldn't, that's up in the air now that I doubt that
> 3.16 really is ok for DaveJ after all..
> 
> And you might have a better luck bisecting it, since you seem to be
> able to trigger your RCU lockup much more quickly (and apparently
> reliably? Correct?)

Right, and it reproduces in 3.10 as well, so it's not really a new thing.

What's odd is that I don't remember seeing this bug so long in the past,
I'll try bisecting trinity rather than the kernel - it's the only other
thing that changed.


Thanks,
Sasha
