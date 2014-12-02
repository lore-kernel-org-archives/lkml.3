Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbaLBWQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:16:31 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:35363 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbaLBWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:16:29 -0500
Message-ID: <547e3a3b.a45c8c0a.655b.0cbc@mx.google.com>
Date: Tue, 2 Dec 2014 20:16:23 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 14:10:33 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So it appears that you can recreate this much more quickly than DaveJ
> can recreate his issue.
> 
> The two issues may be entirely unrelated, but the it is certainly
> quite possible that they have some relation to each other, and the
> timing is intriguing, in that 3.17 seems to be the first kernel
> release this happened in.
> 
> So at this point I think I'd ask you to just go back to your bisection
> that you apparently already started earlier. I take it 3.16 worked
> fine, and that's what you used as the good base for your bisect?
> 
> Even if it's something else than what DaveJ sees (or perhaps
> *particularly* if it's something else), bisecting when it started
> would be very worthwhile.
> 
> There's 13k+ commits in between 3.16 and 3.17, so a full bisect should
> be around 15 test-points. But judging by the timing of your emails,
> you can generally reproduce this relatively quickly..

	No problem Linus. I'll try the full bisect and I post here
later with the final result.

-- 
Linux 3.17.0-dirty: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
