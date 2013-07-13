Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3GMBPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 21:15:01 -0400
Received: from oker.escape.de ([194.120.234.254]:48529 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab3GMBO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 21:14:59 -0400
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jul 2013 21:14:58 EDT
Date: Sat, 13 Jul 2013 02:47:07 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713004707.GF7609@pompeji.miese-zwerge.org>
References: <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712181103.GA6689@roeck-us.net>
 <20130712193557.GB342@thunk.org>
 <1373658551.17876.117.camel@gandalf.local.home>
 <20130712201939.GB15261@redhat.com>
 <1373660900.17876.124.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373660900.17876.124.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

On Fri, Jul 12, 2013 at 04:28:20PM -0400, Steven Rostedt wrote:
> I would suspect that machines that allow unprivileged users would be
> running distro kernels, and not the latest release from Linus, and thus
> even a bug that "can allow an unprivileged user to crash the kernel" may
> still be able to sit around for a month before being submitted.
> 
> This wouldn't be the case if the bug was in older kernels that are being
> used.

On the one hand, you seem to want users with any kind of production
systems to use distro kernels. On the other hand, developers want
a broad testing base, with vanilla kernels (or better, rc) as early
as possible. You cannot get both at the same time, some kinds of bugs
just appear on production systems.

Users expect vanilla .0 releases usable as production systems, to
be updated (meaning, no new features, just stabilizing) with the
corresponding -stable series.

Just my 2p,
Jochen.
