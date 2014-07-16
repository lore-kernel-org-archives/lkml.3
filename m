Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030610AbaGPHVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:21:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43641 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030551AbaGPHVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:21:25 -0400
X-Sasl-enc: OFkRpxFTIIJNdM01ukg7vQcJ/mheC5KiLITwG/RVkyJu 1405495283
Message-ID: <1405495280.2527.84.camel@perseus.fritz.box>
Subject: Re: [PATCH 0/6] autofs4: support RCU-walk
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 15:21:20 +0800
In-Reply-To: <20140716160005.6c43668d@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <1405481098.2527.9.camel@perseus.fritz.box>
	 <20140716160005.6c43668d@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 16:00 +1000, NeilBrown wrote:
> On Wed, 16 Jul 2014 11:24:58 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> > > autofs4 currently doesn't support RCU-walk - it immediately
> > > aborts any attempt at RCU-walk to force REF-walk for path name
> > > lookup.
> > 
> > As discussed I don't have time to properly test these just now but I'll
> > do my best to review the patches and return to test them later.
> 
> Thanks.
> 
> > 
> > My impression is that you will be submitting these patches rather than
> > expecting me to pick them up and submit them. If that's not what your
> > expecting please let me know.
> 
> I had assumed that you would take them as you are listed as the maintainer.
> However if you would like me to send them on I can certainly do that.
> You seem to send via Andrew Morton so I'll do that when they seem to be ready
> if you like.

Either or, we can decide that once we're done with the patches.

I don't maintain an autofs tree because the module isn't volatile enough
to warrant it. I was sloppy with patches I sent to Linus a few times and
Andrew politely asked me to send them via him, and rightly so, ;)

I guess it comes down to how urgent it is to get these merged since I'd
like to hammer them with my submount test before passing them on and at
this point I don't know when I'll have time to work through that.

I could just set aside some time to run the test a few times and not try
and fix any problems at the time. Point being the test has a habit of
exposing problems that can be difficult to work out let alone fix.

Ian


