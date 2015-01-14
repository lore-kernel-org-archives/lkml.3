Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbbANSiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:38:04 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20952 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbbANSiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:38:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+jLawXw37h63JxNP3uEqX+/eaY4fgPuCY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 68AF06463DD
Date: Wed, 14 Jan 2015 13:37:56 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: shirish gajera <gajerashirish@gmail.com>
Cc: gregkh@linuxfoundation.org, Eric Rost <eric.rost@mybabylon.net>,
        jake@lwn.net, Anton Saraev <antonysaraev@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: skein: Remove all do{} while (0) loop from
 single statement.
Message-ID: <20150114183756.GA24989@titan.lakedaemon.net>
References: <20150111234105.GA2744@shirish-ThinkPad-Edge-E430>
 <20150112141516.GX24989@titan.lakedaemon.net>
 <CAG77vrojhVij2154vDxCxE9vPDPfP2QuJaKFcAz4pErW_pLRVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG77vrojhVij2154vDxCxE9vPDPfP2QuJaKFcAz4pErW_pLRVQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shirish,

Please don't toppost, I've corrected it below.

On Mon, Jan 12, 2015 at 11:14:57AM -0800, shirish gajera wrote:
> On Mon, Jan 12, 2015 at 6:15 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Sun, Jan 11, 2015 at 03:41:05PM -0800, Shirish Gajera wrote:
> > > This patch fixes the checkpatch.pl warning:
> > >
> > > WARNING: Single statement macros should not use a do {} while (0) loop
> > >
> > > I remove do while from the single statement macro.
> > >
> > > Signed-off-by: Shirish Gajera <gajerashirish@gmail.com>
> > > ---
> > >  drivers/staging/skein/skein_block.c | 31 +++++++++----------------------
> > >  1 file changed, 9 insertions(+), 22 deletions(-)
> >
> > Several people have submitted patches for this checkpatch warning.
> > Please check the mailinglist archives and deconflict with the other
> > submitters.
> 
> It did't see any other submitter in script.
> 
> Is there any other way to check ?

The mailing list for the linux-staging tree is rather arcane to find,
it's not linux-staging@...  Here's the link for joining:

  http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

And here's the archives:

  http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/

hth,

Jason.
