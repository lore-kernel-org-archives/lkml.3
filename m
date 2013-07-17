Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3GQHh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:37:26 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:53137 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3GQHhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:37:24 -0400
Date: Wed, 17 Jul 2013 03:36:36 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Olivier Galibert <galibert@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Message-ID: <1000066089.1803398.1374046596236.JavaMail.root@redhat.com>
In-Reply-To: <1374018809.2249.29.camel@leira.trondhjem.org>
References: <20130715204135.GH15531@xanatos> <20130716211235.GG4994@xanatos> <20130716212704.GB9371@thunk.org> <20130716224357.GK4994@xanatos> <1374015299.6458.76.camel@gandalf.local.home> <20130716231217.GL4994@xanatos> <51E5D7C8.5000306@gmail.com> <1374018809.2249.29.camel@leira.trondhjem.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
Thread-Index: AQHOgnyhuQh8jTV/+kG8V/CLVwm7h5lob7aApcR/YSY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Trond Myklebust" <Trond.Myklebust@netapp.com>
> To: "Ric Wheeler" <ricwheeler@gmail.com>
> Cc: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>, "David Lang" <david@lang.hm>,
> ksummit-2013-discuss@lists.linuxfoundation.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Darren Hart"
> <dvhart@linux.intel.com>, "Ingo Molnar" <mingo@kernel.org>, "Olivier Galibert" <galibert@pobox.com>, "Linux Kernel
> Mailing List" <linux-kernel@vger.kernel.org>, "stable" <stable@vger.kernel.org>, "Linus Torvalds"
> <torvalds@linux-foundation.org>, "Willy Tarreau" <w@1wt.eu>
> Sent: Wednesday, July 17, 2013 7:53:30 AM
> Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
> 
> On Tue, 2013-07-16 at 19:31 -0400, Ric Wheeler wrote:
> > On 07/16/2013 07:12 PM, Sarah Sharp wrote:
> > > On Tue, Jul 16, 2013 at 06:54:59PM -0400, Steven Rostedt wrote:
> > >> On Tue, 2013-07-16 at 15:43 -0700, Sarah Sharp wrote:
> > >>
> > >>> Yes, that's true.  Some kernel developers are better at moderating
> > >>> their
> > >>> comments and tone towards individuals who are "sensitive".  Others
> > >>> simply don't give a shit.  So we need to figure out how to meet
> > >>> somewhere in the middle, in order to establish a baseline of civility.
> > >> I have to ask this because I'm thick, and don't really understand,
> > >> but ...
> > >>
> > >> What problem exactly are we trying to solve here?
> > > Personal attacks are not cool Steve.  Some people simply don't care if a
> > > verbal tirade is directed at them.  Others do not want anyone to attack
> > > them personally, but they're fine with people attacking their code.
> > >
> > > Bystanders that don't understand the kernel community structure are
> > > discouraged from contributing because they don't want to be verbally
> > > abused, and they really don't want to see either personal attacks or
> > > intense belittling, demeaning comments about code.
> > >
> > > In order to make our community better, we need to figure out where the
> > > baseline of "good" behavior is.  We need to define what behavior we want
> > > from both maintainers and patch submitters.  E.g. "No regressions" and
> > > "don't break userspace" and "no personal attacks".  That needs to be
> > > written down somewhere, and it isn't.  If it's documented somewhere,
> > > point me to the file in Documentation.  Hint: it's not there.
> > >
> > > That is the problem.
> > >
> > > Sarah Sharp
> > 
> > The problem you are pointing out - and it is a problem - makes us less
> > effective
> > as a community.
> 
> Not really. Most of the people who already work as part of this
> community are completely used to it. We've created the environment, and
> have no problems with it.
> 
> Where it could possibly be a problem is when it comes to recruiting
> _new_ members to our community. Particularly so given that some
> journalists take a special pleasure in reporting particularly juicy
> comments and antics. That would tend to scare off a lot of gun-shy
> newbies.
> On the other hand, it might tend to bias our recruitment toward people
> of a more "special" disposition. Perhaps we finally need the services of
> a social scientist to help us find out...
Does that sound like there are not going to have enough direct/thick skin
new kernel developers around to maintain the future Linux community? Maybe
just need a better pipeline for people comfortable for this culture?
> 
> --
> Trond Myklebust
> Linux NFS client maintainer
> 
> NetApp
> Trond.Myklebust@netapp.com
> www.netapp.com
> N�����r��y���b�X��ǧv�^�)޺{.n�+������z)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
