Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaLBROQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:14:16 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33302 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaLBROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:14:14 -0500
Message-ID: <547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
Date: Tue, 2 Dec 2014 15:14:08 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141202170407.GK25340@linux.vnet.ibm.com>
References: <20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 09:04:07 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Is it harder to reproduce with CONFIG_PREEMPT=y and CONFIG_TREE_PREEMPT_RCU=n?

	Yes, it's much harder! :)

> If it is a -lot- harder to reproduce, it might be worth bisecting among
> the RCU read-side critical sections.  If making a few of them be
> non-preemptible greatly reduces the probability of the bug occuring,
> that might provide a clue about root cause.
> 
> On the other hand, if it is just a little harder to reproduce, this
> RCU read-side bisection would likely be an exercise in futility.

	Ok, I want to bisect it. Since it could be painful to bisect,
could you suggest 2 commits between 3.16.0 and 3.17.0 so we can narrow
the bisect? I could just bisect between 3.16.0 and 3.17.0 but it would
take many days :).

	Ps: if you prefer I bisect between 3.16.0 and 3.17.0, no
problem, but you'll have to be patient ;).

-- 
Linux 3.17.0-dirty: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
