Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3GOCIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 22:08:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:57240 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3GOCIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 22:08:22 -0400
Message-ID: <1373854080.19894.322.camel@pasglop>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Mon, 15 Jul 2013 12:08:00 +1000
In-Reply-To: <CA+55aFx7Lax+m6wvPyfu_Om2aL-gYBEmfcrEqiC_nqCm1pwW6Q@mail.gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com>
	 <20130712141530.GA3629@roeck-us.net>
	 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	 <20130712173150.GA5534@roeck-us.net>
	 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
	 <1373845958.19894.320.camel@pasglop>
	 <CA+55aFx7Lax+m6wvPyfu_Om2aL-gYBEmfcrEqiC_nqCm1pwW6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-14 at 18:40 -0700, Linus Torvalds wrote:
> Not before it's been in the distro, no. Something like a PCI change
> *definitely* should never be marked for stable, unless it causes
> crashes or is a _new_ regression that causes dead machines.
> 
> Because the likelihood that that 4-5 line "obvious" change breaks
> things is pretty high. It needs testing elsewhere - on the machines
> that weren't broken - in a big way first.
> 
> And don't bother talking about "obvious fix". Especially not when it
> comes to the PCI code.

PCI resource allocation code for sure. A bug specific to the hotplug
code path not so ... (for example, a too short reset delay or shit like
that). I agree with you overall but there's still a judgement call
happening at some point I assume and we get at least *some* flexibility
as maintainers as to what we want going there or not right ? :-)

Cheers,
Ben.


