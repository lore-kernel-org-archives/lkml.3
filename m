Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3ICHfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:35:07 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:37725 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3ICHfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:35:05 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <dave.bueso@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Subject: Re: ipc-msg broken again on 3.11-rc7?
Thread-Topic: ipc-msg broken again on 3.11-rc7?
Thread-Index: AQHOpZ5oa2zPW4yZMkWQwZduFtEUDA==
Date: Tue, 3 Sep 2013 07:34:53 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514160B@IN01WEMBXA.internal.synopsys.com>
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com>
	<1372192414.1888.8.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUXgOd=URJBH5MGAZKdvdkMpFt+5mRxtzuDzq_vFHpoc2A@mail.gmail.com>
	<1372202983.1888.22.camel@buesod1.americas.hpqcorp.net>
	<521DE5D7.4040305@synopsys.com>
	<CA+icZUUrZG8pYqKcHY3DcYAuuw=vbdUvs6ZXDq5meBMjj6suFg@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA23075140FA3@IN01WEMBXA.internal.synopsys.com>
	<CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
	<52205597.3090609@synopsys.com>
	<CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com>
	<CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com>
	<CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com>
	<CA+55aFy8tbBpac57fU4CN3jMDz46kCKT7+7GCpb18CscXuOnGA@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230751413F4@IN01WEMBXA.internal.synopsys.com>
	<5224BCF6.2080401@colorfullife.com>
 <CA+icZUVc6fhW+TTB56x68LooS8DqhA8n3CQzgKkXQmbyH+ryUQ@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 12:46 PM, Sedat Dilek wrote:
> Just FYI:
>
> Linux Testing Project (LTP) will do a new release in the 1st September week.
> Some IPC test-suites were reworked.
> Manfred can you look at them ("...msgctl08 uses one queue for each
> thread pair.").
> ( Might be worth to throw some words at the LTP mailing-list (that
> test-case is not ideal, etc.)? )
>

Well we had a userspace test working before (3.10) and now it won't. In Linux
world that is not something we do in general - although there could be exceptions
because the test is not idea etc - anyways not my call !

However assuming we are going ahead with debugging this - can you please confirm
whether you see the issue on x86 as well as I have not tested that ? I vaguely
remember one of your earlier posts suggested you did

Thx,
-Vineet


