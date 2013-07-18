Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3GRDBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:01:36 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45547 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3GRDBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:01:34 -0400
Date: Wed, 17 Jul 2013 23:00:54 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ric Wheeler <ricwheeler@gmail.com>, David Lang <david@lang.hm>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Olivier Galibert <galibert@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Message-ID: <1913177574.2417392.1374116454346.JavaMail.root@redhat.com>
In-Reply-To: <20130717144849.GB16513@xanatos>
References: <20130715204135.GH15531@xanatos> <20130716224357.GK4994@xanatos> <1374015299.6458.76.camel@gandalf.local.home> <20130716231217.GL4994@xanatos> <51E5D7C8.5000306@gmail.com> <1374018809.2249.29.camel@leira.trondhjem.org> <1000066089.1803398.1374046596236.JavaMail.root@redhat.com> <20130717144849.GB16513@xanatos>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: How to act on LKML
Thread-Index: 0ak6UtPbtOOzm2X/44qbS3Q3Eku1kA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Trond Myklebust" <Trond.Myklebust@netapp.com>, "Ric Wheeler" <ricwheeler@gmail.com>, "David Lang"
> <david@lang.hm>, ksummit-2013-discuss@lists.linuxfoundation.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
> "Darren Hart" <dvhart@linux.intel.com>, "Ingo Molnar" <mingo@kernel.org>, "Olivier Galibert" <galibert@pobox.com>,
> "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, "stable" <stable@vger.kernel.org>, "Linus Torvalds"
> <torvalds@linux-foundation.org>, "Willy Tarreau" <w@1wt.eu>
> Sent: Wednesday, July 17, 2013 10:48:49 PM
> Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
> 
> On Wed, Jul 17, 2013 at 03:36:36AM -0400, CAI Qian wrote:
> > > On Tue, 2013-07-16 at 19:31 -0400, Ric Wheeler wrote:
> > > > On 07/16/2013 07:12 PM, Sarah Sharp wrote:
> > > > > On Tue, Jul 16, 2013 at 06:54:59PM -0400, Steven Rostedt wrote:
> > > > >> On Tue, 2013-07-16 at 15:43 -0700, Sarah Sharp wrote:
> > > > > In order to make our community better, we need to figure out where
> > > > > the
> > > > > baseline of "good" behavior is.  We need to define what behavior we
> > > > > want
> > > > > from both maintainers and patch submitters.  E.g. "No regressions"
> > > > > and
> > > > > "don't break userspace" and "no personal attacks".  That needs to be
> > > > > written down somewhere, and it isn't.  If it's documented somewhere,
> > > > > point me to the file in Documentation.  Hint: it's not there.
> > > > >
> > > > > That is the problem.
> > > > >
> > > > > Sarah Sharp
> > > > 
> > > > The problem you are pointing out - and it is a problem - makes us less
> > > > effective
> > > > as a community.
> > > 
> > > Not really. Most of the people who already work as part of this
> > > community are completely used to it. We've created the environment, and
> > > have no problems with it.
> > > 
> > > Where it could possibly be a problem is when it comes to recruiting
> > > _new_ members to our community. Particularly so given that some
> > > journalists take a special pleasure in reporting particularly juicy
> > > comments and antics. That would tend to scare off a lot of gun-shy
> > > newbies.
> > >
> > > On the other hand, it might tend to bias our recruitment toward people
> > > of a more "special" disposition. Perhaps we finally need the services of
> > > a social scientist to help us find out...
> >
> > Does that sound like there are not going to have enough direct/thick skin
> > new kernel developers around to maintain the future Linux community? Maybe
> > just need a better pipeline for people comfortable for this culture?
> 
> No, we don't need a better pipeline for people who can "put up with
> shit".  We need a better pipeline for people who can work together
> civilly, and still get shit done.
> 
> I'm working on getting a pipeline of women into kernel development,
> through the FOSS Outreach Program for Women.  They slowly get introduced
> to Linux development culture, starting with a very friendly separate
> mailing list and IRC channel, and finally moving to work with a kernel
> mentor on a bigger project on the main Linux kernel development lists.
> We have seven women participating this round, and I suspect we'll have
> even more the next round.
> 
> So deal with it.  You're going to have a lot more women in the kernel
> community, and not all of them will be willing to put up with verbal
> abuse.  If you want to attract top talent that also happen to be women
> or racial minorities, the verbal abuse needs to stop.
Maybe we need something like this?
http://us.battle.net/en/community/conduct
> 
> Sarah Sharp
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
