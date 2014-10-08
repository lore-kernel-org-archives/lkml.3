Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaJHRFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:05:22 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:54542 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbaJHRFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:05:20 -0400
Date: Wed, 8 Oct 2014 19:05:13 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
Message-ID: <20141008170513.GA13720@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <1412782664.5179.75.camel@marge.simpson.net>
 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:04:01PM -0400, Linus Torvalds wrote:
> So like Thomas, I would suspect a race condition in the futex use, and
> then the exact futex implementation details are just exposing it
> incidentally.

FWIW, Stockfish does not use futex directly; it uses pthreads (or Win32
threads if you are on that OS :-) ). That doesn't preclude a race condition
somewhere, of course.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
