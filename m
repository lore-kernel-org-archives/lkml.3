Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3FRI0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:26:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab3FRI02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:26:28 -0400
Date: Tue, 18 Jun 2013 10:26:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130618082626.GE13677@dhcp22.suse.cz>
References: <20130617141822.GF5018@dhcp22.suse.cz>
 <20130617151403.GA25172@localhost.localdomain>
 <20130617143508.7417f1ac9ecd15d8b2877f76@linux-foundation.org>
 <20130617223004.GB2538@localhost.localdomain>
 <20130618081931.GB13677@dhcp22.suse.cz>
 <20130618082132.GC20528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618082132.GC20528@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-06-13 12:21:33, Glauber Costa wrote:
> On Tue, Jun 18, 2013 at 10:19:31AM +0200, Michal Hocko wrote:
[...]
> > No this is ext3. But I can try to test with xfs as well if it helps.
> > [...]
> 
> XFS won't help this, on the contrary. The reason I asked is because XFS
> uses list_lru for its internal structures as well. So it is actually preferred
> if you are reproducing this without it, so we can at least isolate that part.

OK

-- 
Michal Hocko
SUSE Labs
