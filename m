Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbaK1KZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:25:58 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63186 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaK1KZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:25:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Date: Fri, 28 Nov 2014 11:25:45 +0100
Message-ID: <2351041.YbSYt1FKtz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54784209.6070003@atmel.com>
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <27354361.uIQEXGDqXb@wuerfel> <54784209.6070003@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:r0V/a61xUhq0xLJ14eUx2wYSQjFeCeNl1aROFfflL/f
 6u/o98HijRyCWmA/qju+oAomzes6pS+iyh5aQWpnEfCr6PxAns
 CnJ94rbcyqGlTeWSaYHWBA23HI+TKwolKpeo5qQLXzpDizFSXY
 PyRF5XO6bZ0aRUi1gG9ODQ9/GfQZRTrfDdWzriSTgZU9kMUk3d
 L8207ICdgeQciQdw/x26Du4jIL3Qxqy6lec2ckGY8DnEnPrg+D
 tflQ0idYp+LZwKhdZMfUeLPaKl20HxCl4H/M7J3I+8KmTqROxV
 Yy9eXIRqPbNNdRaB0dcZ5FkORVhcU4qm8774F4DekZCno3ynVj
 Fr/7JC04OvDgQE1+ZWlw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 10:36:09 Nicolas Ferre wrote:
> On 27/11/2014 18:38, Arnd Bergmann wrote:
> > On Thursday 27 November 2014 18:12:43 Alexandre Belloni wrote:
> >> On 27/11/2014 at 17:49:50 +0100, Arnd Bergmann wrote :
> >>> On Thursday 27 November 2014 17:06:28 Nicolas Ferre wrote:
> >>>> This is the last series of patches that removes the non-Device-Tree board
> >>>> support for older Atmel SoCs.
> >>>> Again, for the record, it was announced here
> >>>> https://lkml.org/lkml/2014/9/10/293 ([ANNOUNCE] ARM: at91: removal of board
> >>>> files) two months ago.
> >>>> Several files beyond at91rm9200 are touched this time as I tried to remove the
> >>>> biggest parts that were related to !DT SoC initializations. More cleanup is
> >>>> certainly needed to remove dead code.
> >>>>
> >>>> The diffstat is also pretty big as a lot of at91rm9200 boards were remaining.
> >>>>
> >>>
> >>> Awesome stuff!
> >>>
> >>> Two questions:
> >>>
> >>> - is anything holding this up from getting merged in 3.19?
> >>>
> >>
> >> If you think this is not too late in the cycle, I would say go ahead 
> > 
> > I'd say we should do it, unless there are last-minute regressions.
> 
> Arnd,
> 
> I am totally in favor for a merge into 3.19.
> I wanted to wait one day or two but given that the official announce had
> been made several months ago, I don't think it makes a big difference.
> 
> So, what do you prefer:
> 
> 1/ I wait today and send you the pull-request this evening (our time)
> 2/ I send you the pull-request at the beginning of next week but still
> can make it for 3.19?

Just send the pull request whenever you have it ready. If some bug shows
up, reply to that mail with an updated pull request.

> (BTW, in the meantime, there is a pending pull-request (at91-cleanup3)
> but it is true that you needn't pulling it in if you plan to take this
> one which will be named at91-cleanup4 and that will obviously contain
> the 3rd one).

Yes, I have a backlog of pull requests to look at, should get to that soon
today.

	Arnd
