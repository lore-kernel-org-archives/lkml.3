Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab3GPUEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:04:04 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42018 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333Ab3GPUEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:04:00 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org
Subject: Re: [ATTEND] How to act on LKML (was: [ 00/19] 3.10.1-stable review)
Date: Tue, 16 Jul 2013 22:03:57 +0200
Message-ID: <8946487.gDYKKVgS4U@merkaba>
User-Agent: KMail/4.10.5 (Linux/3.10.0-tp520; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130715225003.GK15531@xanatos>
References: <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com> <CA+55aFwdYxfgE8B4oPVFXWTJUcnDKnM4cchZ=t08mFwEHX+TAA@mail.gmail.com> <20130715225003.GK15531@xanatos>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 15. Juli 2013, 15:50:03 schrieb Sarah Sharp:
> On Mon, Jul 15, 2013 at 03:38:42PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 15, 2013 at 3:08 PM, Steven Rostedt <rostedt@goodmis.org> 
> > wrote:
> > > Can we please make this into a Kernel Summit discussion. I highly doubt
> > > we would solve anything, but it certainly would be a fun segment to
> > > watch :-)
> > 
> > I think we should, because I think it's the kind of thing we really
> > need at the KS - talking about "process".
> > 
> > At the same time, I really don't know what the format would possibly
> > be like for it to really work as a reasonable discussion. And I think
> > that is important, because this kind of subject is *not* likely
> > possible in the traditional "people sit around tables and maybe
> > somebody has a few slides" format.
> > 
> > A small panel discussion with a few people (fiveish?) that have very
> > different viewpoints, along with baskets of rotten fruit set out on
> > the tables? That could be fun. And I'm serious, although we might want
> > to limit the size of the fruit to smaller berries ;)
> > 
> > Sarah will bring the brownies.
> 
> Peace pot brownies!  I love it!

I wish you good luck for that KS session!

As someone who brought up this topic before¹ I applaud for your courage to 
raise this as a kernel developer, Sarah. I took way less risk cause my only 
direct contribution to the kernel was a documentation patch in 2.6.28 and thus 
I have much less too loose. And Ingo treated me absolutely professionally back 
then. (You will find my name more often in changelog, regarding bug reporting 
and testing of fixes which is also an important activity I think.)

I didn´t think much about it since I brought up the topic and didn´t even yet 
search for studies that cursing is healthy as Linus suggested to me… partly 
due to putting focus to other more important topics in my life and partly 
possibly due to the thought that its just me having a problem with some of the 
tone on this list after having got the reactions I got in that thread.

I share some random thoughts for you, Linus and others, use them or leave them 
aside as you wish:

- I think that it is possible to a) clearly express one´s own oppinion and get 
a across the point and b) clearly make it obvious that this is about the 
matter at hand and no attack of the person on the receiving side of the 
feedback. Actually I do think this is just a plain simple communication 
*skill*, thus learnable. Well I studied something like this. I can share some 
key points of non-violent but still bringing across the point way of 
communicating if interested.

- I am with Linus in that its important to express own emotions before at 
times. And heck I saw you expressing your emotions here in this thread as 
well. There is never anything wrong with expressing a emotion as there is 
never anything wrong with the emotion as it is. But I do think its important 
to clearly do it as an *own* emotion. A emotion I have has to do with one 
person: Myself. It might be a reaction to a thought I have, maybe as a 
reaction to a feedback I got, buts it totally I am who is feeling that emotion 
and I am always in charge. Thus I have absolutely no issue with "I am totally 
feed up with this and this" or "I am really angry at this and this happening 
just again after having it explained here and there". But a comment like "you 
suck cause you did this" and "its your fault" is not okay for me. I am 
changing my behavior from avoiding these situations altogether to have it not 
happen to me – which is a typical pattern of people feeling abused and not 
guarenteed to work out – to expressing that it is so for me. And even more 
importantly to accept me as a person no matter whether Linus would be calling 
me names or what not as this helps me to get the courage to stand for myself. 
However at times I am still reluctant to post here for fear of getting 
attacked personally.

- I did read quite some of Linus posts, also angrier ones, and on a closer 
look I see that many of them do *not* contain a personal attack. I agree with 
some here that calling certain code crap *with* providing a reason for this 
actually is beneficial. And I think that if that is a personal attack for 
someone it is so cause the person identifies with her or his code. 
Understandable, but it is the problem of that person just as if Linus has a 
problem with a patch or a change it is *his* problem to deal with.

- I do think that a person won´t change cause I want him or her to change. 
Thus I think that Linus won´t change until he really wants to, Sarah, and I 
see absolutely no way how you can change him. Or vice versa. I can only ever 
change myself. Actually I think I did already. I trained myself to look more 
carefully at language which helped me to see that quite some of Linus language 
does not contain attacks against a person, but against the code. And I allowed 
myself to express my concerns about tone in this list *regardless* of the 
feedback that I may get. And I assured that I will stand for myself, no matter 
what others do to me. (Actually I still do not buy into the bad guy role that 
Linus plays at times. This I did not change.)

- Lastly I think I would be careful with the term abuse. For me an abuse 
implies that the abused is not able to avoid the treatment. Which may easily 
the case for a child being abused. Or for a woman who has less physical 
strength (and no experience with martial arts) than an abusive man. But as a 
grown up person posting and reading in a mailing list its always my own 
decision whether I buy into what I perceive as verbal attack *or not*. Whether 
I stand up and say "I am not taking this" or just take it in and hurt myself 
by doing it. How I react to something I receive is solely at my disposal. So I 
really enjoyed your "I won´t take this" to Linus.


So I think this is not about *changing* people. But I do think its important 
that a kernel developer like you spoke up and raised issues with the tone in 
this list.

So I end with a suggestion for the Kernel Summit discussion, take it or leave 
it:

As a first step let each one just express how he or she feels about this topic 
and what she or he expects to be treated as. And then as a first challenge just 
let these likely highly different view points stand beside each other and work 
from there.


PS: In my Linux trainings when I talk about that still most kernel developers 
are male I usually mention your USB 3 stack contribution as a notable example 
of a work by a female developer.


[1] Re: Linux 3.10-rc6, 16 Jun 2013:
https://lkml.org/lkml/2013/6/16/77

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
