Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3GMPLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 11:11:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab3GMPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 11:11:15 -0400
Date: Sat, 13 Jul 2013 11:10:48 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jochen Striepe <jochen@tolot.escape.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713151048.GB31035@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jochen Striepe <jochen@tolot.escape.de>,
	Theodore Ts'o <tytso@mit.edu>, Guenter Roeck <linux@roeck-us.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable <stable@vger.kernel.org>
References: <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712181103.GA6689@roeck-us.net>
 <20130712193557.GB342@thunk.org>
 <1373658551.17876.117.camel@gandalf.local.home>
 <20130712201939.GB15261@redhat.com>
 <1373660900.17876.124.camel@gandalf.local.home>
 <20130713004707.GF7609@pompeji.miese-zwerge.org>
 <1373713889.17876.135.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373713889.17876.135.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 07:11:29AM -0400, Steven Rostedt wrote:

 > > Users expect vanilla .0 releases usable as production systems, to
 > > be updated (meaning, no new features, just stabilizing) with the
 > > corresponding -stable series.
 > 
 > This really is a case by case basis. An unprivileged user exploit
 > requires a box that lets other users than the owner of the box to log
 > in. Most users of .0 releases do not do this.

local exploits aren't just a problem for multi-user machines.
An attacker who can own your firefox process, can now potentially
escalate to root.  (Ok, most exploits are just crashing the box,
but how many times have we been proven wrong in the past when we
thought something was just a DoS, and someone smarter has found
a way to turn it into a root-hole?)

	Dave
