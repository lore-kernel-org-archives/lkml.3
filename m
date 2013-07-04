Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3GDQQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:16:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab3GDQQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:16:43 -0400
Date: Thu, 4 Jul 2013 18:16:41 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Honor min_free_kbytes set by user
Message-ID: <20130704161641.GD7833@dhcp22.suse.cz>
References: <1372954036-16988-1-git-send-email-mhocko@suse.cz>
 <1372954239.1886.40.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372954239.1886.40.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-07-13 09:10:39, Joe Perches wrote:
> On Thu, 2013-07-04 at 18:07 +0200, Michal Hocko wrote:
> > A warning is printed when the new value is ignored.
> 
> []
> 
> > +		printk(KERN_WARNING "min_free_kbytes is not updated to %d"
> > +				"because user defined value %d is preferred\n",
> > +				new_min_free_kbytes, user_min_free_kbytes);
> 
> Please use pr_warn and coalesce the format.

Sure can do that. mm/page_alloc.c doesn't seem to be unified in that
regards (44 printks and only 4 pr_<foo>) so I used printk.

> You'd've noticed a missing space between %d and because.

True

Thanks
-- 
Michal Hocko
SUSE Labs
