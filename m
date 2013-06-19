Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3FSN5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:57:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3FSN5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:57:19 -0400
Date: Wed, 19 Jun 2013 15:57:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130619135716.GA21014@dhcp22.suse.cz>
References: <20130617141822.GF5018@dhcp22.suse.cz>
 <20130617151403.GA25172@localhost.localdomain>
 <20130617143508.7417f1ac9ecd15d8b2877f76@linux-foundation.org>
 <20130617223004.GB2538@localhost.localdomain>
 <20130618062623.GA20528@localhost.localdomain>
 <20130619071346.GA9545@dhcp22.suse.cz>
 <20130619073526.GB1990@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619073526.GB1990@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-06-13 11:35:27, Glauber Costa wrote:
[...]
> Sorry if you said that before Michal.
> 
> But given the backtrace, are you sure this is LRU-related?

No idea. I just know that my mm tree behaves correctly after the whole
series has been reverted (58f6e0c8fb37e8e37d5ac17a61a53ac236c15047) and
before the latest version of the patchset has been applied.

> You mentioned you bisected it but found nothing conclusive.

Yes, but I was interested in crashes and not hangs so I will try it
again.

I really hope this is not just some stupidness in my tree.

> I will keep looking but maybe this could benefit from
> a broader fs look
> 
> In any case, the patch we suggested is obviously correct and we should
> apply nevertheless.  I will write it down and send it to Andrew.

OK, feel free to stick my Tested-by there.

-- 
Michal Hocko
SUSE Labs
