Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3GMPya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 11:54:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3GMPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 11:54:29 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=J5VL0BaurVHM6uO_cdMA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373730866.17876.139.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Jochen Striepe <jochen@tolot.escape.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Sat, 13 Jul 2013 11:54:26 -0400
In-Reply-To: <20130713151048.GB31035@redhat.com>
References: <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	 <20130712173150.GA5534@roeck-us.net>
	 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
	 <20130712181103.GA6689@roeck-us.net> <20130712193557.GB342@thunk.org>
	 <1373658551.17876.117.camel@gandalf.local.home>
	 <20130712201939.GB15261@redhat.com>
	 <1373660900.17876.124.camel@gandalf.local.home>
	 <20130713004707.GF7609@pompeji.miese-zwerge.org>
	 <1373713889.17876.135.camel@gandalf.local.home>
	 <20130713151048.GB31035@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 11:10 -0400, Dave Jones wrote:
> On Sat, Jul 13, 2013 at 07:11:29AM -0400, Steven Rostedt wrote:
> 
>  > > Users expect vanilla .0 releases usable as production systems, to
>  > > be updated (meaning, no new features, just stabilizing) with the
>  > > corresponding -stable series.
>  > 
>  > This really is a case by case basis. An unprivileged user exploit
>  > requires a box that lets other users than the owner of the box to log
>  > in. Most users of .0 releases do not do this.
> 
> local exploits aren't just a problem for multi-user machines.
> An attacker who can own your firefox process, can now potentially
> escalate to root.  (Ok, most exploits are just crashing the box,
> but how many times have we been proven wrong in the past when we
> thought something was just a DoS, and someone smarter has found
> a way to turn it into a root-hole?)

Of course I don't want to lower the importance of such a fix. But making
sure the fix works and not rushed out is important too. It really is a
case by case basis. Some bugs should get out to mainline and stable
quickly, but a lot of them should also be verified to work before
rushing to get them out the door. And verification does take a bit of
time. The last thing we want a fix to do is to create a bug that could
potentially be worse than the one being fixed.

-- Steve


