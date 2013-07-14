Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3GNCWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 22:22:31 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37565 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3GNCW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 22:22:29 -0400
Date: Sat, 13 Jul 2013 22:22:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130714022219.GC3112@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Willy Tarreau <w@1wt.eu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable <stable@vger.kernel.org>
References: <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
 <20130713063607.GI32054@1wt.eu>
 <20130713064801.GA1305@kroah.com>
 <20130713114211.GA3112@thunk.org>
 <20130713182717.GA16637@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713182717.GA16637@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 11:27:17AM -0700, Greg Kroah-Hartman wrote:
> Ugh, the conversation has degenerated now into parsing the meaning of
> specific words.  This is why lawyers have created whole vocabularies
> that are not used by "normal" people.  There's a very good reason why
> I'm not a lawyer, and this is one of them...
> 
> If I change the word "critical" to "real", would that make everyone
> happy here?
> 
> It comes down to the simple fact that for stable kernels I _want_ to
> take bugfixes that any user would hit.  In other words, something that a
> distro kernel would take.

Yes, but ***Linus*** has said he only wants critical fixes in his tree
after -rc4.  It seems pretty clear that what he wants post -rc4 and
what you want in the stable tree are different.

You can change the stable_kernel_tree to be "real" bugs, but if Linus
is still using "critical" as the standard for mainline post-rc4, then
those of us who are maintainers are stuck between a rock and a hard
place.

So it's not a matter of maintainers trying to lawyer the meaning of
words, but that you and Linus have different criteria of what you feel
should be sent to mainline after -rc4.  And sorry, it's Linus's
kernel, so I'm going to follow what appears to be Linus's criteria.


If you and Linus can't come up with an the same set of criteria, all I
can do is to not send non-regression/non-critical, fixes post -rc4 (so
Linus doesn't yell at me), and not mark non-critical bug fixes (even
if distro kernels would want them) for stable (so you don't yell at me
for not pushing them to Linus).  What I'll probably do is mark them
with "Fixes: v3.x" tag, and then I'll have to create my own scripts to
send patches to stable@vger.kernel.org a week or two after Linus has
released the 3.y.0 kernel.

Regards,

					- Ted
