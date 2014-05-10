Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbaEJBTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 21:19:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50113 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaEJBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 21:19:17 -0400
Date: Fri, 9 May 2014 18:19:13 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] UBI: fix rb_tree node comparison in add_map
Message-ID: <20140510011913.GH28907@ld-irv-0074>
References: <20140321195403.GA32529@redhat.com>
 <532CD1CB.4070707@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532CD1CB.4070707@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Sat, Mar 22, 2014 at 12:56:59AM +0100, Richard Weinberger wrote:
> Am 21.03.2014 20:54, schrieb Mike Snitzer:
> > The comparisons used in add_vol() shouldn't be identical.  Pretty sure
> > the following is correct but it is completely untested.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/mtd/ubi/fastmap.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > NOTE: I stumbled upon this code while implementing some rb_tree code
> >       (and looking for some existing rb_tree code as a reference).
> 
> Thanks a lot for pointing this out!
> 
> Acked-by: Richard Weinberger <richard@nod.at>

Bump?

I'm passing through my queue, and I occasionally see some obvious,
reviewed fixes like this one. Typically, you get around to them
eventually, but you never know. Do you prefer the "bump"?

Brian
