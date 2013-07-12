Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab3GLPr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:47:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab3GLPr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:47:27 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=IGoSpHfCR_l--EN0JgcA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373644044.17876.92.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Fri, 12 Jul 2013 11:47:24 -0400
In-Reply-To: <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com>
	 <20130712141530.GA3629@roeck-us.net>
	 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 08:22 -0700, Linus Torvalds wrote:

> Listen to yourself. In fact, there is a damn good solution": don't
> mark crap for stable, and don't send crap to me after -rc4.
> 

I tend to hold things off after -rc4 because you scare me more than Greg
does ;-)


Actually, as I consider tracing a second class citizen, the things that
I tend not to send you, but instead mark for stable, are things that can
cause events to be dropped, or just incorrect trace data. Like a
tracepoint saying preemption is off when it is enabled. If I find a bug
that can cause some minor incorrect trace data to occur, and its after
-rc4, I tend to just mark it with a stable tag and wait for the merge
window to occur. I don't mean regressions either. Usually, the incorrect
data comes from something new for that release, or something that's been
there forever (like commit 11034ae9c20f4057a6127fc965906417978e69b2).

Should those be sent to you late in the game as well? 

For the 3.11 merge window, I had quite a bit of stable tags, but those
were commits that I would have sent to you but they were found very
late, and by the time I was satisfied with the test output, you had
already opened the window.

-- Steve


