Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3GWCrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:47:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59360 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab3GWCrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:47:08 -0400
Message-ID: <1374547626.2335.82.camel@dabdike>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Mon, 22 Jul 2013 19:47:06 -0700
In-Reply-To: <1374547207.2413.7.camel@leira.trondhjem.org>
References: <1373916476.2748.69.camel@dabdike>
	 <1374547207.2413.7.camel@leira.trondhjem.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 02:40 +0000, Myklebust, Trond wrote:
> On Mon, 2013-07-15 at 23:27 +0400, James Bottomley wrote:
> > The solution, to me, looks simple:  Let's co-opt a process we already
> > know how to do: mailing list review and tree handling.  So the proposal
> > is simple:
> > 
> >      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
> >         reviewed patch to stable
> >      2. All patches to stable should follow current review rules: They
> >         should go to the mailing list the original patch was sent to
> >         once the original is upstream as a request for stable.
> >      3. Following debate on the list, the original maintainer would be
> >         responsible for collecting the patches (including the upstream
> >         commit) adjudicating on them and passing them on to stable after
> >         list review (either by git tree pull or email to stable@).
> > 
> > I contend this raises the bar for adding patches to stable much higher,
> > which seems to be needed, and adds a review stage which involves all the
> > original reviewers.
> 
> Could we keep the Cc: stable tag itself, since the dependency
> information ("Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched:
> Check for idle") is actually very useful? If we discard that, then we
> really should revise the whole stable system, since it would mean that
> we are in effect discarding the 'upstream first' rule.

The two don't follow.  No-one's proposing to dump the must be upstream
rule.  The proposal is to modify the automatic behaviour that leads to
over tagging for stable and consequently too many "stable" patches that
aren't really.

James


