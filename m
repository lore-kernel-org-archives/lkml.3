Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3GIR5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:57:54 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:35656 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3GIR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:57:53 -0400
Date: Tue, 9 Jul 2013 19:57:49 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130709175749.GA31848@dhcp22.suse.cz>
References: <20130701012558.GB27780@dastard>
 <20130701075005.GA28765@dhcp22.suse.cz>
 <20130701081056.GA4072@dastard>
 <20130702092200.GB16815@dhcp22.suse.cz>
 <20130702121947.GE14996@dastard>
 <20130702124427.GG16815@dhcp22.suse.cz>
 <20130703112403.GP14996@dastard>
 <20130704163643.GF7833@dhcp22.suse.cz>
 <20130708125352.GC20149@dhcp22.suse.cz>
 <20130709173242.GA9098@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709173242.GA9098@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-07-13 21:32:51, Glauber Costa wrote:
[...]
> You seem to have switched to XFS.

Yes, to make sure that the original hang is not fs specific. I can
switch to other fs if it helps. This seems to be really hard to
reproduce now so I would rather not change things if possible.

> Dave posted a patch two days ago fixing some missing conversions in
> the XFS side. AFAIK, Andrew hasn't yet picked the patch.

Could you point me to those patches, please?

> Are you running with that patch applied?

I am currently running with "list_lru: fix broken LRU_RETRY behaviour"

-- 
Michal Hocko
SUSE Labs
