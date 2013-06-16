Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3FPDO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 23:14:26 -0400
Received: from ozlabs.org ([203.10.76.45]:39354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab3FPDOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 23:14:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Julia Lawall <julia.lawall@lip6.fr>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Meyer <thomas@m3y3r.de>, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
In-Reply-To: <alpine.DEB.2.02.1306130955380.2260@hadrien>
References: <1370080565.29224.29.camel@localhost.localdomain> <87mwr8sz9g.fsf@rustcorp.com.au> <20130603071526.GA5483@pengutronix.de> <alpine.DEB.2.02.1306082305220.1968@localhost6.localdomain6> <87mwquzkvf.fsf@rustcorp.com.au> <20130613073046.GB10326@redhat.com> <alpine.DEB.2.02.1306130955380.2260@hadrien>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 16 Jun 2013 12:14:11 +0930
Message-ID: <87ehc2rczo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia.lawall@lip6.fr> writes:
> On Thu, 13 Jun 2013, Michael S. Tsirkin wrote:
>
>> On Thu, Jun 13, 2013 at 02:07:40PM +0930, Rusty Russell wrote:
>> > I think using PTR_ERR() is a less bad solution than promoting PTR_RET,
>> > which has a non-obvious name.
>>
>> Will a longer name make the function more obvious?
>> 	PTR_ERR_OR_ZERO() ?
>> 	PTR_ERR0() ?
>> PTR_ERR() can then stay simple for cases where we know we
>> are on the error path.
>
> I was thinking of something along those lines.  And in that case, PTR_ERR
> could stay without the additional test.
> julia

OK, sold :)

Will send out a series now with PTR_ERR_OR_ZERO.

Thanks,
Rusty.
