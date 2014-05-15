Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaEOQaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:30:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaEOQaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:30:08 -0400
Date: Thu, 15 May 2014 18:30:04 +0200
From: chrubis@suse.cz
To: Darren Hart <dvhart@linux.intel.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515163004.GB7959@rei.Home>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
 <CF9A3521.90ECC%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF9A3521.90ECC%dvhart@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> I've used LTP in the past (quite a bit), and I felt there was some
> advantage to keeping futextest independent.

What advantages did you have in mind?

> Perhaps things have changed enough since then (~2009 era) that we
> should reconsider.

I've been working on LTP for a about three years now and we happen to do
quite a lot in that time. The most visible changes would be more proper
development practices (git, proper build system, code review, LKML
coding style, documentation, ...) and also huge number of fixes. Now we
are trying to catch up in coverage too.

> We can discuss the pros/cons there if you like.

I would love to :).

> I have agreed to move the performance related tests over to perf, and
> Davidlohr has added some other such tests to perf. Trinity now covers
> the planned fuzz testing for futexes (very well... Obviously) so that
> idea will be dropped, leaving pure functional tests in futextest.

Well LTP mostly consists of functional tests, so that would fit the
purpose very well.

-- 
Cyril Hrubis
chrubis@suse.cz
