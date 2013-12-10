Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3LJWIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:08:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab3LJWIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:08:14 -0500
Date: Tue, 10 Dec 2013 17:07:22 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210220721.GC5050@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Darren Hart <dvhart@linux.intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
References: <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
 <CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
 <20131210213201.GF27373@redhat.com>
 <CA+55aFzkoqH5d3Ya9adqdmgZgZEsuZqTFfevor5k6M99HMF9=Q@mail.gmail.com>
 <20131210215618.GA5050@redhat.com>
 <CA+55aFyMS7HOq8WHqctqVyQmcseP2AVqut9rgRKu-uZEsBNpxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyMS7HOq8WHqctqVyQmcseP2AVqut9rgRKu-uZEsBNpxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:59:30PM -0800, Linus Torvalds wrote:
 > On Tue, Dec 10, 2013 at 1:56 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Hmm, the only vmlinux I have still around is newer than the running kernel,
 > > so that's not going to be much help.
 > 
 > Ok, /proc/kallsyms would do it, but never mind. I think you already
 > pinpointed where the loop is with the trace file, so no need for
 > trying to decode the profile.

just for completeness in case someone else is following along and prefers to try that:
http://www.codemonkey.org.uk/junk/syms

	Dave


