Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab3GPSSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:18:53 -0400
Received: from 1wt.eu ([62.212.114.60]:34720 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab3GPSSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:18:52 -0400
Date: Tue, 16 Jul 2013 20:18:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Darren Hart <dvhart@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130716181818.GG15902@1wt.eu>
References: <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com> <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu> <20130716084036.41a9c498@notabene.brown> <20130716061341.GD12242@1wt.eu> <1373989215.12825.25.camel@envy.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373989215.12825.25.camel@envy.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

On Tue, Jul 16, 2013 at 08:40:15AM -0700, Darren Hart wrote:
> On Tue, 2013-07-16 at 08:13 +0200, Willy Tarreau wrote:
> 
> > It can seem counter-producting first (as Sarah thinks) but I think that
> > the competent people find their way in this simply because they're backed
> > up by other ones. That's how I think we get that number of skilled people
> > at the top of each subsystem.
> > 
> 
> Hi Will,
> 
> I think you've made some excellent points and have done a good job
> relating the mostly digital interactions to more direct and tangible
> ones.
> 
> You have postulated (I believe) that because we have top-quality
> maintainers (and I agree, we do), the process must be working. Perhaps
> that was my interpretation and not your intent, but others have voiced
> such opinions as well, so the following is still relevant.
> 
> What that argument fails to take into account are the top-quality
> maintainers and contributors who are not present because of the
> sometimes caustic environment of Linux kernel development: "survivor's
> bias".

No, I'm not forgetting this, and I'm sure this is a fact. We don't have
that many shy people here I think. But the question would probably better
be "are the efforts and implications of adopting a softer communication
worth the gain of getting a few more talented people ?". I don't have the
response to this question, but for sure many things would change, some
current developers would not follow, release cycles would extend, but
maybe we'd get a slightly higher quality each time, who knows. Also, too
shy people rarely propose improvements, even if they tend to have the
greatest ideas since they spend more time thinking than talking. What I'm
sure about however is that the two models are incompatible, and breaking
one which works to try another one seems suicidal. And Linus would probably
suggest "try it, fork the kernel, build a team and manage it your way".

All in all, I think the best thing to do would be to improve the processes
so that it becomes much clearer for everyone so that newcomers are less
afraid of it and do less mistakes. With a smoother process we can expect
a higher quality from everyone and in turn reduce the risk that Linus
shouts too often. Everyone will benefit from this in the end. I'm not
the best placed to propose improvements, I'm not suffering from the
process, so let's hope that people who are unhappy with it will explain
their concerns in great details.

> There is a great article on the subject I read recently here:
> 
> http://youarenotsosmart.com/2013/05/23/survivorship-bias/

Seems interesting but very long, I'll have to read it later ! Thanks for
the link anyway.

Willy

