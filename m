Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaEMJIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:08:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:6574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbaEMJIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="539485386"
Message-ID: <1399972089.1797.29.camel@sauron.fi.intel.com>
Subject: Re: [RFC PATCH] UBI: fix rb_tree node comparison in add_map
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, Mike Snitzer <snitzer@redhat.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 13 May 2014 12:08:09 +0300
In-Reply-To: <20140510011913.GH28907@ld-irv-0074>
References: <20140321195403.GA32529@redhat.com> <532CD1CB.4070707@nod.at>
	 <20140510011913.GH28907@ld-irv-0074>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 18:19 -0700, Brian Norris wrote:
> Hi Artem,
> 
> On Sat, Mar 22, 2014 at 12:56:59AM +0100, Richard Weinberger wrote:
> > Am 21.03.2014 20:54, schrieb Mike Snitzer:
> > > The comparisons used in add_vol() shouldn't be identical.  Pretty sure
> > > the following is correct but it is completely untested.
> > > 
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > ---
> > >  drivers/mtd/ubi/fastmap.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > NOTE: I stumbled upon this code while implementing some rb_tree code
> > >       (and looking for some existing rb_tree code as a reference).
> > 
> > Thanks a lot for pointing this out!
> > 
> > Acked-by: Richard Weinberger <richard@nod.at>
> 
> Bump?
> 
> I'm passing through my queue, and I occasionally see some obvious,
> reviewed fixes like this one. Typically, you get around to them
> eventually, but you never know. Do you prefer the "bump"?

I'll pick this now, thanks for pointing. And yes, a "bump" is helpful.
E.g., I missed this ones.

-- 
Best Regards,
Artem Bityutskiy

