Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaJZKj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 06:39:29 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:35810 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaJZKj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 06:39:28 -0400
Date: Sun, 26 Oct 2014 11:39:18 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
Message-ID: <20141026103918.GA5259@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <1412782664.5179.75.camel@marge.simpson.net>
 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
 <1412791184.5173.11.camel@marge.simpson.net>
 <alpine.DEB.2.11.1410241724370.5308@nanos>
 <1414168721.5308.3.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414168721.5308.3.camel@marge.simpson.net>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 06:38:41PM +0200, Mike Galbraith wrote:
>>> Whew, good, futex.c is hard.  Heads up chess guys <punt>. 
>> I wonder whether the barrier fix which got into 3.17 late fixes that
>> issue as well.
> Yes, it did.

This is only about the lockup, right, not that the threads bounce around a
lot and make things slower?

/* Steinar */
-- 
Homepage: http://www.sesse.net/
