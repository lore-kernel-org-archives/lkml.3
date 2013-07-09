Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3GIReP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:34:15 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45908 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3GIReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:34:14 -0400
Date: Tue, 9 Jul 2013 21:34:08 +0400
From: Glauber Costa <glommer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130709173407.GA9188@localhost.localdomain>
References: <20130701012558.GB27780@dastard>
 <20130701075005.GA28765@dhcp22.suse.cz>
 <20130701081056.GA4072@dastard>
 <20130702092200.GB16815@dhcp22.suse.cz>
 <20130702121947.GE14996@dastard>
 <20130702124427.GG16815@dhcp22.suse.cz>
 <20130703112403.GP14996@dastard>
 <20130704163643.GF7833@dhcp22.suse.cz>
 <20130708125352.GC20149@dhcp22.suse.cz>
 <20130708140419.d9079dd67111090beb6cef3d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708140419.d9079dd67111090beb6cef3d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 02:04:19PM -0700, Andrew Morton wrote:
> On Mon, 8 Jul 2013 14:53:52 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > > Good news! The test was running since morning and it didn't hang nor
> > > crashed. So this really looks like the right fix. It will run also
> > > during weekend to be 100% sure. But I guess it is safe to say
> > 
> > Hmm, it seems I was too optimistic or we have yet another issue here (I
> > guess the later is more probable).
> > 
> > The weekend testing got stuck as well. 
> > 
> > The dmesg shows there were some hung tasks:
> 
> That looks like the classic "we lost an IO completion" trace.
> 
> I think it would be prudent to defer these patches into 3.12.
Agree.

Will they still in -mm, or do I have to resend ?
