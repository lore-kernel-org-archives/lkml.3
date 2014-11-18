Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbaKRVba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:31:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494AbaKRVb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:31:28 -0500
Date: Tue, 18 Nov 2014 16:31:13 -0500
From: Dave Jones <davej@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141118213113.GA31432@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <CA+55aFxttmjXJX4wtwSpTOdDCMwpSopAsL3MJ1n8mJSJOEpyhQ@mail.gmail.com>
 <alpine.DEB.2.11.1411182023360.3909@nanos>
 <20141118212553.GX108701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212553.GX108701@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 04:25:53PM -0500, Don Zickus wrote:
 
 > I was going to reply about both points too. :-)  Though the mangling looks
 > odd because we have spin_locks serializing the output for each cpu.
 > 
 > Another thing I wanted to ask DaveJ, did you recently turn on
 > CONFIG_PREEMPT?  That would explain why you are seeing the softlockups
 > now.  If you disable CONFIG_PREEMPT does the softlockups disappear.

I've had it on on my test box forever.  I'll add trying turning to off
to the list of things to try.

	Dave
