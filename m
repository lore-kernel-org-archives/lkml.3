Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508Ab3GSKfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:35:51 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43306 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965089Ab3GSKfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:35:47 -0400
Date: Fri, 19 Jul 2013 12:35:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        "Hohndel, Dirk" <dirk.hohndel@intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130719103542.GB26716@gmail.com>
References: <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
 <20130715174659.GC15531@xanatos>
 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <alpine.DEB.2.02.1307172336410.4089@ionos.tec.linutronix.de>
 <20130718154814.GA5440@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718154814.GA5440@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

> On Thu, Jul 18, 2013 at 02:42:16AM +0200, Thomas Gleixner wrote:
> > If you can point me to a single instance of Linus "abusing" someone
> > who is not one of his trusted persons, who really should be able to
> > deal with that, or someone who did not provoke him to go into rant
> > mode, then I'm all on your side.
> 
> Not that I think this link will sway you, and this thread *should*
> really die down so we can discuss this at KS instead:
> 
> https://plus.google.com/+LinusTorvalds/posts/1vyfmNCYpi5
> 
> "So here's a plea: if you have anything to do with security in a distro,
> and think that my kids (replace "my kids" with "sales people on the
> road" if you think your main customers are businesses) need to have the
> root password to access some wireless network, or to be able to print
> out a paper, or to change the date-and-time settings, please just kill
> yourself now. The world will be a better place."
> 
> Linus asked someone to go kill themselves. [...]

No, he did not.

He, as he declared it in the first stentences of his post, was venting and 
cursing:

   Venting.

   I don't think I can talk about "security" people without cursing, so
   you might want to avert your eyes now.

I'm, as the author of several security patches, partly a distro "security 
person" too, and I was not offended, I took away the message from Linus:

don't "fix" perceived security threats by cumbersome security measures, 
because users will address that by creating even larger security threats:

   http://www.merseyworld.com/precinct/Apr99/prec8.html

Thanks,

	Ingo
