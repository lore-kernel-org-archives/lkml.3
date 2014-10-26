Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaJZOlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:41:40 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52546 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJZOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:41:39 -0400
Message-ID: <1414334494.5304.43.camel@marge.simpson.net>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Sun, 26 Oct 2014 15:41:34 +0100
In-Reply-To: <20141026141144.GA22911@sesse.net>
References: <20141003194428.GA27084@sesse.net>
	 <1412782664.5179.75.camel@marge.simpson.net>
	 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
	 <1412791184.5173.11.camel@marge.simpson.net>
	 <alpine.DEB.2.11.1410241724370.5308@nanos>
	 <1414168721.5308.3.camel@marge.simpson.net>
	 <20141026103918.GA5259@sesse.net>
	 <1414329375.5304.20.camel@marge.simpson.net>
	 <1414331916.5304.23.camel@marge.simpson.net>
	 <20141026141144.GA22911@sesse.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-26 at 15:11 +0100, Steinar H. Gunderson wrote: 
> On Sun, Oct 26, 2014 at 02:58:36PM +0100, Mike Galbraith wrote:
> > Can you try the below?
> 
> I can bake it into the kernel the next time I boot, but that is unlikely to
> be anytime soon, I'm afraid. I'm maybe a bit surprised nobody else can
> reproduce my issue; I assume it won't help if I give out shell access
> somehow.

Sure it would, any bug I can get my hands on, I can toss rocks and
sticks at until one of us gives up :)  Trouble is me having time to go
play with your box, and you trusting me to not do naughty things while
there, /me nearly always being in godmode (permission denied allergy),
that would be a problem.

-Mike



