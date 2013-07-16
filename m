Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3GPCn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:43:58 -0400
Received: from void.printf.net ([89.145.121.20]:58895 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab3GPCn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:43:56 -0400
From: Chris Ball <cjb@laptop.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [ATTEND] How to act on LKML
References: <20130715174659.GC15531@xanatos>
	<CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	<20130715180403.GD15531@xanatos>
	<CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	<20130715184642.GE15531@xanatos>
	<CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	<20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos>
	<CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	<1373926109.17876.221.camel@gandalf.local.home>
	<20130715223615.GI15531@xanatos> <1373932170.28142.24.camel@envy.home>
Date: Tue, 16 Jul 2013 03:43:37 +0100
In-Reply-To: <1373932170.28142.24.camel@envy.home> (Darren Hart's message of
	"Mon, 15 Jul 2013 16:49:30 -0700")
Message-ID: <864nbv9qcm.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 16 2013, Darren Hart wrote:
> On Mon, 2013-07-15 at 15:36 -0700, Sarah Sharp wrote:
>> The people who want to work together in a civil manner should get
>> together and create a "Kernel maintainer's code of conduct" that
>> outlines what they expect from fellow kernel developers.  The people who
>> want to continue acting "unprofessionally" should document what
>> behaviors set off their cursing streaks, so that others can avoid that
>> behavior.  Somewhere in the middle is the community behavior all
>> developers can thrive in.
>> 
>> Some people won't agree with everything in that document.  The point is,
>> they don't have to agree.  They can read the document, figure out what
>> the community expects, and figure out whether they can modify their
>> behavior to match.  If they are unwilling to change, they simply don't
>> have to work with the developers who have signed it.
>> 
>> Perhaps a trusted third party could take a stab at a first draft of this
>> document?  Greg KH?  Steve Rostedt?  Darren Hart?
>
> [..]
> I do believe that someone from the intended audience of a document
> should be the one to write the first draft (or they should be among the
> reviewers if the authority drafts the document). For instance, I
> believe I would be able to document how to work with -tip or -stable as
> an individual contributor. I would not be a good candidate for writing
> the "how to be a lieutenant to Linus" because I am neither Linus nor
> one of his lieutenants.

Here's a simple statement that I hope many kernel developers would
sign up for -- I'd be happy to make it for the subsystem I maintain:

* If there's something wrong with your patch, I will critique the
  code respectfully, without personal attacks or public humiliation.

I'd like other developers to treat me this way too, but perhaps a good
way to get started is to first come up with a statement of how we'd
like to treat others, and then start collecting signatories to it.
Does that sound like a good idea?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
