Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3GWC5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:57:51 -0400
Received: from mx11.netapp.com ([216.240.18.76]:60066 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3GWC5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:57:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,723,1367996400"; 
   d="scan'208";a="35704785"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Thread-Topic: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Thread-Index: AQHOgZF64KBTv4md/0uNlNK9ZDV2fJlyDhiAgAAB8wCAAALoAA==
Date: Tue, 23 Jul 2013 02:57:32 +0000
Message-ID: <1374548250.2413.18.camel@leira.trondhjem.org>
References: <1373916476.2748.69.camel@dabdike>
	 <1374547207.2413.7.camel@leira.trondhjem.org>
	 <1374547626.2335.82.camel@dabdike>
In-Reply-To: <1374547626.2335.82.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <65497D854F3133419103C830C57DC69C@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6N2vup9015724

On Mon, 2013-07-22 at 19:47 -0700, James Bottomley wrote:
> On Tue, 2013-07-23 at 02:40 +0000, Myklebust, Trond wrote:
> > On Mon, 2013-07-15 at 23:27 +0400, James Bottomley wrote:
> > > The solution, to me, looks simple:  Let's co-opt a process we already
> > > know how to do: mailing list review and tree handling.  So the proposal
> > > is simple:
> > > 
> > >      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
> > >         reviewed patch to stable
> > >      2. All patches to stable should follow current review rules: They
> > >         should go to the mailing list the original patch was sent to
> > >         once the original is upstream as a request for stable.
> > >      3. Following debate on the list, the original maintainer would be
> > >         responsible for collecting the patches (including the upstream
> > >         commit) adjudicating on them and passing them on to stable after
> > >         list review (either by git tree pull or email to stable@).
> > > 
> > > I contend this raises the bar for adding patches to stable much higher,
> > > which seems to be needed, and adds a review stage which involves all the
> > > original reviewers.
> > 
> > Could we keep the Cc: stable tag itself, since the dependency
> > information ("Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched:
> > Check for idle") is actually very useful? If we discard that, then we
> > really should revise the whole stable system, since it would mean that
> > we are in effect discarding the 'upstream first' rule.
> 
> The two don't follow.  No-one's proposing to dump the must be upstream
> rule.  The proposal is to modify the automatic behaviour that leads to
> over tagging for stable and consequently too many "stable" patches that
> aren't really.

My point was that the _tag_ is useful as a list of dependencies for
something that we thing might need to be backported to older kernels.
I'd like to see us keep that information somehow.

Whether or not we interpret it as being an automatic "for stable"
request is a different matter. I'd be quite happy to see the "propose
for stable" step as reverting to being a manual step that occurs only
after we've upstreamed the fix.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
