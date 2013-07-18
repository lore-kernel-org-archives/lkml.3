Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab3GRNaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:30:25 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38944 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3GRNaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:30:22 -0400
Date: Thu, 18 Jul 2013 09:30:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: CAI Qian <caiqian@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Maybe it's time to shut this thread down (Was: Re: [ 00/19]
 3.10.1-stable review)
Message-ID: <20130718133008.GC30405@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	CAI Qian <caiqian@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable <stable@vger.kernel.org>,
	Darren Hart <dvhart@linux.intel.com>,
	ksummit-2013-discuss@lists.linux-foundation.org
References: <20130715155202.GC29526@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <alpine.DEB.2.02.1307172336410.4089@ionos.tec.linutronix.de>
 <1368728064.2419741.1374117402465.JavaMail.root@redhat.com>
 <1374119254.6458.220.camel@gandalf.local.home>
 <305037674.2433057.1374120078349.JavaMail.root@redhat.com>
 <20130718132327.GB30405@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718132327.GB30405@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason why I started the kernel summit over ten years ago
was because there were certain topics that are much better discussed
in person, and that over time, if we don't have sufficient face to
face interactions, the quality of e-mail discussions can start to
become frayed.

One of the reasons is that e-mail is just not as expressive a medium
as face-to-face conversations.  As a result, when people feel that
they aren't being heard, because they aren't getting those critical
non-verbal cues, they start escalating.  They start using stronger
words, such as F*CK.  They start doing exactly what they claim to
abhor to their verbal opponents in the debate, which is describing
their fellow kernel developers using demeaning terms.  They start
using loaded, and over-reaching words, like "abuse", which ultimately
ends up hurting their own case.

I suspect this is happening because it's easy when a body feels that
their message of say, "could we please treat each other with more
respect", isn't getting heard, it's very easy and very tempting to
resort to "Linus is an AB-UUUUUUUU-SER!".

May I make the polite suggestion (and we'll see how well polite
requests get honored via e-mail), that we take this discussion
off-line, and wait to try to discuss this in person at the Kernel
Summit?

Regards,

						- Ted
