Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab3GPXua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:50:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38421 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933898Ab3GPXu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:50:28 -0400
Date: Tue, 16 Jul 2013 19:50:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Olivier Galibert <galibert@pobox.com>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML (was: [
 00/19] 3.10.1-stable review)
Message-ID: <20130716235008.GC9371@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Olivier Galibert <galibert@pobox.com>, David Lang <david@lang.hm>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Darren Hart <dvhart@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Willy Tarreau <w@1wt.eu>, stable <stable@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>
References: <20130715195316.GF15531@xanatos>
 <20130715204135.GH15531@xanatos>
 <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
 <1373926109.17876.221.camel@gandalf.local.home>
 <20130715223615.GI15531@xanatos>
 <alpine.DEB.2.02.1307160025250.16723@nftneq.ynat.uz>
 <CAMFK0gseVAyCNwM6+-5ChJP5ReodjBA-estzB0u_pEhk2bAQsw@mail.gmail.com>
 <20130716211235.GG4994@xanatos>
 <20130716212704.GB9371@thunk.org>
 <20130716224357.GK4994@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716224357.GK4994@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 03:43:57PM -0700, Sarah Sharp wrote:
> I don't think we disagree on this, Ted.  I've stated that I view
> personal attacks and insults negatively, and I don't see an issue with
> pointing out that code is bad.  I think you're agreeing with me on this.

Perhaps I misundrestood you, then; when you replied to Olivier's
message, which used as his example "your code is crap", and "Let's
leverage my fifth grade nephew's capabilities to assist you in fixing
the code", it seemed to me that you called one a "personal attack",
and the other an "indirect personal insults".

If we're trying to say that "words matter", then it would be useful if
we are careful in what we describe as "a personal atack", and what
gets described as "abuse".

For example, when you brought up the example of Linus yelling at
Mauro, most of what I saw was Linus "yelling" (electronically) about
his behaviour being unacceptable.  I saw mostly, "your behaviour is
idiotic", not "you are an idiot".  Which perhaps is a finer gradation
than the difference between "your code is crap" and "you are crap".
Still, while I might call Linus's words to Mauro many things, "a
personal attack" wouldn't have been one of those words.  Emphatic?
Yes.  Yelling?  Yes.  Something I wouldn't do?  Probably.  But "A
personal attack"?  I'm not so sure.

And then when you start reading comments from folks forua suc as G+
and Hacker News calling Linus "a dick" or "a douchebag", the irony is
quite palpable....

> > Keep in mind that there are some cultures where even pointing out a
> > technical flaw in code might considered bringing deep shame on the
> > engineer and their company.  So how sensitive people are to criticism
> > during an electronic exchange is always going to be highly culutrally
> > and personally variable.
> 
> Yes, that's true.  Some kernel developers are better at moderating their
> comments and tone towards individuals who are "sensitive".  

... and actually, I think it's actually quite difficult to find cases
where Linus has used a very harsh tone towards someone who would be
"sensitive".  The argument which I've more commonly heard is one of
"collatoral damage".  That is, that people other than the transgressor
of the bad behaviour see Linus's messages, and (a) don't realize that
the vast majority of his e-mails are not that harsh, and (b) assume
that Linus would use that language on them.

And certainly that is a downside of sending messages of chastisement
publically rather than privately.  I doubt that neither Linus nor you
would disagee that there is a downside tradeoff.  On the other hand,
if such messages are sent priviately, they are much less useful as far
as establishing community norms around technical excellence,
especially in regards to "no regressions" and "don't break userspace".
I suspect that you and he come down on different sides of the
question, "is it worth the tradeoff".

The other question where I think you and Linus differ is the belief
whether polite messages of the form, "it's really rude to break the
kernel ABI, I would rather prefer if you wouldn't do that" are as
effective at establishing community norms, compared with his style of
e-mail messagtes, and whether the priority in establishing community
norms around technical excellence compares with the priority around
community norms around "civility".

(And of course, what is considered "civil", and what is considered a
"personal attack", and what isn't.)

Hopefully this helps to clarify the discussion.  I'm trying rather
purposely not take one side or another, but instead trying to
articulate what I think I've been hearing people say (over, and over,
and over again, on this very long mail thread).

Regards,

						- Ted
