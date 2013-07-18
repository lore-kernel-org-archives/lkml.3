Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab3GRQH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:07:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:55230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759136Ab3GRQHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,694,1367996400"; 
   d="scan'208";a="347862566"
Date: Thu, 18 Jul 2013 09:07:54 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130718160754.GC5440@xanatos>
References: <20130715174659.GC15531@xanatos>
 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
 <20130715180403.GD15531@xanatos>
 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
 <20130715184642.GE15531@xanatos>
 <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
 <20130715195316.GF15531@xanatos>
 <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <20130718103907.GC23558@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718103907.GC23558@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:39:07PM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, Jul 15, 2013 at 1:41 PM, Sarah Sharp
> > <sarah.a.sharp@linux.intel.com> wrote:
> > >
> > > Oh, FFS, I just called out on private email for "playing the victim
> > > card".  I will repeat: this is not just about me, or other minorities.
> > > I should not have to ask for professional behavior on the mailing lists.
> > > Professional behavior should be the default.
> > 
> 
> > [...]
> > 
> > Because if you want me to "act professional", I can tell you that I'm 
> > not interested. I'm sitting in my home office wearign a bathrobe. The 
> > same way I'm not going to start wearing ties, I'm *also* not going to 
> > buy into the fake politeness, the lying, the office politics and 
> > backstabbing, the passive aggressiveness, and the buzzwords. Because 
> > THAT is what "acting professionally" results in: people resort to all 
> > kinds of really nasty things because they are forced to act out their 
> > normal urges in unnatural ways.
> 
> Sarah, that's a pretty potent argument by Linus, that "acting 
> professionally" risks replacing a raw but honest culture with a
> polished but dishonest culture - which is harmful to developing
> good technology.
> 
> That's a valid concern. What's your reply to that argument?

I don't feel the need to comment, because I feel it's a straw man
argument.  I feel that way because I disagree with the definition of
professionalism that people have been pushing.

To me, being "professional" means treating each other with respect.  I
can show emotion, express displeasure, be direct, and still show respect
for my fellow developers.

For example, I find the following statement to be both direct and
respectful, because it's criticizing code, not the person:

"This code is SHIT!  It adds new warnings and it's marked for stable
when it's clearly *crap code* that's not a bug fix.  I'm going to revert
this merge, and I expect a fix from you IMMEDIATELY."

The following statement is not respectful, because it targets the
person:

"Seriously, Maintainer.  Why are you pushing this kind of *crap* code to
me again?  Why the hell did you mark it for stable when it's clearly
not a bug fix?  Did you even try to f*cking compile this?"

I would appreciate it if people would replace the word "professional"
with "respectful" in this thread.  It means something different to me
than other people, and respect is much closer to what I'm looking for.

I would appreciate it if kernel developers would show respect for each
other, while focusing on criticizing code.  As Rusty said, be gentle
with people.  You've called their baby ugly.

Sarah Sharp
