Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3HEI7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:59:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab3HEI7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:59:24 -0400
Date: Mon, 5 Aug 2013 10:59:22 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm, page_alloc: add likely macro to help compiler
 optimization
Message-ID: <20130805085922.GE10146@dhcp22.suse.cz>
References: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130802162722.GA29220@dhcp22.suse.cz>
 <20130802204710.GX715@cmpxchg.org>
 <20130802213607.GA4742@dhcp22.suse.cz>
 <20130805081008.GF27240@lge.com>
 <20130805085041.GG27240@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805085041.GG27240@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-08-13 17:50:41, Joonsoo Kim wrote:
[...]
> IMHO, although there is no effect, it is better to add likely macro,
> because arrangement can be changed from time to time without any
> consideration of assembly code generation. How about your opinion,
> Johannes and Michal?

This is a matter of taste. I do not like new *likely annotations if they
do not make difference. But no strong objections if others like it.
-- 
Michal Hocko
SUSE Labs
