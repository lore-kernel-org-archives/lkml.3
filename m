Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3GOTRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:17:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34663 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab3GOTRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:17:49 -0400
Date: Mon, 15 Jul 2013 21:17:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130715191727.GC10157@1wt.eu>
References: <20130715155202.GC29526@xanatos> <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com> <20130715174659.GC15531@xanatos> <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715184642.GE15531@xanatos>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sarah,

On Mon, Jul 15, 2013 at 11:46:42AM -0700, Sarah Sharp wrote:
> On Mon, Jul 15, 2013 at 11:17:06AM -0700, Linus Torvalds wrote:
> > On Mon, Jul 15, 2013 at 11:04 AM, Sarah Sharp
> > <sarah.a.sharp@linux.intel.com> wrote:
> > >
> > > However, I am serious about this.  Linus, you're one of the worst
> > > offenders when it comes to verbally abusing people and publicly tearing
> > > their emotions apart.
> > 
> > Yes. And I do it partly (mostly) because it's who I am, and partly
> > because I honestly despise being subtle or "nice".
> > 
> > The fact is, people need to know what my position on things are. And I
> > can't just say "please don't do that", because people won't listen. I
> > say "On the internet, nobody can hear you being subtle", and I mean
> > it.
> > 
> > And I definitely am not willing to string people along, either. I've
> > had that happen too - not telling people clearly enough that I don't
> > like their approach, they go on to re-architect something, and get
> > really upset when I am then not willing to take their work.
> 
> You can tell developers in no uncertain terms that you're not willing to
> take their work *without* verbally tearing them apart.  You're Linus
> Torvalds, for crying out loud!  I simple, "No, that's a bad idea, stop
> working on this RIGHT now," is more than enough from you.  If it's not,
> well, those people are just dense and can probably put up with stronger
> language.

Communication works two ways. You feel emotions based on your references
and on the references you're used from the other person. Most of us have
already been scolded by Linus, and while it usually is an unpleasant moment,
I do think that it's efficient and (it might surprise you) probably a mark
of respect. Please re-read some of the famous public flames from Linus.
When he tells you "stop saying such idiocies, you're a f*cking moron", he
doesn't really mean that, he means that he's very disappointed that *that
person* says this or that, so he takes the time to say it to that person.
The proof is that most often in the next mail he explains to the person
how to do the thing right. He just tries to ensure that the person he's
telling words to understands that he/she has crossed a line.

Sure it can be hard for newcomers but I don't remember having read him
scold a newcomer. So that's probably not that much of a problem in the
end, and helps getting the things done in time. I'm much more concerned
by the "administrative" development mode that we're taking in fact and
that some people seem to have expressed in this thread (what patch flow
to follow, when to send/not to send, etc...).

BTW, I was amazed that you managed to get him have a much softer tone inr
his last e-mail, you probably found a weakness here in his management
process :-)

Best regards,
Willy

