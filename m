Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3HXSqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:46:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48324 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab3HXSq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:46:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Aug 2013 20:45:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Willy Tarreau <w@1wt.eu>, Josh Boyer <jwboyer@fedoraproject.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130824204526.39a85312@stein>
In-Reply-To: <20130821105459.0b392711@gandalf.local.home>
References: <20130820224032.GA20491@kroah.com>
	<CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
	<20130820235700.GA7209@kroah.com>
	<CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
	<20130821134248.GB16493@home.goodmis.org>
	<20130821141725.GB20685@1wt.eu>
	<20130821105459.0b392711@gandalf.local.home>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 21 Steven Rostedt wrote:
> I guess the other question to ask is, how long does it take for a
> problem to appear after hitting mainline? If a problem is found in -rc4
> before -rc5 comes out, then this would be sufficient. But if the
> problem from -rc4 isn't found till -rc6 then that tells us something
> too.

The estimate of one or two RC periods applies to hardware/ workloads which
everyone has or which wasn't supported by the previous release.  For less
widely used hardware/ workloads which has been supported for years already,
it's more like between 2.5 months ( = a mainline kernel release period)
and more than a year ( = two release periods of typical distributions).
-- 
Stefan Richter
-=====-===-= =--- ==---
http://arcgraph.de/sr/
