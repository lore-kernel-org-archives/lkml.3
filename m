Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3HUOUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:20:54 -0400
Received: from 1wt.eu ([62.212.114.60]:35490 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3HUOUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:20:52 -0400
Date: Wed, 21 Aug 2013 16:17:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821141725.GB20685@1wt.eu>
References: <20130820224032.GA20491@kroah.com> <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com> <20130820235700.GA7209@kroah.com> <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com> <20130821134248.GB16493@home.goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821134248.GB16493@home.goodmis.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:42:48AM -0400, Steven Rostedt wrote:
> Personally, I still let my stable patches that go into later -rc sit
> in linux-next for a few days before pushing them to mainline. I may even
> wait for the next -rc to push it just to make sure the patch wont cause
> more issues. But I know others that just send the fix directly to
> mainline without going through linux-next. Those, I would think, are the
> most prone to cause issues in stable.

This is also what I suspected though I have no data to confirm or deny that.
If this happens to be the case, maybe then there should be some barrier such
as :
  - everything merged at -rc4 or before gets backported after the next -rc
  - everything from -rc5 and upper waits for next -rc1 unless tagged urgent ?

Willy

