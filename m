Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3F0RmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:42:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3F0RmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:42:16 -0400
Date: Thu, 27 Jun 2013 19:42:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Minchan Kim <minchan@kernel.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, anton@enomsg.org,
        akpm@linux-foundation.org, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130627174211.GB25165@dhcp22.suse.cz>
References: <20130626231712.4a7392a7@redhat.com>
 <20130627092616.GB17647@dhcp22.suse.cz>
 <20130627155357.GC5006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627155357.GC5006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-06-13 00:53:57, Minchan Kim wrote:
> On Thu, Jun 27, 2013 at 11:26:16AM +0200, Michal Hocko wrote:
[...]
> > I still think that edge triggering makes some sense but that one might
> > be rebased on top of this patch. We should still figure out whether the
> > edge triggering is the right approach for the use case Hyunhee Kim wants
> > it for so the strict mode should go first IMO.
> 
> For me, edge trigger as avoiding excessive event sending doesn't make sense
> at all so I'd like to merge strict mode firstly, too.

Yes, it makes sense for once-per-level actions, not as a workaround.
[...]
-- 
Michal Hocko
SUSE Labs
