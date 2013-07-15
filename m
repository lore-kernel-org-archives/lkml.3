Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3GOTj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:39:59 -0400
Received: from 1wt.eu ([62.212.114.60]:34670 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab3GOTj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:39:58 -0400
Date: Mon, 15 Jul 2013 21:39:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130715193939.GD10157@1wt.eu>
References: <20130715155202.GC29526@xanatos> <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com> <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu> <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwHEn4ktPoM2dWkkx9VPg1HbjG4EYCRGfoLEKRSz_y8zw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 12:23:05PM -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 12:17 PM, Willy Tarreau <w@1wt.eu> wrote:
> >
> > BTW, I was amazed that you managed to get him have a much softer tone inr
> > his last e-mail, you probably found a weakness here in his management
> > process :-)
> 
> Hey, I _like_ arguing, and "cursing" and "arguing" are actually not at
> all the same thing.
> 
> And I really don't tend to curse unless people are doing something
> stupid and annoying. If people have concerns and questions that I feel
> are valid, I'm more than happy to talk about it.

Oh I know, you've even kindly helped me a few times backporting fixes for
things I absolutely did not understand and took the time to explain to me.
So I have nothing against your communication mode, quite the opposite, and
people who know me know that mine has some similarities (a bit less extreme
in wording though). I'm used to say that I prefer to discuss with people who
I disagree with because they're those from whom there is more to learn, and
they're the most likely to make me change my opinions.

> I curse when there isn't any argument. The cursing happens for the
> "you're so f*cking wrong that it's not even worth trying to make
> logical arguments about it, because you have no possible excuse" case.
> 
> .. and sometimes people surprise me and come back with a valid excuse
> after all. "My whole family died in a tragic freak accident and my
> pony got cancer, and I was distracted".

Not a valid excuse, the patch should not have been sent in the first
place :-)

Willy

